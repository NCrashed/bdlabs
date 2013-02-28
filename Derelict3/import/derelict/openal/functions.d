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
module derelict.openal.functions;

private
{
    import derelict.openal.types;
}

extern(C)
{
    alias nothrow void function(ALenum) da_alEnable;
    alias nothrow void function(ALenum) da_alDisable;
    alias nothrow ALboolean function(ALenum) da_alIsEnabled;

    alias nothrow const(char)* function(ALenum) da_alGetString;
    alias nothrow void function(ALenum, ALboolean*) da_alGetBooleanv;
    alias nothrow void function(ALenum, ALint*) da_alGetIntegerv;
    alias nothrow void function(ALenum, ALfloat*) da_alGetFloatv;
    alias nothrow void function(ALenum, ALdouble*) da_alGetDoublev;
    alias nothrow ALboolean function(ALenum) da_alGetBoolean;
    alias nothrow ALint function(ALenum) da_alGetInteger;
    alias nothrow ALfloat function(ALenum) da_alGetFloat;
    alias nothrow ALdouble function(ALenum) da_alGetDouble;
    alias nothrow ALenum function() da_alGetError;

    alias nothrow ALboolean function(in char*) da_alIsExtensionPresent;
    alias nothrow ALboolean function(in char*) da_alGetProcAddress;
    alias nothrow ALenum function(in char*) da_alGetEnumValue;

    alias nothrow void function(ALenum, ALfloat) da_alListenerf;
    alias nothrow void function(ALenum, ALfloat, ALfloat, ALfloat) da_alListener3f;
    alias nothrow void function(ALenum, in ALfloat*) da_alListenerfv;
    alias nothrow void function(ALenum, ALint) da_alListeneri;
    alias nothrow void function(ALenum, ALint, ALint, ALint) da_alListener3i;
    alias nothrow void function(ALenum, in ALint*) da_alListeneriv;

    alias nothrow void function(ALenum, ALfloat*) da_alGetListenerf;
    alias nothrow void function(ALenum, ALfloat*, ALfloat*, ALfloat*) da_alGetListener3f;
    alias nothrow void function(ALenum, ALfloat*) da_alGetListenerfv;
    alias nothrow void function(ALenum, ALint*) da_alGetListeneri;
    alias nothrow void function(ALenum, ALint*, ALint*, ALint*) da_alGetListener3i;
    alias nothrow void function(ALenum, ALint*) da_alGetListeneriv;

    alias nothrow void function(ALsizei, ALuint*) da_alGenSources;
    alias nothrow void function(ALsizei, in ALuint*) da_alDeleteSources;
    alias nothrow ALboolean function(ALuint) da_alIsSource;

    alias nothrow void function(ALuint, ALenum, ALfloat) da_alSourcef;
    alias nothrow void function(ALuint, ALenum, ALfloat, ALfloat, ALfloat) da_alSource3f;
    alias nothrow void function(ALuint, ALenum, in ALfloat*) da_alSourcefv;
    alias nothrow void function(ALuint, ALenum, ALint) da_alSourcei;
    alias nothrow void function(ALuint, ALenum, ALint, ALint, ALint) da_alSource3i;
    alias nothrow void function(ALuint, ALenum, in ALint*) da_alSourceiv;

    alias nothrow void function(ALuint, ALenum, ALfloat*) da_alGetSourcef;
    alias nothrow void function(ALuint, ALenum, ALfloat*, ALfloat*, ALfloat*) da_alGetSource3f;
    alias nothrow void function(ALuint, ALenum, ALfloat*) da_alGetSourcefv;
    alias nothrow void function(ALuint, ALenum, ALint*) da_alGetSourcei;
    alias nothrow void function(ALuint, ALenum, ALint*, ALint*, ALint*) da_alGetSource3i;
    alias nothrow void function(ALuint, ALenum, ALint*) da_alGetSourceiv;

    alias nothrow void function(ALsizei, in ALuint*) da_alSourcePlayv;
    alias nothrow void function(ALsizei, in ALuint*) da_alSourceStopv;
    alias nothrow void function(ALsizei, in ALuint*) da_alSourceRewindv;
    alias nothrow void function(ALsizei, in ALuint*) da_alSourcePausev;
    alias nothrow void function(ALuint) da_alSourcePlay;
    alias nothrow void function(ALuint) da_alSourcePause;
    alias nothrow void function(ALuint) da_alSourceRewind;
    alias nothrow void function(ALuint) da_alSourceStop;

    alias nothrow void function(ALuint, ALsizei, ALuint*) da_alSourceQueueBuffers;
    alias nothrow void function(ALuint, ALsizei, ALuint*) da_alSourceUnqueueBuffers;

    alias nothrow void function(ALsizei, ALuint*) da_alGenBuffers;
    alias nothrow void function(ALsizei, in ALuint*) da_alDeleteBuffers;
    alias nothrow ALboolean function(ALuint) da_alIsBuffer;
    alias nothrow void function(ALuint, ALenum, in ALvoid*, ALsizei, ALsizei) da_alBufferData;

    alias nothrow void function(ALuint, ALenum, ALfloat) da_alBufferf;
    alias nothrow void function(ALuint, ALenum, ALfloat, ALfloat, ALfloat) da_alBuffer3f;
    alias nothrow void function(ALuint, ALenum, in ALfloat*) da_alBufferfv;
    alias nothrow void function(ALuint, ALenum, ALint) da_alBufferi;
    alias nothrow void function(ALuint, ALenum, ALint, ALint, ALint) da_alBuffer3i;
    alias nothrow void function(ALuint, ALenum, in ALint*) da_alBufferiv;

    alias nothrow void function(ALuint, ALenum, ALfloat*) da_alGetBufferf;
    alias nothrow void function(ALuint, ALenum, ALfloat*, ALfloat*, ALfloat*) da_alGetBuffer3f;
    alias nothrow void function(ALuint, ALenum, ALfloat*) da_alGetBufferfv;
    alias nothrow void function(ALuint, ALenum, ALint*) da_alGetBufferi;
    alias nothrow void function(ALuint, ALenum, ALint*, ALint*, ALint*) da_alGetBuffer3i;
    alias nothrow void function(ALuint, ALenum, ALint*) da_alGetBufferiv;

    alias nothrow void function(ALfloat) da_alDopplerFactor;
    alias nothrow void function(ALfloat) da_alDopplerVelocity;
    alias nothrow void function(ALfloat) da_alSpeedOfSound;
    alias nothrow void function(ALenum) da_alDistanceModel;

    alias nothrow ALCcontext* function(ALCdevice*, in ALCint*) da_alcCreateContext;
    alias nothrow ALCboolean function(ALCcontext*) da_alcMakeContextCurrent;
    alias nothrow void function(ALCcontext*) da_alcProcessContext;
    alias nothrow void function(ALCcontext*) da_alcSuspendContext;
    alias nothrow void function(ALCcontext*) da_alcDestroyContext;
    alias nothrow ALCcontext* function() da_alcGetCurrentContext;
    alias nothrow ALCdevice* function(ALCcontext*) da_alcGetContextsDevice;
    alias nothrow ALCdevice* function(in char*) da_alcOpenDevice;
    alias nothrow ALCboolean function(ALCdevice*) da_alcCloseDevice;
    alias nothrow ALCenum function(ALCdevice*) da_alcGetError;
    alias nothrow ALCboolean function(ALCdevice*, in char*) da_alcIsExtensionPresent;
    alias nothrow void* function(ALCdevice*, in char*) da_alcGetProcAddress;
    alias nothrow ALCenum function(ALCdevice*, in char*) da_alcGetEnumValue;
    alias nothrow const(char)* function(ALCdevice*, ALCenum) da_alcGetString;
    alias nothrow void function(ALCdevice*, ALCenum, ALCsizei, ALCint*) da_alcGetIntegerv;
    alias nothrow ALCdevice* function(in char*, ALCuint, ALCenum, ALCsizei) da_alcCaptureOpenDevice;
    alias nothrow ALCboolean function(ALCdevice*) da_alcCaptureCloseDevice;
    alias nothrow void function(ALCdevice*) da_alcCaptureStart;
    alias nothrow void function(ALCdevice*) da_alcCaptureStop;
    alias nothrow void function(ALCdevice*, ALCvoid*, ALCsizei) da_alcCaptureSamples;
}

