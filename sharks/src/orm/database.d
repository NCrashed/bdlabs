module orm.database;

public import orm.table;
import dpq2.all;
import std.stdio : writeln;
import std.concurrency;
import std.range;
import std.traits;
import core.time;
import core.thread;

class SelectException : Exception
{
	this()
	{
		super("Cannot select any row!");
	}
}

template Table(T)
{
	static assert(isAggregateType!T);
	alias string delegate(TableFormat!T) WhereGenerator;
}

class DataBase(string name, string timeoutDurUnits = "seconds", long timeoutLength = 5)
{
	alias DataBase!(name, timeoutDurUnits, timeoutLength) thisType;

	this()
	{
		this.conn = new Connection;
		spawn(&checkTimeoutThread, cast(shared)this);

	}

	this(string connString)
	{
		this();
		this.conn = new Connection;
		this.connString = connString;
		conn.connString = connString;
		conn.connect();
	}

	Connection connection() @property
	{
		return conn;
	}

	void connectionString(string val) @property
	{
		connString = val;
	}

	bool connected() @property
	{
		synchronized(this)
		{
			return conn.connected;
		}
	}

	void insert(Aggregate)(Aggregate val)
		if(isAggregateType!Aggregate)
	{
		checkConnection();
		auto tf = prepareTable!Aggregate();

		synchronized(this)
			conn.exec(tf.insertSQL(val));
	}

	void insert(R)(R vals)
		if(isInputRange!R)
	{
		alias ElementType!R Aggregate;
		static assert(isAggregateType!Aggregate, "insert can operate only with aggregate types!");

		checkConnection();
		auto tf = prepareTable!Aggregate();

		foreach(val; vals)
		{

			synchronized(this)
				conn.exec(tf.insertSQL(val));
		}
	}

	void update(Aggregate)(Aggregate val, string[] fields, string delegate(TableFormat!Aggregate tf) whereGenerator)
		if(isAggregateType!Aggregate)
	{
		checkConnection();
		auto tf = prepareTable!Aggregate();

		synchronized(this)
			conn.exec(tf.updateSQL(val, fields, whereGenerator));
	}

	Aggregate selectOne(Aggregate)(Table!(Aggregate).WhereGenerator whereGenerator)
	{
		checkConnection();
		auto tf = prepareTable!Aggregate();

		Answer s;
		synchronized(this)
			s = conn.exec(tf.selectSQL(1, whereGenerator));

		if(s.rowCount() > 0)
		{
			return tf.extractData(s[0]);
		}
		throw new SelectException();
	}

	Aggregate[] select(Aggregate)(size_t count, Table!(Aggregate).WhereGenerator whereGenerator, bool distinct = false)
	{
		checkConnection();
		auto tf = prepareTable!Aggregate();
		
		Answer s;
		synchronized(this)
			s = conn.exec(tf.selectSQL(count, whereGenerator, distinct));

		if(s.rowCount() > 0)
		{
			auto ret = new Aggregate[s.rowCount()];
			foreach(i; 0..s.rowCount())
			{
				ret[i] = tf.extractData(s[i]);
			}
			return ret;
		}
		throw new SelectException();
	}

	void remove(Aggregate)(size_t count, Table!(Aggregate).WhereGenerator whereGenerator)
	{
		checkConnection();
		auto tf = prepareTable!Aggregate();

		synchronized(this)
			conn.exec(tf.deleteSQL(count, whereGenerator));
	}

	bool hasTable()(string name)
	{
		checkConnection();

		Answer s;
		synchronized(this)
		{
			s = conn.exec("select * from pg_tables where schemaname='public'");
		}

		foreach(size_t i; 0..s.rowCount())
		{
			if(s[i][1].as!PGtext == name)
				return true;
		}

		return false;
	}

	bool hasTable(Aggregate)()
	{
		return hasTable(Aggregate.stringof);
	}

	bool compareTableFormat(T)(TableFormat!T tf)
	{
		checkConnection();
		
		Answer s;
		synchronized(this)
		{
			s = conn.exec("select column_name, data_type from information_schema.columns where table_name = '"~tf.name~"'");
		}
		
		if(s.rowCount() > 0 && s.rowCount() < tf.fieldTypes.length)
		{
			foreach(size_t i, type; tf.fieldTypes)
			{
				//writeln(s[i][0].as!PGtext, " ", s[i][1].as!PGtext);
				if(type2SQL!type != s[i][1].as!PGtext)
					return false;
			}
		}
		return true;
	}

	private void dropTable(T)(TableFormat!T tf)
	{
		checkConnection();
		if(!hasTable(tf.name)) return;

		synchronized(this)
			conn.exec(`DROP TABLE "`~tf.name~`" CASCADE`);
	}

	void dropTable(Aggregate)()
	{
		checkConnection();
		auto tf = prepareTable!Aggregate();

		dropTable(tf);
	}

	TableFormat!Aggregate prepareTable(Aggregate)()
	{
		auto tf = new TableFormat!Aggregate();
		if(hasTable(tf.name))
		{
			if(!compareTableFormat(tf))
			{
				///TODO: Сделать перестраивание таблицы без потерь данных
				throw new Exception("Detected table with same name ("~tf.name~") and different columns! Delete table or implement table rebuilder xD.");
			}
		} else
		{
			string query;

			alias getTableDependencies!(TableFormat!Aggregate) Depends;
			foreach(i, dep; Depends)
			{
				if(!hasTable!dep())
				{
					auto depTf = new TableFormat!dep();
					query ~= depTf.createSQL~'\n';
				}
			}

			query ~= tf.createSQL;

			writeln(query);
			synchronized(this)
				conn.exec(query);
		}
		return tf;
	}
	
	QueryT.Data[] applyQuery(QueryT)(QueryT query)
		if(hasMember!(QueryT, "opCall") &&
		   is(QueryT.Data) &&
		   isAggregateType!(QueryT.Data)
		   )
	{
		checkConnection();
		auto tf = new TableFormat!(QueryT.Data)();

		Answer s;
		synchronized(this)
			s = conn.exec(query());

		if(s.rowCount() > 0)
		{
			auto ret = new QueryT.Data[s.rowCount()];
			foreach(i; 0..s.rowCount())
			{
				ret[i] = tf.extractData(s[i]);
			}
			return ret;
		}
		return [];		
	}

	protected
	{
		void checkConnection()
		{
			if(!conn.connected)
			{
				synchronized(this)
				{
					conn.connString = connString;
					conn.connect();
				}
			}
			used = true;
		}
		
		static void checkTimeoutThread(shared thisType shdb)
		{
			Thread.getThis().isDaemon = true;
			thisType db = cast(thisType) shdb;
			while(true) 
			{
				Thread.sleep(dur!timeoutDurUnits(timeoutLength));
				if(db.used)
				{
					db.used = false;
				} else
				{
					if(db.conn.connected)
					{
						synchronized(db)
						{
							db.conn.disconnect();
						}
					}
				}
			}
		}
	}
	private
	{
		Connection conn;
		shared bool used = true;
		string connString;
	}
}

