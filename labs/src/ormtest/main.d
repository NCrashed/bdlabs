module main;

import orm.orm;
import dpq2.all;

import std.stdio;
import core.thread;
import core.time;
import std.uuid;

struct Test1
{
	UUID e;
	int a;
	short b;
	string c;
	float d;
	Test2 testOneToOne;

	mixin PrimaryKey!"e";
}

struct Test2
{
	UUID id;
	int a;
	string b;

	mixin PrimaryKey!"id";
}

void main()
{
	auto db = new DataBase!"testbd"("host=localhost port=5432 dbname=postgres user=postgres password=150561");

	//Thread.sleep(dur!"seconds"(12));

	writeln(db.hasTable("debugTable"));
	auto tf = new TableFormat!Test1();

	/*writeln(tf.createSQL());
	writeln(tf.insertSQL(Test1(15, 3, "bla", 42.23)));*/

	auto data = new Test1[2];
	data[0] = Test1(randomUUID(), 15, 3, "bla", 42.23);
	data[1] = Test1(randomUUID(), 8, 23, "boo", 23.23);

	db.insert(data);
	db.update(Test1(UUID(), 42), ["a"], whereFieldGen!Test1("c", "boo"));

	auto one = db.selectOne!Test1(whereAllGen!Test1());
	writeln(one);

	auto many = db.select!Test1(0, whereFieldGen!Test1("c", "bla"), true);
	writeln(many);

	getchar();
}