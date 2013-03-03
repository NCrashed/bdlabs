module orm.orm;

public import orm.table;
public import orm.database;
import std.traits;

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