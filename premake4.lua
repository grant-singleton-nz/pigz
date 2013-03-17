solution "pigz"
   configurations { "Debug", "Release" }

   -- A project defines one build target

   project "pigz"
      kind "ConsoleApp"
      language "C"
      files { "**.h", "**.c" }
      excludes { "zopfli/zopfli.c" }
      includedirs {"zlib"}

      configuration {"vs*"}
         defines { "WIN32", "WINDOWS", "_DEBUG", "_CRT_SECURE_NO_WARNINGS", "NOTHREAD" }
         excludes { "yarn.c" }
         buildoptions {"/wd4996", "/wd4244", "/wd4305" }

      configuration "Debug"
         defines { }
         flags { "Symbols" }

      configuration "Release"
         defines { "NDEBUG" }
         flags { "Optimize", "Symbols" }
