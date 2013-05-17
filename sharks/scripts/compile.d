#!/usr/bin/rdmd
module compile;

import dmake;

import std.stdio;
import std.process;


string[string] labDepends;

static this()
{
        labDepends =
        [
                "GtkD": "../../gtkD",
                "Derelict3": "../../Derelict3"
        ];
}


//======================================================================
//                           Main part
//======================================================================
int main(string[] args)
{
        addCompTarget("sharks", "../bin", "sharks", BUILD.APP);
        setDependPaths(labDepends);

        addLibraryFiles("GtkD", "build", ["GtkD"], ["src"], 
                (string libPath)
                {
                        writeln("Building GtkD lib...");
                        assert(false, "Please, build manually or write script!");
                });

        addLibraryFiles("Derelict3", "lib", ["DerelictPQ", "DerelictUtil"], ["import"], 
                (string libPath)
                {
                        writeln("Building Derelict3 lib...");
                        version(Windows)
                                system("cd "~libPath~`/build && dmd build.d && build`);
                        else   
                                system("cd "~libPath~`/build && dmd build.d && ./build`);
                });

        addSource("../src");
        
        //addCustomFlags("-m64");
        //addCustomFlags("-D -Dd../docs ../docs/candydoc/candy.ddoc ../docs/candydoc/modules.ddoc");

        checkProgram("dmd", "Cannot find dmd to compile project! You can get it from http://dlang.org/download.html");
        return proceedCmd(args);
}
