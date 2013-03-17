solution "pigz"
   configurations { "Debug", "Release" }
   location "build"

project "pigz"
   targetname "pigz"
   kind "ConsoleApp"
   location "build"
   language "C"
   files { "*.h", "*.c", "zopfli/*.h", "zopfli/*.c" }
   excludes { "zopfli/zopfli.c" }
   includedirs {"zlib"}
   links { "zlib" }

   configuration {"vs*"}
      defines { "WIN32", "WINDOWS", "_CRT_SECURE_NO_WARNINGS", "NOTHREAD" }
      excludes { "yarn.c" }
      buildoptions {"/wd4996", "/wd4244", "/wd4305" }
      linkoptions {"/NODEFAULTLIB:\"msvcrt.lib\""}

   configuration "Debug"
       defines { "_DEBUG" }
       flags { "Symbols", "StaticRuntime" }
       targetdir "dbg"

   configuration "Release"
       defines { "NDEBUG" }
       flags { "Optimize", "Symbols", "StaticRuntime" }
       targetdir "rel"

project "zlib"
   kind "StaticLib"
   location "build"
   language "C"
   includedirs { "zlib" }
   files { "zlib/*.c", "zlib/*.h" }

   excludes { "zlib/gzclose.c", "zlib/gzread.c", "zlib/gzwrite.c", "zlib/gzlib.c"}

   configuration {"vs*"}
      defines { "_WIN32", "WINDOWS", "_CRT_SECURE_NO_WARNINGS" }

   configuration "Debug"
       flags { "Symbols", "StaticRuntime" }
       targetdir "dbg"

   configuration "Release"
       defines { "NDEBUG" }
       flags { "Optimize", "Symbols", "StaticRuntime" }
       targetdir "rel"
