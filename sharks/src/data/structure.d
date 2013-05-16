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
}

struct InformationSources
{
	@PrimaryKey
	int 		InformationSourceID;

	@ForeignKey!AttackCases("AttackCaseID")
	int 		AttackCaseID;

	string		SourceName;
	string		Url;
	string		MessageCopy;
	bool		IsOffical;
}

enum PlacesType:int
{
	SHALLOW_WATER,
	DEEP_WATER,
	BEACH,
	RIVER
}

struct Places
{
	@PrimaryKey
	int			PlaceID;

	string		PlaceName;
	string		Country;
	string		PlaceDescr;
	int 		PlaceType;
}

struct Reasons
{
	@PrimaryKey
	int 		ReasonID;

	string		ReasonName;
	string		BehaveDescr;
	bool		IsProvoked;
}

struct SharkSpieces
{
	@PrimaryKey
	int 		SpieceID;

	string		SpieceName;
	string		SpieceDescr;
	int 		AverageSize;
	string		Ration;
	string 		Photos;
	int 		HazardRate;
}

struct Habitats
{
	@PrimaryKey
	int 		HabitatID;

	string		HabitatName;
	long		Area;
	float		Urbanization;
}

struct Victims
{
	@PrimaryKey
	int 		VictimID;

	string		VictimName;
	Date 		BirthDate;
	string		Career;
	string		DamageDescr;
	string		Destiny;
}

struct Property
{
	@PrimaryKey
	int 		PropertyID;

	string		PropertyType;
	long		Damage;
	string		DamageDescr;
}

struct Reason2AttackCase
{
	@ForeignKey!Reasons("ReasonID")
	int 	ReasonID;

	@ForeignKey!AttackCases("AttackCaseID")
	int 	AttackCaseID;
}

struct Spiece2AttackCase
{
	@ForeignKey!SharkSpieces("SpieceID")
	int 	SpieceID;

	@ForeignKey!AttackCases("AttackCaseID")
	int 	AttackCaseID;
}

struct Property2AttackCase
{
	@ForeignKey!Property("PropertyID")
	int 	PropertyID;

	@ForeignKey!AttackCases("AttackCaseID")
	int 	AttackCaseID;
}

struct Victim2AttackCase
{
	@ForeignKey!Victims("VictimID")
	int 	VictimID;

	@ForeignKey!AttackCases("AttackCaseID")
	int 	AttackCaseID;
}

struct Habitat2Spiece
{
	@ForeignKey!Habitats("HabitatID")
	int 	HabitatID;

	@ForeignKey!AttackCases("AttackCaseID")
	int 	AttackCaseID;
}