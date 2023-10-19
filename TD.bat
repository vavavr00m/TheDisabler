@echo off

set drive_letter=c d e f g h i j k l m n o p q r s t u v w x y z
set "001=-nosteam -nosplash -continuesession -BattleEye"
set "002=-nosteam -nosplash -continuesession"
set "003=-nosplash -continuesession -BattleEye"
set "004=-nosplash -continuesession"
set "005=-nosteam -nosplash -BattleEye"
set "006=-nosteam -nosplash"
set "007=-nosplash -BattleEye"
set "008=-nosplash"
set "009=-BattleEye"
set "010="
set ext=mp4 mov mkv m4p m4v webm flv f4v f4p f4a f4b vob ogv drc gifv mng avi mts m2ts ts qt wmv yuv rm rmvb viv asf amv mpg mp2 mpeg mpe mpv m2v svi 3gp 3g2 mxf roq nsv rv cpk dvr-ms wtv
goto :Conan_Exiles

:Conan_Exiles
set "title=Conan Exiles"
set "AppID=440900"
set "commons=steamapps\common\%title%\ConanSandbox"
set "gameiniloc=Saved\Config\WindowsNoEditor"
set "bin=Binaries\Win64\"
set "bin_BattleEye=ConanSandbox_BE.exe"
set "bin_Standard=ConanSandbox.exe"
goto :process

:process
echo.

setlocal enabledelayedexpansion
for %%A in (%drive_letter%) do if exist "%%A:\" (
	echo Existing drive found - %%A:\ - Searching for %title% directory
	for /f usebackq^tokens^=1-3*delims^=^" %%a in =;(
		`type "%~f0" ^| findstr /b \^"`
			);= do set "movies=%%A:\%%~c\%commons%\Content\Movies" && set "defaultgameini=%%A:\%%~c\%commons%\Config\DefaultGame.ini" && set "gameini=%%A:\%%~c\%commons%\%gameiniloc%\Game.ini" && set "game_ini=%%A:\%%~c\%commons%\%gameiniloc%\Game .ini" && set "outini=%%A:\%%~c\%commons%\%gameiniloc%\out.ini" && set "BE=%%A:\%%~c\%commons%\%bin%\%bin_BattleEye%" && set "STD=%%A:\%%~c\%commons%\%bin%\%bin_Standard%" && set "FCL=%%A:\%%~c\steamapps\common\%title%\Launcher\FuncomLauncher.exe" && set "servermodlist=%%A:\%%~c\%commons%\servermodlist.txt"
				
				if exist "!movies!" ( echo Found - "!movies!"
					if exist "!movies!\bak" (
					echo/
					for %%B in ("!movies!\*") do if not exist "!movies!\%%~nB" ( echo Creating a blank file - %%~nB && break>"!movies!\%%~nB" ) else ( echo Exists - "!movies!\%%~nB" )
					echo/
					for %%C in (%ext%) do if exist "!movies!\*.%%C" ( echo/ && echo Processing all %%C files in "!movies!\" && echo/ && dir "!movies!\*.%%C" && echo/ & echo/ && echo Moving the following to "!movies!\bak": && echo/ && @move "!movies!\*.%%C" "!movies!\bak" && echo/ ) else ( echo No file with %%C extension exists in "!movies!\" )
					echo/
				) else ( md "!movies!\bak" && goto :process )
				
				echo Searching for DefaultGame.ini to modify
				if exist "!defaultgameini!" ( echo Found - "!defaultgameini!". Modifying.. && echo/ && start "" /wait /min powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "(Get-Content -Path '!defaultgameini!') | ForEach-Object { $_.Replace(';+StartupMovies=StartupUE4','').Replace(';+StartupMovies=StartupNvidia','').Replace(';+StartupMovies=CinematicIntroV2','').Replace(';-StartupMovies=StartupUE4','').Replace(';-StartupMovies=StartupNvidia','').Replace(';-StartupMovies=CinematicIntroV2','').Replace('; -StartupMovies=StartupUE4','').Replace('; -StartupMovies=StartupNvidia','').Replace('; -StartupMovies=CinematicIntroV2','').Replace('; +StartupMovies=StartupUE4','').Replace('; +StartupMovies=StartupNvidia','').Replace('; +StartupMovies=CinematicIntroV2','').Replace('+StartupMovies=StartupUE4','').Replace('+StartupMovies=StartupNvidia','').Replace('+StartupMovies=CinematicIntroV2','').Replace('-StartupMovies=StartupUE4','').Replace('-StartupMovies=StartupNvidia','').Replace('-StartupMovies=CinematicIntroV2','').Replace('bWaitForMoviesToComplete=True','bWaitForMoviesToComplete=False').Replace('bMoviesAreSkippable=False','bMoviesAreSkippable=True').Replace('-StartupMovies=','').Replace(';-StartupMovies=','').Replace('; -StartupMovies=','') } | Set-Content -Path '!defaultgameini!'" 
				) else ( echo Does not exist - "!defaultgameini!" )
				
				echo Searching for Game.ini to add lines
				if exist "!gameini!" ( echo Found - "!gameini!"
	
				echo/ && echo Searching for backup game .ini and overwriting game.ini if it exists
				if exist "!game_ini!" ( echo Exists - "!game_ini!". Overwriting.. && copy "!game_ini!" "!gameini!" >nul
				fc /b "!game_ini!" "!gameini!" > nul
				if %errorlevel% EQU 0 echo File overwritten.
				if %errorlevel% EQU 1 echo Files are different.				
				) else ( echo Does not exist - "!game_ini!" )
				
				echo/ && echo Searching for out.ini and deleting if it exists
				if exist "!outini!" ( echo Exists - "!outini!". Deleting.. 
				del /s "!outini!" >nul
				if %errorlevel% EQU 0 echo File deleted.
				if %errorlevel% EQU 1 echo File does not exist.
				) else ( echo Does not exist - "!outini!" )
				
				call :loop

				) else ( echo Does not exist - "!gameini!" && type NUL > "!gameini!" && echo/ && call :loop )
				
	) else ( echo Nonexistent - "!movies!" )
) else ( echo Nonexistent drive - %%A:\ )
start "" /min "!gameini!"
call :launcher
endlocal
exit /b 0

