module orm.table;

import std.array;
import std.uuid;
import std.traits;
import std.conv;
import util.common;
import orm.orm;
import dpq2.all;

class TableFormatException(Type) : Exception
{
	this(string msg)
	{
		super("TableFormat!"~Type.stringof~": "~msg);
	}
}

class TableFormat(Aggregate)
{
	static assert(isAggregateType!Aggregate, "Table can be created only from struct and class!");

	alias FieldNameTuple!(Aggregate) fieldNames;
	alias TypeTupleFrom!(Aggregate, fieldNames) fieldTypes;

	this()
	{

	}

	string name() @property 
	{
		return Aggregate.stringof;
	}

	string createSQL() @property
	{
		auto s = appender!string();
		s.put(`CREATE TABLE public."`~name~`"`~"\n(\n");
		foreach(i, type; fieldTypes)
		{
			s.put(`"`~fieldNames[i]~`" `~type2SQL!type);
			static if(hasPrimaryKey!Aggregate)
			{
				if(Aggregate.getPrimaryKey() == fieldNames[i])
					s.put(" PRIMARY KEY");
			}
			if(i != fieldTypes.length-1)
				s.put(",\n");
			else
				s.put("\n");
		}
		s.put(")\n WITH ( OIDS = FALSE );");
		return s.data;
	}

	string insertSQL(Aggregate data)
	{
		auto s = appender!string();
		s.put(`INSERT INTO "`~name~`"  VALUES`~"\n\t(");
		foreach(i, type; fieldTypes)
		{
			static if(isSomeString!type)
			{
				s.put(`'`~mixin("data."~fieldNames[i])~`'`);
			} else static if(is(type == UUID))
			{
				s.put(`'`~to!string(mixin("data."~fieldNames[i]))~`'`);
			} else 
			{
				s.put(to!string(mixin("data."~fieldNames[i])));
			}

			if(i != fieldTypes.length-1)
				s.put(",");
		}
		s.put(");");
		return s.data;
	}

	string updateSQL(Aggregate data, string[] fields, string delegate(TableFormat!Aggregate) whereGenerator)
	{
		debug
		{
			string problemField;
			if(!checkFields(fields, problemField))
				throw new Exception("Cannot find field "~problemField~" in table "~name);
		}

		auto s = appender!string();
		s.put(`UPDATE "`~name~`" SET `);
		foreach(i, type; fieldTypes)
		{
			if(isInArray(fields, fieldNames[i]))
			{
				s.put(fieldNames[i] ~ ` = ` ~ decorateValue(mixin("data."~fieldNames[i])));
				s.put(",");
			}
		}

		string where = whereGenerator(this);
		if(where.length > 0)
		{
			where = ` WHERE ` ~ where;
		}

		return s.data[0..$-1] ~ where;
	}

	string selectSQL(size_t count, Table!(Aggregate).WhereGenerator whereGenerator, bool distinct = false)
	{
		auto s = appender!string();
		s.put(`SELECT `);
		if(distinct) s.put(`DISTINCT `);
		foreach(i, type; fieldTypes)
		{
			s.put(fieldNames[i]);
			if(i != fieldTypes.length-1)
				s.put(`, `);
		}
		s.put(` FROM "`~name~`"`);

		string where = whereGenerator(this);
		if(where.length > 0)
		{
			where = ` WHERE ` ~ where;
		}

		string scount;
		if(count > 0)
		{
			scount = to!string(count);
		} else
		{
			scount = " ALL";
		}
		return s.data ~ where ~ ` LIMIT ` ~ scount;
	}

	string deleteSQL(size_t count,  string delegate(TableFormat!Aggregate) whereGenerator)
	{
		auto s = appender!string();
		s.put(`DELETE FROM "`~name~`" `);
		string where = whereGenerator(this);
		if(where.length > 0)
			s.put(`WHERE `~where~` `);

		if(count > 0)
			s.put(`LIMIT `~to!string(count));
		return s.data;
	}

	Aggregate extractData(Row data)
	{
		if(data.columnCount() < fieldTypes.length)
		{
			throw new TableFormatException!Aggregate("Too few columns in table!");
		}

		static if(is(Aggregate == class))
		{
			auto ret = new Aggregate();
		} else
		{
		    auto ret = Aggregate();
		}

		foreach(i, type; fieldTypes)
		{
			try
          	{
          		mixin("ret."~fieldNames[i]~" = to!"~type.stringof~"(data[i].as!PGtext);");
          	} catch(Exception e)
          	{
				throw new TableFormatException!Aggregate("Error to fill field '"~type.sizeof~" "~fieldNames[i]~"': "~e.msg);
          	}
		}
        return ret;
	}

	private
	{
		bool isInArray(string[] arr, string field)
		{
			foreach(ref s; arr)
				if(s == field)
					return true;
			return false;
		}
		
		debug bool checkFields(string[] fields, out string problemField)
		{
      		bool isIn(string field)
      		{
      			foreach(i, type; fieldTypes)
      				if(fieldNames[i] == field)
      					return true;
      			return false;
      		}

			problemField = "";
			foreach(field; fields)
			{
			    if(!isIn(field))
				{
					problemField = field;
					return false;
				}
			}
			return true;
		}

		string decorateValue(Type)(Type val)
		{
			static if(isSomeString!Type)
      		{
      			return `'`~val~`'`;
			} else static if(is(Type == UUID))
      		{
				return `'`~to!string(val)~`'`;
      		} else 
      		{
				return to!string(val);
      		}
		}


	}
}

string type2SQL(Type)()
{
	static if(is(Type == int)) return "integer";
	static if(is(Type == short)) return "smallint";
	static if(is(Type == float)) return "real";
	static if(is(Type == string)) return "text";
	static if(is(Type == UUID)) return "uuid";
	static assert("Type "~Type.stringof~" not supported!");
}

version(unittest)
{
	import std.stdio;
	struct Test1
	{
		int a;
		short b;
		string c;
		float d;
		UUID e;
	}
}
unittest
{
	auto tf = new TableFormat!Test1();
}