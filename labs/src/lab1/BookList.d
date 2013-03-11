module BookList;

import gtk.TreeView;
import gtk.TreeViewColumn;
import gtk.CellRendererText;
import customlist;
import data;
import std.conv;
import std.stdio;

struct BookModel
{
	uint pos;
	string name;
	string subject;
	string pageCount;
}

alias CustomList!BookModel BookListBase;

class BookList : BookListBase
{
	TreeView createTreeView()
	{
		TreeViewColumn   col;
		CellRendererText renderer;
		TreeView         view;

		view = new TreeView(this);
		
		col = new TreeViewColumn();
		renderer  = new CellRendererText();
		col.packStart(renderer, true);
		col.addAttribute(renderer, "text", Column.name);
		col.setTitle("Название");
		view.appendColumn(col);
		
		col = new TreeViewColumn();
		renderer  = new CellRendererText();
		col.packStart(renderer, true);
		col.addAttribute(renderer, "text", Column.subject);
		col.setTitle("Тематика");
		view.appendColumn(col);

		col = new TreeViewColumn();
		renderer  = new CellRendererText();
		col.packStart(renderer, true);
		col.addAttribute(renderer, "text", Column.pageCount);
		col.setTitle("Кол-во страниц");
		view.appendColumn(col);

		return view;
	}

	void fillData(Book[] books, Lab13DB db)
	{
		BookModel md;
		foreach (book; books)
		{
			md.name = book.title;
			md.subject = getSubject(db, book.subjectid).subject;
			md.pageCount = to!string(book.number);
			appendRecord(md);
		}
	}
}