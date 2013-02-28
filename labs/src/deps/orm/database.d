module orm.database;

import dpq2.answer;
import std.stdio : writeln;
import core.time;

class DataBase(string name, string timeoutDurUnits = "minutes", long timeoutLength = 5)
{

	private
	{
		Connection conn;

		Duration timeout = dur!timeoutDurUnits(timeoutLength);
	}
}