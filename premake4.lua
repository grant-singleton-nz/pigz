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
   files { "*.h", "*.c", "zopfli/src/zopfli/*.h", "zopfli/src/zopfli/*.c", "win32/*"}
   excludes { "zopfli/zopfli_bin.c" }
   includedirs { "win32", "zlib", "pthread-win32" }
   links {  "zlib", "pthread-win32" }

   configuration {"vs*"}
      buildoptions {"/wd4996", "/wd4244", "/wd4305" }
      linkoptions {"/NODEFAULTLIB:\"msvcrt.lib\""}

   defines { "PTW32_STATIC_LIB", "PTW32_CLEANUP_C" }

   configuration "Debug"
       defines { "_DEBUG" }

-- yes, this is the same as pigz, just with a different name
project "unpigz"
   kind "ConsoleApp"
   language "C"
   files { "*.h", "*.c", "zopfli/src/zopfli/*.h", "zopfli/src/zopfli/*.c", "win32/*"}
   excludes { "zopfli/zopfli_bin.c" }
   includedirs { "win32", "zlib", "pthread-win32" }
   links {  "zlib", "pthread-win32" }
   defines { "PTW32_STATIC_LIB", "PTW32_CLEANUP_C" }

   configuration {"vs*"}
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

project "pthread-win32"
   kind "StaticLib"
   language "C"
   files {
      "pthread-win32/*.h",
      "pthread-win32/pthread.c"
   }
   defines { "__PTHREAD_JUMBO_BUILD__" , "PTW32_STATIC_LIB", "HAVE_CONFIG_H", "PT32_CLEANUP_C"  }
   includedirs { "pthread-win32" }
