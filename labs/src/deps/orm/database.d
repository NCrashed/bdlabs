module orm.database;

import dpq2.all;
import std.stdio : writeln;
import std.concurrency;
import core.time;
import core.thread;

shared class DataBase(string name, string timeoutDurUnits = "seconds", long timeoutLength = 5)
{
	alias DataBase!(name, timeoutDurUnits, timeoutLength) thisType;

	this()
	{
		spawn(&checkTimeoutThread, this);

		auto arrxy = new int[][10];
		foreach(ref arrx; arrxy)
			arrx = new int[10];
	}

	private
	{
		Connection conn;
		shared bool used = true;
		//Duration timeout = dur!timeoutDurUnits(timeoutLength);

		static void checkTimeoutThread(shared thisType db)
		{
			Thread.getThis().isDaemon = true;
			while(true) 
			{
				Thread.sleep(dur!timeoutDurUnits(timeoutLength));
				if(db.used)
				{
					db.used = false;
					writeln("BaseTimeout");
				} else
				{

				}
			}
		}
	}
}

