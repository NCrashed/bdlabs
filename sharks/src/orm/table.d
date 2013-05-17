module orm.table;

import std.array;
import std.uuid;
import std.traits;
import std.conv;
import std.string;
import std.datetime;
import std.typecons;
import std.typetuple;

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

template getTableDependencies(tf) if(is(tf _ == TableFormat!T, T))
{
	template constructTuple(size_t i, ctuple...)
	{
		static if(i >= tf.fieldTypes.length)
		{
			alias ctuple constructTuple;
		} else
		{
			static if(isForeignKey!(tf.AggregateType, tf.fieldNames[i]))
			{
				alias constructTuple!(i+1, TypeTuple!(getForeignTable!(tf.AggregateType, tf.fieldNames[i]), ctuple)) constructTuple;
			} else
				alias constructTuple!(i+1, ctuple) constructTuple;
		}
	}

	alias constructTuple!(0, TypeTuple!()) getTableDependencies;
}

class TableFormat(Aggregate)
{
	static assert(isAggregateType!Aggregate, "Table can be created only from struct and class!");

	alias FieldNameTuple!(Aggregate) fieldNames;
	alias TypeTupleFrom!(Aggregate, fieldNames) fieldTypes;
	alias Aggregate AggregateType;

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
			s.put(genCreateField!type(fieldNames[i]));

			static if(isPrimaryKey!(Aggregate, fieldNames[i]))
			{
				s.put(" PRIMARY KEY");
			}
			else static if(isForeignKey!(Aggregate, fieldNames[i]))
			{
				s.put(" REFERENCES public.\""~getForeignTable!(Aggregate, fieldNames[i]).stringof~"\"(\""~getForeignField!(Aggregate, fieldNames[i])~"\")");
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
			s.put(decorateInsertFieldValue!(type, fieldNames[i])(data));
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
				s.put(genUpdateFieldValue!(type, fieldNames[i])(data));
				s.put(",");
			}
		}

		string where;
		if(whereGenerator !is null)
		{
			where = whereGenerator(this);
			if(where.length > 0)
			{
				where = ` WHERE ` ~ where;
			}
		}

		return s.data[0..$-1] ~ where;
	}

	string selectSQL(size_t count, Table!(Aggregate).WhereGenerator whereGenerator, bool distinct = false)
	{
		auto s = appender!string();
		s.put(`SELECT `);
		if(distinct) s.put(`DISTINCT `);

		//static assert(false, "YOU STOPPED HERE TO ADD ONE TO ONE RELATION!");

		foreach(i, type; fieldTypes)
		{
			s.put(`"`~fieldNames[i]~`"`);
			if(i != fieldTypes.length-1)
				s.put(`, `);
		}
		s.put(` FROM "`~name~`"`);

		string where;
		if(whereGenerator !is null)
		{
			where = whereGenerator(this);
			if(where.length > 0)
			{
				where = ` WHERE ` ~ where;
			}
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
          		static if(is(type == Date))
          		{
          			mixin("ret."~fieldNames[i]~" = Date.fromISOExtString(data[i].as!PGtext);");
          		} else static if(is(type == bool))
          		{
          			mixin("ret."~fieldNames[i]~" = data[i].as!PGtext == \"t\";");
          		} else
          		{
          			mixin("ret."~fieldNames[i]~" = to!"~type.stringof~"(data[i].as!PGtext);");
          		}
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
      		} else static if(is(T == Date))
			{
				return `DATE '`~mixin("data."~fieldName)~`'`;
			} else static if(is(Type == UUID))
      		{
				return `'`~to!string(val)~`'`;
      		} else 
      		{
				return to!string(val);
      		}
		}

		static string decorateFieldValue(T, string fieldName)(Aggregate data)
		{
			static if(isSomeString!T)
			{
				return `'`~mixin("data."~fieldName)~`'`;
			} else static if(is(T == Date))
			{
				return `DATE '`~mixin("data."~fieldName~".toISOExtString()")~`'`;
			} else static if(is(T == UUID))
			{
				return `'`~to!string(mixin("data."~fieldName))~`'`;
			} else 
			{
				return to!string(mixin("data."~fieldName));
			}
		}

		static string genFieldName(T)(string fieldRawName)
		{
			//fieldRawName = toLower(fieldRawName);
			return fieldRawName;
		}

		static string genCreateField(T)(string fieldRawName)
		{
			return `"`~genFieldName!T(fieldRawName)~`" `~type2SQL!T;
		}

		string decorateInsertFieldValue(T, string fieldRawName)(Aggregate data)
		{
			return decorateFieldValue!(T, genFieldName!T(fieldRawName))(data);
		}

		string genUpdateFieldValue(T, string fieldRawName)(Aggregate data)
		{
			return genFieldName!T(fieldRawName) ~ ` = ` ~ decorateFieldValue!(T, genFieldName!T(fieldRawName))(data);
		}
	}
}

