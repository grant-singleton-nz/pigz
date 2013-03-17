project "zlib"
  kind "StaticLib"
  language "C"
    -- targetdir "../../lib"
    includedirs { "." }
    files { "**.c", "**.h" }
    excludes { "gzclose.c", "gzread.c", "gzwrite.c", "gzlib.c"}

    configuration {"vs*"}
        defines { "_WIN32", "WINDOWS", "_CRT_SECURE_NO_WARNINGS" }
