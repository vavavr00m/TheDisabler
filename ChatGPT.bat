@echo off
setlocal enabledelayedexpansion

rem Define search_paths as a single line with multiple paths using a double pipe (||) as the delimiter
set "search_paths=\Path with Spaces\Location1||\Another Location\Location2||\Location with & Special [Characters]"

rem Strings to be added to the INI file (use | as a delimiter)
set "strings_to_add=String1|String with spaces|String[with]brackets|String.with.periods"

rem Loop through each drive (C to Z)
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    
    rem Set the current drive being processed
    set "drive=%%D:"
    if exist "!drive!" (
        
        rem Loop through each search path by splitting using the double pipe (||) delimiter
        for %%P in (!search_paths!) do (
            for /f "tokens=1,* delims=||" %%A in ("%%P") do (
                set "search_path=%%~A"
                if exist "!drive!!search_path!\*.ini" (
                    echo Found INI files in !drive!!search_path!
                    
                    rem Loop through the INI files
                    for /r "!drive!!search_path!" %%F in (*.ini) do (
                        echo Found INI file: "%%~F"
                        
                        rem Check for BOM and convert if BOM-encoded using PowerShell
                        powershell -command "& {
                            $fileContent = Get-Content '%%~F' -Encoding utf8
                            if ($fileContent.StartsWith([Text.Encoding]::UTF8.GetPreamble())) {
                                $fileContent = $fileContent -replace '^\xEF\xBB\xBF', ''
                                [System.IO.File]::WriteAllText('%%~F', $fileContent)
                                Write-Host 'BOM detected and removed from "%%~F"'
                            }
                        }"
                        
                        rem Add your processing code here for INI files
                        
                        rem Add strings to the INI file using PowerShell
                        for %%S in (%strings_to_add%) do (
                            powershell -command "& {
                                Add-Content '%%~F' ('[SectionName]', '%%S=%%S') -Encoding utf8
                            }"
                        )
                        echo Strings added to the INI file: %strings_to_add%
                    )
                )
            )
        )
    )
)

endlocal
