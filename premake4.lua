solution "pigz"
   configurations { "Debug", "Release" }
   location "build"

   flags { "Symbols", "StaticRuntime" }

   configuration "Debug"
       targetdir "dbg"

   configuration "Release"
       targetdir "rel"
       flags { "Optimize" }
       defines { "NDEBUG" }

   configuration {"vs*"}
      defines { "_WIN32", "WIN32", "WINDOWS", "_CRT_SECURE_NO_WARNINGS" }

project "pigz"
   kind "ConsoleApp"
   language "C"
   files { "*.h", "*.c", "zopfli/*.h", "zopfli/*.c" }
   excludes { "zopfli/zopfli.c" }
   includedirs { "zlib", "../pthread-win32" }
   links {  "zlib", "winpthreads" }

   configuration {"vs*"}
      -- defines { "NOTHREAD" }
      -- excludes { "yarn.c" }
      buildoptions {"/wd4996", "/wd4244", "/wd4305" }
      linkoptions {"/NODEFAULTLIB:\"msvcrt.lib\""}

   configuration "Debug"
       defines { "_DEBUG" }

project "zlib"
   kind "StaticLib"
   language "C"
   files { "zlib/*.c", "zlib/*.h" }
   excludes { "zlib/gzclose.c", "zlib/gzread.c", "zlib/gzwrite.c", "zlib/gzlib.c"}
   includedirs { "zlib" }

project "winpthreads"
   kind "StaticLib"
   language "C"
   files {
      "../pthread-win32/*.h",
      "../pthread-win32/pthread.c"
   }
   includedirs { "../pthread-win32" }
