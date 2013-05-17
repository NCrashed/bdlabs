module orm.orm;

public import orm.table;
public import orm.database;
import std.traits;
import std.conv;
import std.uuid;

/**
*	Mark for primary key.
*
*	Warning: Must be a one primary key or
*	compile time error will occur.
*
*	Example:
*	--------
*	struct SomeTable
*	{
*		@PrimaryKey
*		int id;
*	}
*	--------
*/
enum PrimaryKey;


struct ForeignKey(Table)
	if(isAggregateType!Table)
{
	alias Table ForeignTable;
	string foreignIdField;
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