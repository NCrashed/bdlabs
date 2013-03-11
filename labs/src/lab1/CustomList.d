module customlist;

import glib.RandG;
import gobject.Value;
import gtk.TreeIter;
import gtk.TreePath;
import gtk.TreeModel;
import util.common;
import std.traits;

struct CustomRecord
{
	/* admin stuff used by the custom list model */
	uint pos;   /* pos within the array */

	/* data - you can extend this */
	string Name;
	string Subject;
}

/*enum CustomListColumn
{
	Record = 0,
	Name,
	Subject,
	NColumns,
}*/

private template generateEnum(Aggregate, string enumName)
{
	alias FieldNameTuple!(Aggregate) fieldNames;

	static string generateBody(string[] fields)
	{
		if(fields.length == 0)
			return "";
		else if(fields[0] == "pos")
			return generateBody(fields[1..$]);
		else 
			return "\t"~fields[0]~",\n"~generateBody(fields[1..$]);
	}

	enum generateEnum = "enum "~enumName~"\n{\n\tRecord = 0,\n" ~ generateBody(fieldNames) ~ "}\n";
}

class CustomList(Aggregate) : TreeModel
{
	static assert(isAggregateType!Aggregate, "CustomList: "~Aggregate.stringof~" must be a aggregate type!");
	static assert(hasMember!(Aggregate, "pos"), "CustomList: "~Aggregate.stringof~" must have 'uint pos' member!");
	static assert(is(getMemberType!(Aggregate, "pos") == uint), "CustomList: "~Aggregate.stringof~" 'pos' member should be uint type!");
	static assert(fieldNames[0] == "pos", "CustomList: please, put 'pos' member first!");

	alias FieldNameTuple!(Aggregate) fieldNames;
	alias TypeTupleFrom!(Aggregate, fieldNames) fieldTypes;

	mixin(generateEnum!(Aggregate, "Column"));

	// fields
	enum nColumns = fieldNames.length;
	uint numRows;

	int stamp;
	GType[nColumns] columnTypes;
	Aggregate*[] rows;

	public this()
	{
		columnTypes[0] = GType.POINTER;
		foreach(i, type; fieldTypes[1..$])
		{
			columnTypes[i+1] = mapType2GType!type();
		}

		stamp = RandG.randomInt();
	}

	private static GType mapType2GType(T)()
	{
		static if(is(T == string))
			return GType.STRING;
		else static if(is(T == bool))
			return GType.BOOLEAN;
		else static if(is(T == int))
			return GType.INT;
		else static if(is(T == uint))
			return GType.UINT;
		else static if(is(T == long))
			return GType.ULONG;
		else static if(is(T == ulong))
			return GType.ULONG;
		else static if(is(T == float))
			return GType.FLOAT;
		else static if(is(T == double))
			return GType.DOUBLE;
		else static if(is(T == void*))
			return GType.POINTER;
		else static assert(false, "mapType2GType doesn't support type "~T.stringof);
	}

	private static string mapField2ValueSetter(T)()
	{
		static if(is(T == string))
			return "String";
		else static if(is(T == bool))
			return "Boolean";
		else static if(is(T == int))
			return "Int";
		else static if(is(T == uint))
			return "Uint";
		else static if(is(T == long))
			return "Long";
		else static if(is(T == ulong))
			return "Ulong";
		else static if(is(T == float))
			return "Float";
		else static if(is(T == double))
			return "Double";
		else static if(is(T == void*))
			return "Pointer";
		else static assert(false, "mapField2ValueSetter doesn't support type "~T.stringof);
	}

	/*
	 * tells the rest of the world whether our tree model
	 * has any special characteristics. In our case,
	 * we have a list model (instead of a tree), and each
	 * tree iter is valid as long as the row in question
	 * exists, as it only contains a pointer to our struct.
	 */
	override GtkTreeModelFlags getFlags()
	{
		return (GtkTreeModelFlags.LIST_ONLY | GtkTreeModelFlags.ITERS_PERSIST);
	}


	/*
	 * tells the rest of the world how many data
	 * columns we export via the tree model interface
	 */

	override int getNColumns()
	{
		return nColumns;
	}

	/*
	 * tells the rest of the world which type of
	 * data an exported model column contains
	 */
	override GType getColumnType(int index)
	{
		if ( index >= nColumns || index < 0 )
			return GType.INVALID;

		return columnTypes[index];
	}

	/*
	 * converts a tree path (physical position) into a
	 * tree iter structure (the content of the iter
	 * fields will only be used internally by our model).
	 * We simply store a pointer to our CustomRecord
	 * structure that represents that row in the tree iter.
	 */
	override int getIter(TreeIter iter, TreePath path)
	{
		Aggregate* 		record;
		int[]         	indices;
		int           	n, depth;

		indices = path.getIndices();
		depth   = path.getDepth();

		/* we do not allow children */
		if (depth != 1)
			return false;//throw new Exception("We only except lists");

		n = indices[0]; /* the n-th top level row */

		if ( n >= numRows || n < 0 )
			return false;

		record = rows[n];

		if ( record is null )
			throw new Exception("Not Exsisting record requested");
		if ( record.pos != n )
			throw new Exception("record.pos != TreePath.getIndices()[0]");

		/* We simply store a pointer to our custom record in the iter */
		iter.stamp     = stamp;
		iter.userData  = record;

		return true;
	}


	/*
	 * converts a tree iter into a tree path (ie. the
	 * physical position of that row in the list).
	 */
	override TreePath getPath(TreeIter iter)
	{
		TreePath path;
		Aggregate* record;
	  
		if ( iter is null || iter.userData is null || iter.stamp != stamp )
			return null;

		record = cast(Aggregate*) iter.userData;

		path = new TreePath(record.pos);

		return path;
	}

