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
module derelict.glu.functions;

import derelict.glu.types;

// Callbacks used as parameters to some of the functions below.
extern(C)
{
    //alias void function(int) da_intCallback;

}

extern(System)
{
    // From glut.h
	alias nothrow void function(GLdouble, GLdouble, GLdouble, GLdouble) da_gluPerspective;
	alias nothrow void function(GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble) da_gluLookAt;
	alias nothrow GLint function(GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLenum format, GLenum type, const void * data) da_gluBuild2DMipmaps;
}

__gshared
{
	da_gluPerspective gluPerspective;
	da_gluLookAt gluLookAt;
	da_gluBuild2DMipmaps gluBuild2DMipmaps;
}