import gtk.MainWindow;
import gtk.AboutDialog;
import gtk.Notebook;
import gtk.MenuBar;
import gtk.Menu;
import gtk.MenuItem;
import gtk.Label;
import gtk.Button;
import gtk.Main;
import gtk.Box;
import gtk.ComboBoxText;
import gtk.TreeView;
import gtk.Entry;
import gtk.ScrolledWindow;
import gtk.Alignment;

import gtk.MessageDialog;
import gtk.Calendar;
import gtk.TreeIter;
import gtk.TreeViewColumn;
import gtk.TreePath;
import gobject.Value;
import booklist;
import customlist;
import detailedbooklist;

private import stdlib = core.stdc.stdlib : exit;

import orm.orm;
import data;

import std.conv;
import std.uuid;
import std.regex;
import std.datetime;

class Lab13Window : MainWindow
{
	BookList bookList, bookBySubjList;
	DetailedBookList detailedList;
	Entry outSurnameEntry, outGroupEntry, inSurnameEntry, inGroupEntry;
	Label bookAvailableLabel;
	Button takeButton;
	UUID currBookForOut;
	Calendar calendar, returnCalendar;

	this()
	{
		super("Lab1-3");
		setDefaultSize(512, 512);

		Box box = new Box(GtkOrientation.VERTICAL, 5);
		box.packStart(initMenu(), 0, 0, 0);
		//box.add(menuBar);

		Notebook tabs = new Notebook();
		tabs.appendPage(initBookViewTab(), 		"Просмотр книг");
		tabs.appendPage(initOutViewTab(), 		"Выдача книг");
		tabs.appendPage(initInViewTab(), 		"Прием книг");
		tabs.appendPage(initHistoryViewTab(), 	"История выдачи");
		box.packStart(tabs, 1, 1, 0);

		add(box);
		showAll();	
	}

	MenuBar initMenu()
	{
		MenuBar menuBar = new MenuBar();
		Menu fileMenu = menuBar.append("Файл");
		MenuItem generateItem = new MenuItem(&onGenerate, "Регенерация базы");
		MenuItem aboutItem = new MenuItem(&onAbout, "О программе");
		MenuItem exitItem = new MenuItem((item) {stdlib.exit(0);}, "Выход");
		
		fileMenu.append(generateItem);
		fileMenu.append(aboutItem);
		fileMenu.append(exitItem);
		return menuBar;
	}

	Box initBookViewTab()
	{
		Box viewBox = new Box(GtkOrientation.VERTICAL, 5);
		ScrolledWindow scrollwin = new ScrolledWindow();
		viewBox.packStart(scrollwin, true, true, 0);
		
		bookList = new BookList;
		fillBookList(bookList);
		TreeView view = bookList.createTreeView();
		scrollwin.add(view);
		return viewBox;
	}

	Box initOutViewTab()
	{
		Box level3()
		{
			Box sideVerBox = new Box(GtkOrientation.VERTICAL, 5);
			
			sideVerBox.add(Alignment.west(new Label("Фамилия")));
			outSurnameEntry = new Entry("");
			sideVerBox.add(outSurnameEntry);

			sideVerBox.add(Alignment.west(new Label("Группа")));
			outGroupEntry = new Entry("");
			sideVerBox.add(outGroupEntry);

			bookAvailableLabel = new Label("Выберите книгу");
			sideVerBox.add(bookAvailableLabel);

			takeButton = new Button("_Взять");
			takeButton.setSensitive(false);
			sideVerBox.add(takeButton);

			takeButton.addOnClicked(&onOutButtonClicked);

			return sideVerBox;
		}

		ScrolledWindow booksListLevel()
		{
			auto scrollwin = new ScrolledWindow();
			bookBySubjList = new BookList;
			auto treeView = bookBySubjList.createTreeView();
			scrollwin.add(treeView);

			treeView.addOnCursorChanged(&onOutBookSelect);
			return scrollwin;
		}

		Box level2()
		{
			Box horBox = new Box(GtkOrientation.HORIZONTAL, 5);
			horBox.packStart(booksListLevel(), true, true, 10);
			horBox.add(level3());
			return horBox;
		}

		Box level1()
		{
			Box viewBox = new Box(GtkOrientation.VERTICAL, 5);
			auto outBookCombo = new ComboBoxText(false);
			viewBox.packStart(outBookCombo, false, false, 0);
			
			auto subjs = getAllSubjects(db);
			foreach(i, subj; subjs)
			{
				outBookCombo.append(to!string(i), subj.subject);
			}

			viewBox.packStart(level2(), true, true, 0);
			calendar = new Calendar;
			calendar.selectMonth(2, 2013);
			calendar.selectDay(18);
			viewBox.add(calendar);

			outBookCombo.addOnChanged((combo){fillBookBySubjList(bookBySubjList, combo.getActiveText());});
			return viewBox;
		}
		
		return level1();
	}

