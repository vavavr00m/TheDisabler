@echo off

set drive_letter=c d e f g h i j k l m n o p q r s t u v w x y z
set "title=Conan Exiles"
set "commons=steamapps\common\Conan Exiles"
set ext=mp4 mov mkv m4p m4v webm flv f4v f4p f4a f4b vob ogv drc gifv mng avi mts m2ts ts qt wmv yuv rm rmvb viv asf amv mpg mp2 mpeg mpe mpv m2v svi 3gp 3g2 mxf roq nsv rv cpk dvr-ms wtv

set "specific=ConanSandbox\Content\Movies"
set "ini=ConanSandbox\Config\DefaultGame.ini"
goto :process

:process
echo.

for %%A in (%drive_letter%) do if exist "%%A:\" (
	echo Existing drive found - %%A:\ - Searching for %title% directory
	for /f usebackq^tokens^=1-3*delims^=^" %%i in =;(
		`type "%~f0" ^| findstr /b \^"`
			);= do if exist "%%A:\%%~k\%commons%\%specific%" ( echo\ && echo Found - "%%A:\%%~k\%commons%\%specific%"
				if exist "%%A:\%%~k\%commons%\%specific%\bak" (
					echo\
					for %%B in ("%%A:\%%~k\%commons%\%specific%\*") do if not exist "%%A:\%%~k\%commons%\%specific%\%%~nB" ( echo Creating a blank file - %%~nB && break>"%%A:\%%~k\%commons%\%specific%\%%~nB" ) else ( echo Exists - "%%A:\%%~k\%commons%\%specific%\%%~nB" )
					echo\
					for %%C in (%ext%) do if exist "%%A:\%%~k\%commons%\%specific%\*.%%C" ( echo Processing all %%C files in "%%A:\%%~k\%commons%\%specific%" && echo\ && dir "%%A:\%%~k\%commons%\%specific%\*.%%C" && echo\ & echo\ && echo Moving the following to "%%A:\%%~k\%commons%\%specific%\bak": && echo\ && @move "%%A:\%%~k\%commons%\%specific%\*.%%C" "%%A:\%%~k\%commons%\%specific%\bak" && echo\ ) else ( echo No file with %%C extension exists in "%%A:\%%~k\%commons%\%specific%" )
				echo\
				) else ( md "%%A:\%%~k\%commons%\%specific%\bak" && goto :process )
				echo Looking for DefaultGame.ini to delete lines
				if exist "%%A:\%%~k\%commons%\%ini%" ( echo Found - "%%A:\%%~k\%commons%\%ini%" && echo\ && start "" /wait /min powershell.exe -NoP -Ex -By -c "(Get-Content -Path '%%A:\%%~k\%commons%\%ini%') | ForEach-Object { $_.Replace(';+StartupMovies=StartupUE4','').Replace(';+StartupMovies=StartupNvidia','').Replace(';+StartupMovies=CinematicIntroV2','').Replace(';-StartupMovies=StartupUE4','').Replace(';-StartupMovies=StartupNvidia','').Replace(';-StartupMovies=CinematicIntroV2','').Replace('; -StartupMovies=StartupUE4','').Replace('; -StartupMovies=StartupNvidia','').Replace('; -StartupMovies=CinematicIntroV2','').Replace('; +StartupMovies=StartupUE4','').Replace('; +StartupMovies=StartupNvidia','').Replace('; +StartupMovies=CinematicIntroV2','').Replace('+StartupMovies=StartupUE4','').Replace('+StartupMovies=StartupNvidia','').Replace('+StartupMovies=CinematicIntroV2','').Replace('-StartupMovies=StartupUE4','').Replace('-StartupMovies=StartupNvidia','').Replace('-StartupMovies=CinematicIntroV2','').Replace('bWaitForMoviesToComplete=True','bWaitForMoviesToComplete=False').Replace('bMoviesAreSkippable=False','bMoviesAreSkippable=True').Replace('-StartupMovies=','').Replace(';-StartupMovies=','').Replace('; -StartupMovies=','') } | Set-Content -Path '%%A:\%%~k\%commons%\%ini%'" 
				) else ( echo Does not exist - "%%A:\%%~k\%commons%\%ini%" )
		) else ( echo Nonexistent - "%%A:\%%~k\%commons%\%specific%" )
) else ( echo Nonexistent drive - %%A:\ )
echo\ && echo The End.
pause>nul
exit /b 0

::-------------------------------::
::         Your listing          ::
::-------------------------------::
"1" "Program Files (x86)\Steam"
"2" "Steam"
"3" "Games"
"4" "SteamLibrary"
