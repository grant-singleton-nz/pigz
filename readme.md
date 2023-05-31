This is a fork of [pigz](http://zlib.net/pigz/) that adds Windows
support, courtesy of [Krzysztof Kowalczyk](http://blog.kowalczyk.info).

To download binaries: http://blog.kowalczyk.info/software/pigz-for-windows.html

## How to build

First, get [premake](http://industriousone.com/premake) and put somewhere in
the `%PATH%`. I use premake 4.3

### Building via script

You can run `scripts\build.bat` (python required), which will auto-detect
Visual Studio 2010 or 2012, build and run tests.

The result (`pigz.exe` and `unpigz.exe`) will be in `rel` directory.

### Building manually

Alternatively, do it manually:

For Visual Studio 2008:
 - run `premake4 vs2008` to generate Visual Studio 2008 solution
 - open `build\pigz.sln` in Visual Studio and build

For Visual Studio 2010:
 - run `premake4 vs2010` to generate Visual Studio 2010 solution
 - open `build\pigz.sln` in Visual Studio 2010 and build

For Visual Studio 2012:
 - run `premake4 vs2010` to generate Visual Studio 2012 solution
 - open `build\pigz.sln` in Visual Studio 2012. You'll have to convert to
   VS 2012 format, but it should work

## How the port was made

Pigz uses pthreads for threading. For easy porting, I used [pthread-win32](
https://github.com/GerHobbelt/pthread-win32).

I used `dirent.[c|h]` from http://www.two-sdg.demon.co.uk/curbralan/code/dirent/dirent.html.

I wrote a simple win32/wincompat.h that aliases names of some Unix functions to
their win32 equivalents.

I used [premake](http://industriousone.com/premake) for the build system.
