@echo off
setlocal enabledelayedexpansion

rem Define search_paths as a single line with multiple paths using a double pipe (||) as the delimiter
set "search_paths=\Path with Spaces\Location1||\Another Location\Location2||\Location with & Special [Characters]"

rem Strings to be added to the INI file (use | as a delimiter)
set "strings_to_add=String1|String with spaces|String[with]brackets|String.with.periods|LastString"

rem Subroutine for displaying error message
:DisplayError
echo ERROR: %1
goto :eof

rem Loop through each drive (C to Z)
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    
    rem Set the current drive being processed
    set "drive=%%D:"
    if not exist "!drive!" (
        call :DisplayError "Drive not found: %%D"
        goto :ContinueWithNextDrive
    )
    
    rem Loop through each search path by splitting using the double pipe (||) delimiter
    for %%P in (!search_paths!) do (
        for /f "tokens=1,* delims=||" %%A in ("%%P") do (
            set "search_path=%%~A"
            
            rem Check if the search path exists
            if not exist "!drive!!search_path!" (
                call :DisplayError "Path not found: !drive!!search_path!"
                goto :ContinueWithNextSearchPath
            )

            rem Loop through the INI files
            for /r "!drive!!search_path!" %%F in (*.ini) do (
                rem Check if the file exists
                if not exist "%%F" (
                    call :DisplayError "INI file not found: %%F"
                    goto :ContinueWithNextINI
                )

                rem Check for BOM and convert if BOM-encoded using PowerShell
                powershell -command "& {
                    $fileContent = Get-Content '%%F' -Encoding utf8
                    if ($fileContent.StartsWith([Text.Encoding]::UTF8.GetPreamble())) {
                        $fileContent = $fileContent -replace '^\xEF\xBB\xBF', ''
                        [System.IO.File]::WriteAllText('%%F', $fileContent)
                        Write-Host 'BOM detected and removed from "%%F"'
                    }
                }"

                rem Add strings to the INI file using PowerShell
                powershell -command "& {
                    $iniFile = '%%F'
                    $stringsToAdd = '%strings_to_add%'
                    $newContent = [System.IO.File]::ReadAllText($iniFile) -replace "`r`n", "`n"
                    $newContent += "`r`n" + $stringsToAdd
                    [System.IO.File]::WriteAllText($iniFile, $newContent)
                }"

                echo Strings added to the INI file
            )
        )
    )
)

:ContinueWithNextINI
:ContinueWithNextSearchPath
:ContinueWithNextDrive

endlocal
