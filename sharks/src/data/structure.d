module data.structure;

import orm.orm;
import std.datetime;

struct AttackCases
{
	@PrimaryKey
	int 		AttackCaseID;

	Date 		AttackDate;
	int 		DayTime;
	string 		CaseDescr;
	int			ViewDist;

	@ForeignKey!Places("PlaceID")
	int			PlaceID;

	pragma(msg, __traits(getAttributes, PlaceID));
}

struct Places
{

}