string type2SQL(Type)()
{
	static if(is(Type == int)) return "integer";
	else static if(is(Type == long)) return "bigint";
	else static if(is(Type == short)) return "smallint";
	else static if(is(Type == float)) return "real";
	else static if(is(Type == string)) return "text";
	else static if(is(Type == UUID)) return "uuid";
	else static if(is(Type == Date)) return "DATE";
	else static if(is(Type == bool)) return "boolean";
	else static assert(false, "Type "~Type.stringof~" not supported!");
}

private template hasAttibute(alias check, tuple...)
{
	static if(tuple.length == 0)
	{
		enum hasAttibute = false;
	} else
	{
		static if(check!(tuple[0..1]))
		{
			enum hasAttibute = true;
		} else
		{
			enum hasAttibute = hasAttibute!(check, tuple[1..$]);
		}
	}
}

private template findAttibute(alias check, tuple...)
{
	static if(tuple.length == 0)
	{
		enum findAttibute = tuple();
	} else
	{
		static if(check!(tuple[0]))
		{
			enum findAttibute = tuple[0];
		} else
		{
			enum findAttibute = findAttibute!(check, tuple[1..$]);
		}
	}
}

template isPrimaryKey(Aggregate, string fieldname)
{
	template checkPrimaryKey(tuple...)
	{
		enum checkPrimaryKey = is(tuple[0] == PrimaryKey);
	}
	enum isPrimaryKey = hasAttibute!(checkPrimaryKey, __traits(getAttributes, mixin("Aggregate."~fieldname)));
}

private template checkForeignKey(tuple...)
{
	static if(__traits(compiles, tuple[0].ForeignTable))
	{
		enum checkForeignKey = true;
	}
	else
	{
		enum checkForeignKey = false;
	}
}

template isForeignKey(Aggregate, string fieldname)
{
	enum isForeignKey = hasAttibute!(checkForeignKey, __traits(getAttributes, mixin("Aggregate."~fieldname)));
}
version(unittest)
{
	struct TestFK
	{
		@ForeignKey!TestFK2("id")
		int fk2id;
	}

	struct TestFK2
	{
		@PrimaryKey
		int id;
	}
}
unittest
{
	static assert(isForeignKey!(TestFK, "fk2id"));
}

private template getForeignTable(Aggregate, string fieldname)
{
	alias findAttibute!(checkForeignKey, __traits(getAttributes, mixin("Aggregate."~fieldname))) ForeignTableAttr;	
	
	static assert(!is(ForeignTableAttr == void), "Canot find foreign attribute for "~Aggregate.stringof~"."~fieldname~"!");
	alias ForeignTableAttr.ForeignTable getForeignTable;
}

private template getForeignField(Aggregate, string fieldname)
{
	alias findAttibute!(checkForeignKey, __traits(getAttributes, mixin("Aggregate."~fieldname))) ForeignTableAttr;	
	
	static assert(!is(ForeignTableAttr == void), "Canot find foreign attribute for "~Aggregate.stringof~"."~fieldname~"!");
	enum getForeignField = ForeignTableAttr.foreignIdField;
}

version(unittest)
{
	import std.stdio;
	struct Test1
	{
		@PrimaryKey
		int a;

		short b;
		string c;
		float d;

		@ForeignKey!Test2("id")
		UUID e;
	}

	struct Test2
	{
		@PrimaryKey
		UUID id;
	}

	alias TableFormat!Test1 Test1Format;
}
unittest
{
	auto tf = new Test1Format();

	//writeln(tf.createSQL());

	//assert(false);
}