__gshared
{
    da_alEnable alEnable;
    da_alDisable alDisable;
    da_alIsEnabled alIsEnabled;

    da_alGetString alGetString;
    da_alGetBooleanv alGetBooleanv;
    da_alGetIntegerv alGetIntegerv;
    da_alGetFloatv alGetFloatv;
    da_alGetDoublev alGetDoublev;
    da_alGetBoolean alGetBoolean;
    da_alGetInteger alGetInteger;
    da_alGetFloat alGetFloat;
    da_alGetDouble alGetDouble;
    da_alGetError alGetError;

    da_alIsExtensionPresent alIsExtensionPresent;
    da_alGetProcAddress alGetProcAddress;
    da_alGetEnumValue alGetEnumValue;

    da_alListenerf alListenerf;
    da_alListener3f alListener3f;
    da_alListenerfv alListenerfv;
    da_alListeneri alListeneri;
    da_alListener3i alListener3i;
    da_alListeneriv alListeneriv;

    da_alGetListenerf alGetListenerf;
    da_alGetListener3f alGetListener3f;
    da_alGetListenerfv alGetListenerfv;
    da_alGetListeneri alGetListeneri;
    da_alGetListener3i alGetListener3i;
    da_alGetListeneriv alGetListeneriv;

    da_alGenSources alGenSources;
    da_alDeleteSources alDeleteSources;
    da_alIsSource alIsSource;

    da_alSourcef alSourcef;
    da_alSource3f alSource3f;
    da_alSourcefv alSourcefv;
    da_alSourcei alSourcei;
    da_alSource3i alSource3i;
    da_alSourceiv alSourceiv;


    da_alGetSourcef alGetSourcef;
    da_alGetSource3f alGetSource3f;
    da_alGetSourcefv alGetSourcefv;
    da_alGetSourcei alGetSourcei;
    da_alGetSource3i alGetSource3i;
    da_alGetSourceiv alGetSourceiv;

    da_alSourcePlayv alSourcePlayv;
    da_alSourceStopv alSourceStopv;
    da_alSourceRewindv alSourceRewindv;
    da_alSourcePausev alSourcePausev;
    da_alSourcePlay alSourcePlay;
    da_alSourcePause alSourcePause;
    da_alSourceRewind alSourceRewind;
    da_alSourceStop alSourceStop;

    da_alSourceQueueBuffers alSourceQueueBuffers;
    da_alSourceUnqueueBuffers alSourceUnqueueBuffers;

    da_alGenBuffers alGenBuffers;
    da_alDeleteBuffers alDeleteBuffers;
    da_alIsBuffer alIsBuffer;
    da_alBufferData alBufferData;

    da_alBufferf alBufferf;
    da_alBuffer3f alBuffer3f;
    da_alBufferfv alBufferfv;
    da_alBufferi alBufferi;
    da_alBuffer3i alBuffer3i;
    da_alBufferiv alBufferiv;
    da_alGetBufferf alGetBufferf;
    da_alGetBuffer3f alGetBuffer3f;
    da_alGetBufferfv alGetBufferfv;
    da_alGetBufferi alGetBufferi;
    da_alGetBuffer3i alGetBuffer3i;
    da_alGetBufferiv alGetBufferiv;

    da_alDopplerFactor alDopplerFactor;
    da_alDopplerVelocity alDopplerVelocity;
    da_alSpeedOfSound alSpeedOfSound;
    da_alDistanceModel alDistanceModel;

    da_alcCreateContext alcCreateContext;
    da_alcMakeContextCurrent alcMakeContextCurrent;
    da_alcProcessContext alcProcessContext;
    da_alcSuspendContext alcSuspendContext;
    da_alcDestroyContext alcDestroyContext;
    da_alcGetCurrentContext alcGetCurrentContext;
    da_alcGetContextsDevice alcGetContextsDevice;
    da_alcOpenDevice alcOpenDevice;
    da_alcCloseDevice alcCloseDevice;
    da_alcGetError alcGetError;
    da_alcIsExtensionPresent alcIsExtensionPresent;
    da_alcGetProcAddress alcGetProcAddress;
    da_alcGetEnumValue alcGetEnumValue;
    da_alcGetString alcGetString;
    da_alcGetIntegerv alcGetIntegerv;
    da_alcCaptureOpenDevice alcCaptureOpenDevice;
    da_alcCaptureCloseDevice alcCaptureCloseDevice;
    da_alcCaptureStart alcCaptureStart;
    da_alcCaptureStop alcCaptureStop;
    da_alcCaptureSamples alcCaptureSamples;
}