module ormtest;

import orm.database;

void main()
{
	auto db = new DataBase!"testbd"();
}