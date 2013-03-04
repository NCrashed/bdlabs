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
module derelict.ogg.vorbisfile;

public
{
    import derelict.ogg.vorbisfiletypes;
    import derelict.ogg.vorbisfilefunctions;
}

private
{
    import derelict.util.loader;
    import derelict.util.system;

    static if(Derelict_OS_Windows)
        enum libNames = "vorbisfile.dll, libvorbisfile.dll";
    else static if(Derelict_OS_Mac)
        enum libNames = "libvorbisfile.dylib, libvorbisfile.0.dylib";
    else static if(Derelict_OS_Posix)
        enum libNames = "libvorbisfile.so, libvorbisfile.so.3, libvorbisfile.so.3.1.0";
    else
        static assert(0, "Need to implement libvorbisfile libnames for this operating system.");
}

class DerelictVorbisFileLoader : SharedLibLoader
{
protected:
    override void loadSymbols()
    {
        bindFunc(cast(void**)&ov_clear, "ov_clear");
        // bindFunc(cast(void**)&ov_fopen, "ov_fopen");
        bindFunc(cast(void**)&ov_open_callbacks, "ov_open_callbacks");

        // bindFunc(cast(void**)&ov_test, "ov_test");
        bindFunc(cast(void**)&ov_test_callbacks, "ov_test_callbacks");
        bindFunc(cast(void**)&ov_test_open, "ov_test_open");

        bindFunc(cast(void**)&ov_bitrate, "ov_bitrate");
        bindFunc(cast(void**)&ov_bitrate_instant, "ov_bitrate_instant");
        bindFunc(cast(void**)&ov_streams, "ov_streams");
        bindFunc(cast(void**)&ov_seekable, "ov_seekable");
        bindFunc(cast(void**)&ov_serialnumber, "ov_serialnumber");

        bindFunc(cast(void**)&ov_raw_total, "ov_raw_total");
        bindFunc(cast(void**)&ov_pcm_total, "ov_pcm_total");
        bindFunc(cast(void**)&ov_time_total, "ov_time_total");

        bindFunc(cast(void**)&ov_raw_seek, "ov_raw_seek");
        bindFunc(cast(void**)&ov_pcm_seek, "ov_pcm_seek");
        bindFunc(cast(void**)&ov_pcm_seek_page, "ov_pcm_seek_page");
        bindFunc(cast(void**)&ov_time_seek, "ov_time_seek");
        bindFunc(cast(void**)&ov_time_seek_page, "ov_time_seek_page");

        bindFunc(cast(void**)&ov_raw_seek_lap, "ov_raw_seek_lap");
        bindFunc(cast(void**)&ov_pcm_seek_lap, "ov_pcm_seek_lap");
        bindFunc(cast(void**)&ov_pcm_seek_page_lap, "ov_pcm_seek_page_lap");
        bindFunc(cast(void**)&ov_time_seek_lap, "ov_time_seek_lap");
        bindFunc(cast(void**)&ov_time_seek_page_lap, "ov_time_seek_page_lap");

        bindFunc(cast(void**)&ov_raw_tell, "ov_raw_tell");
        bindFunc(cast(void**)&ov_pcm_tell, "ov_pcm_tell");
        bindFunc(cast(void**)&ov_time_tell, "ov_time_tell");

        bindFunc(cast(void**)&ov_info, "ov_info");
        bindFunc(cast(void**)&ov_comment, "ov_comment");

        bindFunc(cast(void**)&ov_read_float, "ov_read_float");
        bindFunc(cast(void**)&ov_read_filter, "ov_read_filter");
        bindFunc(cast(void**)&ov_read, "ov_read");
        bindFunc(cast(void**)&ov_crosslap, "ov_crosslap");

        bindFunc(cast(void**)&ov_halfrate, "ov_halfrate");
        bindFunc(cast(void**)&ov_halfrate_p, "ov_halfrate_p");
    }

    public
    {
        this()
        {
            super(libNames);
        }
    }
}

__gshared DerelictVorbisFileLoader DerelictVorbisFile;

static this()
{
    DerelictVorbisFile = new DerelictVorbisFileLoader();
}

static ~this()
{
    DerelictVorbisFile.unload();
}