	Box initInViewTab()
	{
		Box level3()
		{
			Box box = new Box(GtkOrientation.VERTICAL, 10);
			auto loadButton = new Button("_Загрузить");
			loadButton.addOnClicked(&onInLoadClicked);
			box.add(loadButton);
			auto returnButton = new Button("Ве_рнуть");
			returnButton.addOnClicked(&onInReturnClicked);
			box.add(returnButton);
			auto returnAllButton = new Button("В_ернуть все");
			returnAllButton.addOnClicked(&onInReturnAllClicked);
			box.add(returnAllButton);

			return box;
		}

		Box level2()
		{
			Box box = new Box(GtkOrientation.HORIZONTAL, 5);

			auto scrollwin = new ScrolledWindow();
			detailedList = new DetailedBookList();
			auto treeView = detailedList.createTreeView();
			scrollwin.add(treeView);
			box.packStart(scrollwin, true, true, 0);
			box.add(level3());
			return box;
		}

		Box level1()
		{
			Box viewBox = new Box(GtkOrientation.VERTICAL, 5);

			viewBox.add(Alignment.west(new Label("Фамилия")));
			inSurnameEntry = new Entry("");
			viewBox.add(inSurnameEntry);
			
			viewBox.add(Alignment.west(new Label("Группа")));
			inGroupEntry = new Entry("");
			viewBox.add(inGroupEntry);
			viewBox.packStart(level2(), true, true, 10);
			returnCalendar = new Calendar();
			viewBox.add(returnCalendar);

			return viewBox;
		}
		
		return level1();
	}

	Box initHistoryViewTab()
	{
		Box viewBox = new Box(GtkOrientation.VERTICAL, 5);

		return viewBox;
	}

	void onOutBookSelect(TreeView view)
	{
		TreePath path;
		TreeViewColumn col;
		TreeIter iter = new TreeIter();
		view.getCursor(path, col);
		
		if(path !is null)
		{
			bookBySubjList.getIter(iter, path);
			if(iter is null)
			{
				bookAvailableLabel.setText("Выберите книгу");
				takeButton.setSensitive(false);
				return;
			}

			auto val = bookBySubjList.getValue(iter, BookList.Column.Record);
			if(val is null)
			{
				bookAvailableLabel.setText("Выберите книгу");
				takeButton.setSensitive(false);
				return;
			}	

			BookModel* bookModel = cast(BookModel*)val.getPointer();
			if(bookModel is null)
			{
				bookAvailableLabel.setText("Выберите книгу");
				takeButton.setSensitive(false);
				return;
			}

			auto id = UUID(bookModel.id);
			try
			{
				auto lib = getLibraryOutByBookID(db, id);
				// if not fail
				bookAvailableLabel.setText("Книга выдана");
				takeButton.setSensitive(false);
			} catch(Exception e)
			{
				bookAvailableLabel.setText("Книга готова к выдаче");
				currBookForOut = id;
				takeButton.setSensitive(true);
			}
		} else
		{
			bookAvailableLabel.setText("Выберите книгу");
			takeButton.setSensitive(false);
		}
	}

	void onOutButtonClicked(Button btn)
	{
		string surname = outSurnameEntry.getText();
		string group = outGroupEntry.getText();

		if(surname.length == 0)
		{
			MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Заполните поле фамилии!");
			d.run();
			d.destroy();
			return;
		}

		if(group.length == 0)
		{
			MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Заполните поле группы!");
			d.run();
			d.destroy();
			return;
		}

		enum ctr = ctRegex!(`\D{2,3}\d+-\d+`);
		if(!match(group, ctr))
		{
			MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Поле группы заполнено некорректно!");
			d.run();
			d.destroy();
			return;
		}

		Student st;
		try
		{
			st = db.selectOne!Student(whereFieldsGen!Student(["surname","groupname"],surname,group));
		} catch(SelectException e)
		{
			st.id = randomUUID();
			st.surname = surname;
			st.groupname = group;
			db.insert!Student(st);
		}

		Library lib;
		lib.id = randomUUID();
		lib.bookid = currBookForOut;
		lib.studentid = st.id;
		
		uint year, month, day;
		calendar.getDate(year, month, day);
		lib.date = Date(year, month+1, day).toSimpleString();
		lib.bookout = 1;

		db.insert!Library(lib);
		bookAvailableLabel.setText("Книга выдана");
		takeButton.setSensitive(false);
	}