:loop
echo/ && echo Changing Game.ini encoding to UTF-8
start "" /wait /min powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "(Get-ChildItem -Path '%gameini%' | ForEach-Object { (Get-Content $_) | Out-File -Encoding UTF8 $_ })"

echo/ && echo Defining the strings needed to be reviewed
set "n=0"
set "strings="
for %%a in (
	"[/Script/MoviePlayer.MoviePlayerSettings]"
	"bWaitForMoviesToComplete=False"
	"StartupMovies="
	) do (
	set /A n+=1
	set "string[!n!]=%%~a"
	set "strings=!strings!/C:"%%~a" "
)

rem Generate the output file:
(
rem First, insert the strings at beginning
for /L %%i in (1,1,%n%) do echo !string[%%i]!
echo/
rem Then, insert the lines in the file that have NOT the strings
for /F "delims=" %%a in ('findstr /V /L %strings% "%gameini%"') do echo %%a
) > "%outini%"

echo/ && echo Last step: Updating input file
move /Y "%outini%" "%gameini%"

echo/
endlocal
exit /b 0

:launcher
echo/
echo How you would like to launch %title%:
echo 0) Direct Connect
echo 1) "%bin_BattleEye%" "%001%"
echo 2) "%bin_Standard%" "%002%"
echo 3) "%bin_BattleEye%" "%003%"
echo 4) "%bin_Standard%" "%004%"
echo 5) "%bin_BattleEye%" "%005%"
echo 6) "%bin_Standard%" "%006%"
echo 7) "%bin_BattleEye%" "%007%"
echo 8) "%bin_Standard%" "%008%"
echo 9) "%bin_BattleEye%" "%009%"
echo 10) "%bin_Standard%" "%010%"
set "choicepath="
set /p "choicepath=Your choice: "
if defined choicepath (
if /I "%choicepath%"=="0" ( set "choice=00" && goto :Steam )
if /I "%choicepath%"=="1" ( set "choice=01" && goto :Steam )
if /I "%choicepath%"=="2" ( set "choice=02" && goto :Steam )
if /I "%choicepath%"=="3" ( set "choice=03" && goto :Steam )
if /I "%choicepath%"=="4" ( set "choice=04" && goto :Steam )
if /I "%choicepath%"=="5" ( set "choice=05" && goto :Steam )
if /I "%choicepath%"=="6" ( set "choice=06" && goto :Steam )
if /I "%choicepath%"=="7" ( set "choice=07" && goto :Steam )
if /I "%choicepath%"=="8" ( set "choice=08" && goto :Steam )
if /I "%choicepath%"=="9" ( set "choice=09" && goto :Steam )
if /I "%choicepath%"=="10" ( set "choice=10" && goto :Steam )
goto :launcher )
) else ( goto :launcher )
exit /b 0

