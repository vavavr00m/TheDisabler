@echo off

set "commons=steamapps\common\Conan Exiles"
set "specific=ConanSandbox\Content\Movies"
set ext=mp4 mov mkv m4p m4v webm flv f4v f4p f4a f4b vob ogv drc gifv mng avi mts m2ts ts qt wmv yuv rm rmvb viv asf amv mpg mp2 mpeg mpe mpv m2v svi 3gp 3g2 mxf roq nsv rv cpk dvr-ms wtv

set loc="E:\SteamLibrary\%commons%\%specific%" "D:\Games\%commons%\%specific%" "G:\Steam\%commons%\%specific%" "C:\Program Files (x86)\Steam\%commons%\%specific%"

echo\
for %%A in (%loc%) do (
	if exist "%%~A" ( echo Exists - "%%~A" && echo\ && if not exist "%%~A\bak" ( md "%%~A\bak" ) else ( 
			for %%B in (%%A\*) do if not exist "%%~A\%%~nB" ( echo Creating a blank file - %%~nB && break>"%%~A\%%~nB" ) else ( echo Exists - "%%~A\%%~nB" )
			for %%C in (%ext%) do if exist "%%~A\*.%%C" ( echo\ && echo Processing all %%C files in %%A && echo\ && dir "%%~A\*.%%C" && echo\ && echo Moving the following to "%%~A\bak" && @move "%%~A\*.%%C" "%%~A\bak" && echo\ ) else ( echo No file with %%C extension exists in "%%~A" )
		) 
	) else ( echo\ && echo Does not exist - "%%~A")
)
pause>nul
goto :replace_DefaultGame_ini
exit /b 0

:replace_DefaultGame_ini
echo\ && echo Setting the location..
set "specific=ConanSandbox\Config\DefaultGame.ini"
set loc="E:\SteamLibrary\%commons%\%specific%" "D:\Games\%commons%\%specific%" "G:\Steam\%commons%\%specific%" "C:\Program Files (x86)\Steam\%commons%\%specific%"

echo\
for %%A in (%loc%) do (
	if exist "%%~A" ( echo Exists - "%%~A" && start "" /wait /min powershell.exe -NoP -Ex -By -c "(Get-Content -Path '%%~A') | ForEach-Object { $_.Replace(';+StartupMovies=StartupUE4','').Replace(';+StartupMovies=StartupNvidia','').Replace(';+StartupMovies=CinematicIntroV2','').Replace(';-StartupMovies=StartupUE4','').Replace(';-StartupMovies=StartupNvidia','').Replace(';-StartupMovies=CinematicIntroV2','').Replace('; -StartupMovies=StartupUE4','').Replace('; -StartupMovies=StartupNvidia','').Replace('; -StartupMovies=CinematicIntroV2','').Replace('; +StartupMovies=StartupUE4','').Replace('; +StartupMovies=StartupNvidia','').Replace('; +StartupMovies=CinematicIntroV2','').Replace('+StartupMovies=StartupUE4','').Replace('+StartupMovies=StartupNvidia','').Replace('+StartupMovies=CinematicIntroV2','').Replace('-StartupMovies=StartupUE4','').Replace('-StartupMovies=StartupNvidia','').Replace('-StartupMovies=CinematicIntroV2','').Replace('bWaitForMoviesToComplete=True','bWaitForMoviesToComplete=False').Replace('bMoviesAreSkippable=False','bMoviesAreSkippable=True').Replace('-StartupMovies=','').Replace(';-StartupMovies=','').Replace('; -StartupMovies=','') } | Set-Content -Path '%%~A'" ) else ( echo Does not exist - "%%~A" )
)
pause>nul
exit /b 0
