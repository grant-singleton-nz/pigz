This is a fork of pigz (http://zlib.net/pigz/) that adds Windows
support, made by Krzysztof Kowalczyk (http://blog.kowalczyk.info).

To build:
 - get premake from http://industriousone.com/premake. I use premake 4.4

For Visual Studio 2010:
 - run `premake4 vs2010` to generate Visual Studio 2010 solution
 - open `build\pigz.sln` in Visual Studio 2010 and build

For Visual Studio 2008:
 - run `premake4 vs2008` to generate Visual Studio 2008 solution
 - open `build\pigz.sln` in Visual Studio and build

For Visual Studio 2012:
 - run `premake4 vs2010` to generate Visual Studio 2012 solution
 - open `build\pigz.sln` in Visual Studio 2012. You'll have to convert to
   VS 2012 format, but it should work

How it was made:
 - used pthread-win32 from https://github.com/GerHobbelt/pthread-win32
   changes: defined those at the top of pthread.h
     #define __CLEANUP_C
     #define PTW32_STATIC_LIB
 - used dirent.[c|h] from http://www.two-sdg.demon.co.uk/curbralan/code/dirent/dirent.html
 - I wrote a simple win32/compat.h that aliases win32 names into unix names
