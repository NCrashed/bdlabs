module orm.orm;

public import orm.table;
public import orm.database;
import std.traits;
import std.conv;
import std.uuid;

mixin template PrimaryKey(string field)
{
	static string getPrimaryKey()
	{
		return field;
	}
}

package template hasPrimaryKey(Aggregate)
{
	static assert(isAggregateType!Aggregate, "hasPrivaryKey expects aggregate type!");

	enum hasPrimaryKey = hasMember!(Aggregate, "getPrimaryKey");
}

Table!(T).WhereGenerator whereAllGen(T)()
{
	return (TableFormat!T tf){return "";};
}

Table!(T).WhereGenerator whereFieldGen(T, FieldType)(string fieldName, FieldType field)
{
	return (TableFormat!T tf){return fieldName~" = '"~to!string(field)~"'";};
}

Table!(T).WhereGenerator whereFieldsGen(T, FieldTypes...)(string[] fieldNames, FieldTypes fields)
{
	return (TableFormat!T tf)
	{
		assert(fieldNames.length == fields.length, "whereFieldsGen: passed unqueal arrays of names and values");
		string ret;
		foreach(i, field; fields)
		{
			ret ~= fieldNames[i]~" = ";
			static if(isSomeString!(FieldTypes[i]))
			{
				ret ~= "'"~field~"'";
			} else static if(is(FieldTypes[i] == UUID))
			{
				ret ~= "'"~to!string(field)~"'";
			} else 
			{
				ret ~= to!string(field);
			}
			static if(i != fields.length-1)
			{
				ret ~= " AND ";
			} else
			{
				ret ~= " ";
			}
		}

		return ret;
	};
}