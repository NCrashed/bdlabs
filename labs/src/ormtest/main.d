module main;

import orm.orm;
import dpq2.all;

import std.stdio;
import core.thread;
import core.time;
import std.uuid;

struct Test1
{
	int a;
	short b;
	string c;
	float d;
	UUID e;

	mixin PrimaryKey!"e";
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
	data[0] = Test1(15, 3, "bla", 42.23, randomUUID());
	data[1] = Test1(8, 23, "boo", 23.23, randomUUID());

	db.insert(data);
	db.update(Test1(42), ["a"], whereFieldGen!Test1("c", "boo"));

	auto one = db.selectOne!Test1(whereAllGen!Test1());
	writeln(one);

	auto many = db.select!Test1(0, whereFieldGen!Test1("c", "bla"), true);
	writeln(many);

	//db.remove(0, (TableFormat!Test1 tf){return "c = 'bla'";});


	/*
    Connection conn = new Connection;
    conn.connString = "host=localhost port=5432 dbname=postgres user=postgres password=150561";
    conn.connect();

    
    // Text query result
    auto s = conn.exec(
        "SELECT now() as current_time, 'abc'::text as field_name, "
        "123 as field_3, 456.78 as field_4"
        );

    writeln( "1: ", s[0][3].as!PGtext );

    // Binary query result
    static queryArg arg;
    queryParams p;
    p.resultFormat = dpq2.answer.valueFormat.BINARY;
    p.sqlCommand = "SELECT "
        "-1234.56789012345::double precision, "
        "'2012-10-04 11:00:21.227803+08'::timestamp with time zone, "
        "'first line\nsecond line'::text, "
        "NULL, "
        "array[1, 2, NULL]::integer[]";


    auto r = conn.exec( p );    

    writeln( "2: ", r[0][0].as!PGdouble_precision );
    writeln( "3: ", r[0][1].as!PGtime_stamp.toSimpleString );
    writeln( "4: ", r[0][2].as!PGtext );
    writeln( "5: ", r[0].isNULL(3) );
    writeln( "6: ", r[0][4].asArray.getValue(1).as!PGinteger );
    writeln( "7: ", r[0][4].asArray.isNULL(0) );
    writeln( "8: ", r[0][4].asArray.isNULL(2) );*/

	getchar();
}