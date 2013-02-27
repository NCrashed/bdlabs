#!/usr/bin/rdmd
/// Скрипт автоматической компиляции проекта 
module compile;

import dmake;

import std.stdio;
import std.process;


string[string] labDepends;

static this()
{
        labDepends =
        [
                "GtkD": "../../gtkD"
        ];
}


//======================================================================
//                           Основная часть
//======================================================================
int main(string[] args)
{
        // Клиент
        addCompTarget("lab1", "../bin", "lab1", BUILD.APP);
        setDependPaths(labDepends);

        addLibraryFiles("GtkD", "build", ["GtkD"], ["src"], 
                (string libPath)
                {
                        writeln("Building Derelict3 lib...");
                        system("cd "~libPath~`/build && rdmd build.d`);
                });

        addSource("../src/lab1");

        //addCustomFlags("-D -Dd../docs ../docs/candydoc/candy.ddoc ../docs/candydoc/modules.ddoc -version=CL_VERSION_1_1");

        checkProgram("dmd", "Cannot find dmd to compile project! You can get it from http://dlang.org/download.html");
        // Компиляция!
        return proceedCmd(args);
}