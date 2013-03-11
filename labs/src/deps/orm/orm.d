module orm.orm;

public import orm.table;
public import orm.database;
import std.traits;
import std.conv;

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