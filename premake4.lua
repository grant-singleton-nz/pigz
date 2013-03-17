solution "pigz"
   configurations { "Debug", "Release" }

   -- A project defines one build target

   project "pigz"
      kind "ConsoleApp"
      language "C"
      files { "**.h", "**.c" }

      configuration "windows"
         defines { "WIN32", "WINDOWS", "_DEBUG", "_CRT_SECURE_NO_WARNINGS" }
         excludes { "yarn.c" }
      configuration "Debug"
         defines { "DEBUG" }
         flags { "Symbols" }

      configuration "Release"
         defines { "NDEBUG" }
         flags { "Optimize", "Symbols" }
