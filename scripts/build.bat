@CALL "%VS100COMNTOOLS%\vsvars32.bat" 2>NUL
IF NOT ERRORLEVEL 1 GOTO FOUNDVS
@CALL "%VS110COMNTOOLS%\vsvars32.bat" 2>NUL
IF NOT ERRORLEVEL 1 GOTO FOUNDVS

ECHO Visual Studio 2012 or 2010 doesn't seem to be installed
EXIT /B 1

:FOUNDVS
@set PATH=c:\Python27;%PATH%
@rem work-around cygwin/msdev issue
@set tmp=
@set temp=

python -u -B scripts\build.py %1 %2 %3
