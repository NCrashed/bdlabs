module dpq2.all;

public
{
	import derelict.pq.pq;
	import dpq2.answer;
	import dpq2.connection;
	import dpq2.fields;
	import dpq2.query;
}

static this()
{
	DerelictPQ.load();
	DerelictPQ.disableAutoUnload();
}

static ~this()
{
	import core.memory;
	GC.collect();
	DerelictPQ.unload();
}