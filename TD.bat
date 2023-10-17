@echo off
set drive_letter=c d e f g h i j k l m n o p q r s t u v w x y z
set "title=Conan Exiles"
set "commons=steamapps\common\Conan Exiles"
set ext=mp4 mov mkv m4p m4v webm flv f4v f4p f4a f4b vob ogv drc gifv mng avi mts m2ts ts qt wmv yuv rm rmvb viv asf amv mpg mp2 mpeg mpe mpv m2v svi 3gp 3g2 mxf roq nsv rv cpk dvr-ms wtv
set NEWLINE=^& echo.
set "specific=ConanSandbox\Content\Movies"
set "ini=ConanSandbox\Config\DefaultGame.ini"
set "gameini=ConanSandbox\Saved\Config\WindowsNoEditor\Game.ini"
set gameinilist=[/Script/MoviePlayer.MoviePlayerSettings],bWaitForMoviesToComplete=False,StartupMovies=
goto :process

:process
echo.

setlocal enabledelayedexpansion
for %%A in (%drive_letter%) do if exist "%%A:\" (
	echo Existing drive found - %%A:\ - Searching for %title% directory
	for /f usebackq^tokens^=1-3*delims^=^" %%i in =;(
		`type "%~f0" ^| findstr /b \^"`
			);= do set "movies=%%A:\%%~k\%commons%\%specific%" && set "defaultgameini=%%A:\%%~k\%commons%\%ini%" && set "gameini=%%A:\%%~k\%commons%\%gameini%"
				
				if exist "!movies!" ( echo\ && echo Found - "!movies!"
					if exist "!movies!\bak" (
					echo\
					for %%B in ("!movies!\*") do if not exist "!movies!\%%~nB" ( echo Creating a blank file - %%~nB && break>"!movies!\%%~nB" ) else ( echo Exists - "!movies!\%%~nB" )
					echo\
					for %%C in (%ext%) do if exist "!movies!\*.%%C" ( echo Processing all %%C files in "!movies!\" && echo\ && dir "!movies!\*.%%C" && echo\ & echo\ && echo Moving the following to "!movies!\bak": && echo\ && @move "!movies!\*.%%C" "!movies!\bak" && echo\ ) else ( echo No file with %%C extension exists in "!movies!\" )
					echo\
				) else ( md "!movies!\bak" && goto :process )
				
				echo Searching for DefaultGame.ini to delete lines
				if exist "!defaultgameini!" ( echo Found - "!defaultgameini!" && echo\ && start "" /wait /min powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "(Get-Content -Path '!defaultgameini!') | ForEach-Object { $_.Replace(';+StartupMovies=StartupUE4','').Replace(';+StartupMovies=StartupNvidia','').Replace(';+StartupMovies=CinematicIntroV2','').Replace(';-StartupMovies=StartupUE4','').Replace(';-StartupMovies=StartupNvidia','').Replace(';-StartupMovies=CinematicIntroV2','').Replace('; -StartupMovies=StartupUE4','').Replace('; -StartupMovies=StartupNvidia','').Replace('; -StartupMovies=CinematicIntroV2','').Replace('; +StartupMovies=StartupUE4','').Replace('; +StartupMovies=StartupNvidia','').Replace('; +StartupMovies=CinematicIntroV2','').Replace('+StartupMovies=StartupUE4','').Replace('+StartupMovies=StartupNvidia','').Replace('+StartupMovies=CinematicIntroV2','').Replace('-StartupMovies=StartupUE4','').Replace('-StartupMovies=StartupNvidia','').Replace('-StartupMovies=CinematicIntroV2','').Replace('bWaitForMoviesToComplete=True','bWaitForMoviesToComplete=False').Replace('bMoviesAreSkippable=False','bMoviesAreSkippable=True').Replace('-StartupMovies=','').Replace(';-StartupMovies=','').Replace('; -StartupMovies=','') } | Set-Content -Path '!defaultgameini!'" 
				) else ( echo Does not exist - "!defaultgameini!" )
				
				echo Searching for Game.ini to add lines
				rem chcp 65001 > nul converts encoding of ini to UTF-8
				if exist "!gameini!" ( echo Found - "!gameini!" && start "" /wait /min powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "(Get-ChildItem -Path '!gameini!' | ForEach-Object { (Get-Content $_) | Out-File -Encoding ascii $_ })"

					rem Define the strings that needs to be reviewed
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
					
					rem Get the line number of the first line of "existing content"
					set "skip="
					for /F "tokens=1* delims=:" %%a in ('findstr /N /V /L %strings% "!gameini!"') do (
					   if not defined skip if "%%b" neq "" set /A "skip=%%a-1"
					)
					if defined skip (
					   if "%skip%" neq "0" (
					      set "skip=skip=%skip%"
					   ) else (
					      set "skip="
					   )
					)
					
					rem Insert the strings at beginning of output file
					(
					for /L %%i in (1,1,%n%) do echo !string[%%i]!
					echo/
					for /F "%skip% delims=" %%a in (!gameini!) do echo %%a
					) > output.txt
					
					rem Last step: update input file
					move /Y output.txt "!gameini!"

				) else ( echo Does not exist - "!gameini!" && echo\ )
				
	) else ( echo Nonexistent - "!movies!" )
) else ( echo Nonexistent drive - %%A:\ )
endlocal

echo\ && echo The End.
pause>nul
exit /b 0

::--------------------------::
::         DirList          ::
::--------------------------::
"1" "Program Files (x86)\Steam"
"2" "Steam"
"3" "Games"
"4" "SteamLibrary"
