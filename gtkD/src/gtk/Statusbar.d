/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version, with
 * some exceptions, please read the COPYING file.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = GtkStatusbar.html
 * outPack = gtk
 * outFile = Statusbar
 * strct   = GtkStatusbar
 * realStrct=
 * ctorStrct=
 * clss    = Statusbar
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_statusbar_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gtk_statusbar_get_message_area
 * omit signals:
 * imports:
 * 	- glib.Str
 * 	- gtk.Box
 * 	- gtk.Widget
 * structWrap:
 * 	- GtkWidget* -> Widget
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtk.Statusbar;

public  import gtkc.gtktypes;

private import gtkc.gtk;
private import glib.ConstructionException;
private import gobject.ObjectG;

private import gobject.Signals;
public  import gtkc.gdktypes;

private import glib.Str;
private import gtk.Box;
private import gtk.Widget;



private import gtk.Box;

/**
 * A GtkStatusbar is usually placed along the bottom of an application's
 * main GtkWindow. It may provide a regular commentary of the application's
 * status (as is usually the case in a web browser, for example), or may be
 * used to simply output a message when the status changes, (when an upload
 * is complete in an FTP client, for example).
 *
 * Status bars in GTK+ maintain a stack of messages. The message at
 * the top of the each bar's stack is the one that will currently be displayed.
 *
 * Any messages added to a statusbar's stack must specify a
 * context id that is used to uniquely identify
 * the source of a message. This context id can be generated by
 * gtk_statusbar_get_context_id(), given a message and the statusbar that
 * it will be added to. Note that messages are stored in a stack, and when
 * choosing which message to display, the stack structure is adhered to,
 * regardless of the context identifier of a message.
 *
 * One could say that a statusbar maintains one stack of messages for
 * display purposes, but allows multiple message producers to maintain
 * sub-stacks of the messages they produced (via context ids).
 *
 * Status bars are created using gtk_statusbar_new().
 *
 * Messages are added to the bar's stack with gtk_statusbar_push().
 *
 * The message at the top of the stack can be removed using
 * gtk_statusbar_pop(). A message can be removed from anywhere in the
 * stack if its message id was recorded at the time it was added. This
 * is done using gtk_statusbar_remove().
 */
public class Statusbar : Box
{
	
	/** the main Gtk struct */
	protected GtkStatusbar* gtkStatusbar;
	
	
	public GtkStatusbar* getStatusbarStruct()
	{
		return gtkStatusbar;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkStatusbar;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkStatusbar* gtkStatusbar)
	{
		super(cast(GtkBox*)gtkStatusbar);
		this.gtkStatusbar = gtkStatusbar;
	}
	
	protected override void setStruct(GObject* obj)
	{
		super.setStruct(obj);
		gtkStatusbar = cast(GtkStatusbar*)obj;
	}
	
	/**
	 * Retrieves the box containing the label widget.
	 * Since 2.20
	 * Returns: a GtkBox. [transfer none]
	 */
	public Box getMessageArea()
	{
		// GtkWidget * gtk_statusbar_get_message_area (GtkStatusbar *statusbar);
		auto p = gtk_statusbar_get_message_area(gtkStatusbar);
		if(p is null)
		{
			return null;
		}
		return new Box(cast(GtkBox*) p);
	}
	
	/**
	 */
	int[string] connectedSignals;
	
	void delegate(guint, string, Statusbar)[] onTextPoppedListeners;
	/**
	 * Is emitted whenever a new message is popped off a statusbar's stack.
	 */
	void addOnTextPopped(void delegate(guint, string, Statusbar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("text-popped" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"text-popped",
			cast(GCallback)&callBackTextPopped,
			cast(void*)this,
			null,
			connectFlags);
			connectedSignals["text-popped"] = 1;
		}
		onTextPoppedListeners ~= dlg;
	}
	extern(C) static void callBackTextPopped(GtkStatusbar* statusbarStruct, guint contextId, gchar* text, Statusbar _statusbar)
	{
		foreach ( void delegate(guint, string, Statusbar) dlg ; _statusbar.onTextPoppedListeners )
		{
			dlg(contextId, Str.toString(text), _statusbar);
		}
	}
	