	void onGenerate(MenuItem item)
	{
		generateBase(db, 20, 20, 150);
	}

	void onAbout(MenuItem item)
	{
		with (new AboutDialog())
		{
			string[] names;
			names ~= "Гуща Антон (NCrashed)";
			setAuthors(names);
			setComments("Первая лабораторная работа по курсу 'Банки данных'");
			setLicense(license);
			setCopyright("©Гуща А.В. 2013");
			//setWebsite("http://ddev.ratedo.com");
			showAll();
		}
	}

	void fillBookList(BookList list)
	{
		list.clear();
		try
		{
			Book[] books = getAllBooks(db);

			list.fillData(books, db);
		} catch(Exception e)
		{
			import std.stdio;
			writeln(e.msg);
		}
	}	

	void fillBookBySubjList(BookList list, string subj)
	{
		if(subj is null) return;

		list.clear();
		try
		{
			Book[] books = getBooksBySubj(db, subj);
			
			list.fillData(books, db);
		} catch(Exception e)
		{
			import std.stdio;
			writeln(e.msg);
		}
	}

	void onInLoadClicked(Button btn)
	{
		string surname = inSurnameEntry.getText();
		string group = inGroupEntry.getText();
		
		if(surname.length == 0)
		{
			MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Заполните поле фамилии!");
			d.run();
			d.destroy();
			return;
		}
		
		if(group.length == 0)
		{
			MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Заполните поле группы!");
			d.run();
			d.destroy();
			return;
		}
		
		enum ctr = ctRegex!(`\D{2,3}\d+-\d+`);
		if(!match(group, ctr))
		{
			MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Поле группы заполнено некорректно!");
			d.run();
			d.destroy();
			return;
		}

		Student st;
		try
		{
			st = db.selectOne!Student(whereFieldsGen!Student(["surname", "groupname"], surname, group));
		} catch(SelectException e)
		{
			MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Студент не найден!");
			d.run();
			d.destroy();
			return;
		}

		Library[] libs = new Library[0];
		try
		{
			libs = db.select!Library(0, whereFieldGen!Library("studentid", st.id));
		} catch(SelectException e)
		{
			MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Книг не найдено!");
			d.run();
			d.destroy();
			return;
		}

		returnCalendar.clearMarks();
		foreach(lib; libs)
		{
			Book book;
			try
			{
				book = db.selectOne!Book(whereFieldGen!Book("id", lib.bookid));
			} catch(SelectException e)
			{
				MessageDialog d = new MessageDialog(this, GtkDialogFlags.MODAL, MessageType.INFO, ButtonsType.OK, "Ошибка при чтении книги!\n"~e.msg);
				d.run();
				d.destroy();
			}

			DetailedBookModel md;
			md.id = to!string(lib.id);
			md.name = book.title;
			md.pageCount = to!string(book.number);
			md.bookOut = lib.bookout == 0 ? "Нет" : "Да";
			md.date = lib.date;
			detailedList.appendRecord(md);

			if(lib.bookout == 1)
			{
				Date date = Date.fromSimpleString(md.date);
			
				returnCalendar.selectMonth(date.month-1, date.year);
				returnCalendar.markDay(date.day);
			}
		}
	}

	void onInReturnClicked(Button btn)
	{

	}

	void onInReturnAllClicked(Button brn)
	{

	}
}

Lab13DB db;

void main(string[] args)
{
	Main.init(args);
	db = new DataBase!"testbd"("host=localhost port=5432 dbname=postgres user=postgres password=150561");

	if(!db.hasTable!Library)
	{
		generateBase(db, 20, 20, 150);
	}

	new Lab13Window();
	
	Main.run();
}

string license = q{
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
};