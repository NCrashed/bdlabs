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
module gui.MainWindow;

import gtkc.gtktypes;
import gtk.MainWindow;
import gtk.Menu;
import gtk.MenuBar;
import gtk.MenuItem;
import gtk.AboutDialog;

import gtk.Box;

private import stdlib = core.stdc.stdlib : exit;

import data.wrapper;

class SharksMainWindow : MainWindow
{
	private
	{
		SharksDB db;
	}

	this(SharksDB db)
	{
		super("Курсовая работа - ИС о случаях нападения акул на человека");
		setDefaultSize(512,512);
		this.db = db;

		// Core structure
		auto box = new Box(GtkOrientation.VERTICAL, 5);
		box.packStart(initMenu(), 0, 0, 0);

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

	//========================================================
	//		Delegates
	//========================================================
	// Regenerates data base
	void onGenerate(MenuItem item)
	{

	}

	// Show about dialog
	void onAbout(MenuItem item)
	{
		with (new AboutDialog())
		{
			setAuthors(["Гуща Антон ИУ5-62"]);
			setComments("Курсовая работа по курсу 'Банки данных'");
			setLicense(license);
			setCopyright("©Гуща А.В. 2013");
			
			auto response = run();
			if(response == GtkResponseType.CLOSE)
			{
				hide();
			}
		}
	}
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