	void delegate(guint, string, Statusbar)[] onTextPushedListeners;
	/**
	 * Is emitted whenever a new message gets pushed onto a statusbar's stack.
	 */
	void addOnTextPushed(void delegate(guint, string, Statusbar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("text-pushed" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"text-pushed",
			cast(GCallback)&callBackTextPushed,
			cast(void*)this,
			null,
			connectFlags);
			connectedSignals["text-pushed"] = 1;
		}
		onTextPushedListeners ~= dlg;
	}
	extern(C) static void callBackTextPushed(GtkStatusbar* statusbarStruct, guint contextId, gchar* text, Statusbar _statusbar)
	{
		foreach ( void delegate(guint, string, Statusbar) dlg ; _statusbar.onTextPushedListeners )
		{
			dlg(contextId, Str.toString(text), _statusbar);
		}
	}
	
	
	/**
	 * Creates a new GtkStatusbar ready for messages.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget * gtk_statusbar_new (void);
		auto p = gtk_statusbar_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_statusbar_new()");
		}
		this(cast(GtkStatusbar*) p);
	}
	
	/**
	 * Returns a new context identifier, given a description
	 * of the actual context. Note that the description is
	 * not shown in the UI.
	 * Params:
	 * contextDescription = textual description of what context
	 * the new message is being used in
	 * Returns: an integer id
	 */
	public uint getContextId(string contextDescription)
	{
		// guint gtk_statusbar_get_context_id (GtkStatusbar *statusbar,  const gchar *context_description);
		return gtk_statusbar_get_context_id(gtkStatusbar, Str.toStringz(contextDescription));
	}
	
	/**
	 * Pushes a new message onto a statusbar's stack.
	 * Params:
	 * contextId = the message's context id, as returned by
	 * gtk_statusbar_get_context_id()
	 * text = the message to add to the statusbar
	 * Returns: a message id that can be used with gtk_statusbar_remove().
	 */
	public uint push(uint contextId, string text)
	{
		// guint gtk_statusbar_push (GtkStatusbar *statusbar,  guint context_id,  const gchar *text);
		return gtk_statusbar_push(gtkStatusbar, contextId, Str.toStringz(text));
	}
	
	/**
	 * Removes the first message in the GtkStatusbar's stack
	 * with the given context id.
	 * Note that this may not change the displayed message, if
	 * the message at the top of the stack has a different
	 * context id.
	 * Params:
	 * contextId = a context identifier
	 */
	public void pop(uint contextId)
	{
		// void gtk_statusbar_pop (GtkStatusbar *statusbar,  guint context_id);
		gtk_statusbar_pop(gtkStatusbar, contextId);
	}
	
	/**
	 * Forces the removal of a message from a statusbar's stack.
	 * The exact context_id and message_id must be specified.
	 * Params:
	 * contextId = a context identifier
	 * messageId = a message identifier, as returned by gtk_statusbar_push()
	 */
	public void remove(uint contextId, uint messageId)
	{
		// void gtk_statusbar_remove (GtkStatusbar *statusbar,  guint context_id,  guint message_id);
		gtk_statusbar_remove(gtkStatusbar, contextId, messageId);
	}
	
	/**
	 * Forces the removal of all messages from a statusbar's
	 * stack with the exact context_id.
	 * Since 2.22
	 * Params:
	 * contextId = a context identifier
	 */
	public void removeAll(uint contextId)
	{
		// void gtk_statusbar_remove_all (GtkStatusbar *statusbar,  guint context_id);
		gtk_statusbar_remove_all(gtkStatusbar, contextId);
	}
}
