module data;

import orm.orm;
import std.uuid;
import std.random;
import std.conv;

struct Library
{
	UUID id;
	UUID studentid;
	UUID bookid;
	short bookOut;

	mixin PrimaryKey!"id";
}

struct Student
{
	UUID id;
	string surname;
	string group;

	mixin PrimaryKey!"id";
}

struct Book
{
	UUID id;
	string title;
	UUID subjectid;
	int number;

	mixin PrimaryKey!"id";
}

struct Subject
{
	UUID id;
	string subject;

	mixin PrimaryKey!"id";
}

private
{
	string[] subjectStrings = ["Природо", "Собако", "Миро", "Страно", "Граждано", "Политико", "Данжо", "Кошко", "Этно", "Строко", "Астрало", "Фигуро", "Нумеро", "Воено", "Мониторо",
	                           "Щито", "Анамалио", "Деньго", "Интернето", "Не", "Храпо", "Свисто", "Ложко", "Марионето", "Некро", "Суммо", "Стихо", "Фастфудо", "Брано"];
	string[] bookTitlesBegin = ["Изучение", "Прохождение", "Исследование", "Наслаждение", "Воровоство", "Законы", "Учебник по", "Уроки"];
	string[] bookTitlesMedium = ["поведения", "бран", "денег", "воскрешению", "зелье", "магии", "счастья", "собак", "добра", "зла", "девушек", "логики", "любопытства", "планы Мироздания",
	                             "цивилизаций", "мракобесия", "графов", "королей", "странностей", "свитков", "изучения", "домов", "гражданства", "братства", "страха", "темноты", "тьмы", "бытия",
	                             "профессий", "секретов", "скорочтения", "штуцеров", "роторов", "гениев", "Марокко", "силы", "мечей", "полета", "сопрано", "ягод", "грибов", "коры", "зайцев", "каменй",
	                             "коров", "гусей", "нейросинхрофазотронов", "блудниц", "проферанса", "штопоров"];
	string[] studentGrops = ["СМ", "РК", "БМТ", "ИУ", "РЛ"];
	string[] studentNames = ["Антон", "Василий", "Вадим", "Юрий", "Никита", "Андрей", "Иван", "Александр", "Борис", "Захар", "Святослав", "Руслан", "Сергей", "Леонид", "Кирилл", "Власий"];
	string[] studentSurnames = ["Глебович", "Богданович", "Никифорович", "Григорьевич", "Емельянович", "Данилович", "Борисович", "Юрьевич", "Ярославич", "Ксенофонтович", "Бориславович", "Викторович"];
}


private T selectRandElement(T)(T[] arr)
{
	return arr[uniform(0, arr.length)];
}

private void generateLibrary(ref Library lb, Student[] sta, Book[] booka)
{
	lb.id = randomUUID();
	lb.bookOut = cast(short)uniform(0,2);
	lb.studentid = selectRandElement(sta).id;
	lb.bookid = selectRandElement(booka).id;
}

private void generateStudent(ref Student st)
{
	st.id = randomUUID();
	st.group = selectRandElement(studentGrops)~to!string(uniform(1,11))~"-"~to!string(uniform(1,11));
	st.surname = selectRandElement(studentNames) ~ " " ~ selectRandElement(studentSurnames);
}

private void generateSubject(ref Subject subj)
{
	subj.id = randomUUID();
	subj.subject = selectRandElement(subjectStrings)~"ведение";
}

private void generateBook(ref Book book, Subject[] subja)
{
	book.id = randomUUID();
	book.subjectid = subja[uniform(0, subja.length)].id;

	string s = selectRandElement(bookTitlesBegin) ~ " " ~ selectRandElement(bookTitlesMedium);
	if(uniform(0.0, 1.0) <= 0.2)
		s ~= " и " ~ selectRandElement(bookTitlesBegin) ~ " " ~ selectRandElement(bookTitlesMedium);

	book.title = s;
	book.number = uniform(10, 800);
}

private void generateTestData(size_t libraryCount, size_t studentCount, size_t bookCount, 
                      out Library[] liba, out Student[] sta, out Book[] booka, out Subject[] subja)
{
	liba = new Library[libraryCount];
	sta = new Student[studentCount];
	booka = new Book[bookCount];
	size_t subjCount = uniform!"[]"(1, bookCount);
	subja = new Subject[subjCount];

	foreach(ref subj; subja)
		generateSubject(subj);
	foreach(ref book; booka)
		generateBook(book, subja);
	foreach(ref st; sta)
		generateStudent(st);
	foreach(ref lb; liba)
		generateLibrary(lb, sta, booka);
}

public void generateBase(string name, string tu, long tl)(DataBase!(name, tu, tl) db, size_t libraryCount, size_t studentCount, size_t bookCount)
{
	if(db.hasTable!Library)
		db.dropTable!Library;
	if(db.hasTable!Student)
		db.dropTable!Student;
	if(db.hasTable!Book)
		db.dropTable!Book;
	if(db.hasTable!Subject)
		db.dropTable!Subject;

	Library[] liba;
	Student[] sta;
	Book[] booka;
	Subject[] subja;

	generateTestData(libraryCount, studentCount, bookCount, liba, sta, booka, subja);

	foreach(ref subj; subja)
		db.insert(subj);
	foreach(ref book; booka)
		db.insert(book);
	foreach(ref st; sta)
		db.insert(st);
	foreach(ref lb; liba)
		db.insert(lb);
}

public Book[] getAllBooks(string name, string tu, long tl)(DataBase!(name, tu, tl) db)
{
	return db.select!Book(0, (TableFormat!Book tf){ return "";});
}

public Subject getSubject(string name, string tu, long tl)(DataBase!(name, tu, tl) db, UUID id)
{
	return db.selectOne!Subject((TableFormat!Subject tf){return "id = '"~to!string(id)~"'";});
}