	private template genGetValueSwitch()
	{
		static string genSwitchBody()
		{
			string ret = "";
			foreach(i, type; fieldTypes)
			{
				if(fieldNames[i] == "pos")
					ret ~= "\tcase Column.Record:\n\t\tvalue.setPointer(record);\n\t\tbreak;\n";
				else 
					ret ~= "\tcase Column."~fieldNames[i]~":\n\t\tvalue.set"~mapField2ValueSetter!(type)()~"(record."~fieldNames[i]~");\n\t\tbreak;\n";
			}
			return ret;
		}
		
		enum genGetValueSwitch = "switch(column)\n{\n"~genSwitchBody()~"\tdefault:\n\t\tbreak;\n}\n";	
	}

	/*
	 * Returns a row's exported data columns
	 * (_get_value is what gtk_tree_model_get uses)
	 */
	override Value getValue(TreeIter iter, int column, Value value = null)
	{
		Aggregate  *record;

		if ( value is null )
			value = new Value();

		if ( iter is null || column >= nColumns || iter.stamp != stamp )
			return null;

		value.init(columnTypes[column]);

		record = cast(Aggregate*) iter.userData;

		if ( record is null || record.pos >= numRows )
			return null;
		
		//pragma(msg, genGetValueSwitch!());
		mixin(genGetValueSwitch!());

		return value;
	}


	/*
	 * Takes an iter structure and sets it to point
	 * to the next row.
	 */
	override int iterNext(TreeIter iter)
	{
		Aggregate* record, nextrecord;
	  
		if ( iter is null || iter.userData is null || iter.stamp != stamp )
			return false;

		record = cast(Aggregate*) iter.userData;

		/* Is this the last record in the list? */
		if ( (record.pos + 1) >= numRows)
			return false;

		nextrecord = rows[(record.pos + 1)];

		if ( nextrecord is null || nextrecord.pos != record.pos + 1 )
			throw new Exception("Invalid next record");

		iter.stamp     = stamp;
		iter.userData  = nextrecord;

		return true;
	}


	/*
	 * Returns TRUE or FALSE depending on whether
	 * the row specified by 'parent' has any children.
	 * If it has children, then 'iter' is set to
	 * point to the first child. Special case: if
	 * 'parent' is NULL, then the first top-level
	 * row should be returned if it exists.
	 */

	override int iterChildren(TreeIter iter, TreeIter parent)
	{
		/* this is a list, nodes have no children */
		if ( parent !is null )
			return false;

		/* No rows => no first row */
		if ( numRows == 0 )
			return false;

		/* Set iter to first item in list */
		iter.stamp     = stamp;
		iter.userData  = rows[0];

		return true;
	}


	/*
	 * Returns TRUE or FALSE depending on whether
	 * the row specified by 'iter' has any children.
	 * We only have a list and thus no children.
	 */
	override int iterHasChild(TreeIter iter)
	{
		return false;
	}


	/*
	 * Returns the number of children the row
	 * specified by 'iter' has. This is usually 0,
	 * as we only have a list and thus do not have
	 * any children to any rows. A special case is
	 * when 'iter' is NULL, in which case we need
	 * to return the number of top-level nodes,
	 * ie. the number of rows in our list.
	 */
	override int iterNChildren(TreeIter iter)
	{
		/* special case: if iter == NULL, return number of top-level rows */
		if ( iter is null )
			return numRows;

		return 0; /* otherwise, this is easy again for a list */
	}


	/*
	 * If the row specified by 'parent' has any
	 * children, set 'iter' to the n-th child and
	 * return TRUE if it exists, otherwise FALSE.
	 * A special case is when 'parent' is NULL, in
	 * which case we need to set 'iter' to the n-th
	 * row if it exists.
	 */
	override int iterNthChild(TreeIter iter, TreeIter parent, int n)
	{
		Aggregate  *record;

		/* a list has only top-level rows */
		if( parent is null )
			return false;

		if( n >= numRows )
			return false;

		record = rows[n];

		if ( record == null || record.pos != n )
			throw new Exception("Invalid record");

		iter.stamp     = stamp;
		iter.userData  = record;

		return true;
	}


	/*
	 * Point 'iter' to the parent node of 'child'. As
	 * we have a list and thus no children and no
	 * parents of children, we can just return FALSE.
	 */
	override int iterParent(TreeIter iter, TreeIter child)
	{
		return false;
	}

	/*
	 * Empty lists are boring. This function can
	 * be used in your own code to add rows to the
	 * list. Note how we emit the "row-inserted"
	 * signal after we have appended the row
	 * internally, so the tree view and other
	 * interested objects know about the new row.
	 */
	void appendRecord(Aggregate record)
	{
		TreeIter      	iter;
		TreePath      	path;
		Aggregate* 		newrecord;
		uint          	pos;

		pos = numRows;
		numRows++;
		
		newrecord = new Aggregate;

		foreach(i, type; fieldTypes[1..$])
			mixin("newrecord."~fieldNames[i+1]~" = record."~fieldNames[i+1]~";");

		rows ~= newrecord;
		newrecord.pos = pos;

		/* inform the tree view and other interested objects
		 *  (e.g. tree row references) that we have inserted
		 *  a new row, and where it was inserted */

		path = new TreePath(pos);

		iter = new TreeIter();
		getIter(iter, path);

		rowInserted(path, iter);
	}

	void clear()
	{
		auto oldNum = numRows;
		numRows = 0;
		rows = new Aggregate*[0];

		/* inform the tree view and other interested objects
		 *  (e.g. tree row references) that we have inserted
		 *  a new row, and where it was inserted */

		foreach_reverse(i; 0 .. oldNum)
		{
			auto path = new TreePath(i);
			rowDeleted(path);
		}
	}
}