:Steam
echo/
Set "SExe="
Set "SPth="
For /F "Tokens=1,2*" %%A In ('Reg Query HKCU\SOFTWARE\Valve\Steam') Do (
    If "%%A" Equ "SteamExe" Set "SExe=%%C"
    If "%%A" Equ "SteamPath" Set "SPth=%%C")
If Not Defined SExe Exit/B
Echo=The full path to the Steam executable is "%SExe%"
If Defined SPth Echo=The Steam folder path is "%SPth%"
echo/
tasklist | find /i "steam.exe"
echo/
if %errorlevel% EQU 0 ( echo Process "steam.exe" is running. && goto :%choice% )
if %errorlevel% EQU 1 ( echo Process "steam.exe" not running. Launching Steam && start "" /min "%SExe%" && goto :Steam )
exit /b 0

rem Incomplete
:00
start "" /min "steam://run/%appid%//+connect %sip%/%spwd%"
exit /b 0

:01
start "" /min "%BE%" "%001%"
exit /b 0

:02
start "" /min "%STD%" "%002%"
exit /b 0

:03
start "" /min "%BE%" "%003%"
exit /b 0

:04
start "" /min "%STD%" "%004%"
exit /b 0

:05
start "" /min "%BE%" "%005%"
exit /b 0

:06
start "" /min "%STD%" "%006%"
exit /b 0

:07
start "" /min "%BE%" "%007%"
exit /b 0
 
:08
start "" /min "%STD%" "%008%" 
exit /b 0

:09
start "" /min "%BE%" "%009%"
exit /b 0

:10
start "" /min "%STD%" "%010%"
exit /b 0

:serverlist
01;ServerName1;IP:Port;PW
02;ServerName2;IP:Port;PW
03;ServerName3;IP:Port;PW
04;ServerName4;IP:Port;PW
05;ServerName5;IP:Port;PW

:servermodlist_01
set "n=0"
set "strings="
for %%a in (
	"..\..\..\..\workshop\content\440900\0000\modfilename01.pak"
	"..\..\..\..\workshop\content\440900\0000\modfilename02.pak"
	"..\..\..\..\workshop\content\440900\0000\modfilename03.pak"
    ) do (
    set /A n+=1
    set "string[!n!]=%%~a"
    set "strings=!strings!/C:"%%~a" "
)
call :modlist
exit /b 0

:modlist
(
for /L %%i in (1,1,%n%) do echo !string[%%i]!
echo/
for /F "delims=" %%a in ('findstr /V /L %strings% "%servermodlist%"') do echo %%a
) > "%servermodlist%"
exit /b 0

::--------------------------::
::         DirList          ::
::--------------------------::
"1" "Program Files (x86)\Steam"
"2" "Steam"
"3" "Games"
"4" "SteamLibrary"
