// Written in D programming language
/*
Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/
module data.wrapper;

import std.typetuple;
import std.typecons;
import orm.orm;
import data.structure;

alias DataBase!"sharks" SharksDB;

alias TypeTuple!(
	AttackCases, 
	InformationSources,
	Places,
	Reasons,
	SharkSpieces,
	Habitats,
	Victims,
	Property,
	//Reason2AttackCase,
	//Spiece2AttackCase,
	//Property2AttackCase,
	//Victim2AttackCase,
	//Habitat2Spiece,
	) SharksDBTables;


enum SharksDBTableNames = tuple(
	"Случаи нападения",
	"Источники информации",
	"Места нападения",
	"Причины нападения",
	"Виды акул",
	"Ареалы",
	"Жертвы",
	"Пострадавшее имущество",
	//"Связь Причина-Атака",
	//"Связь Вид-Атака",
	//"Связь Имущество-Атака",
	//"Связь Жертва-Атака",
	//"Связь Ареал-Вид акулы"
	);

enum SharksDBTablesColumnNames = tuple(
	tuple("ID", "Дата", "Время", "Описание", "Видимость", "ID места"),
	tuple("ID", "ID атаки", "Имя", "Адрес", "Сообщение", "Официальность"),
	tuple("ID", "Название", "Страна", "Описание", "Тип места"),
	tuple("ID", "Название", "Поведение", "Спровоцировано"),
	tuple("ID", "Название", "Описание", "Размер", "Рацион", "Фото", "Опасность"),
	tuple("ID", "Название", "Площадь", "Урбанизация"),
	tuple("ID", "ФИО", "Дата рождения", "Деятельность", "Описание повреждений", "Судьба"),
	tuple("ID", "Тип", "Ущерб,$", "Описание"),
	//tuple("ID причины", "ID атаки"),
	//tuple("ID вида", "ID атаки"),
	//tuple("ID имущества", "ID атаки"),
	//tuple("ID жертвы", "ID атаки"),
	//tuple("ID ареала", "ID вида")
	);
