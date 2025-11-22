@echo off
REM Batch script to update requirements.txt
REM Run this periodically: update_requirements.bat

echo Updating requirements.txt...

call venv\Scripts\activate.bat
python update_requirements.py

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Requirements update complete!
) else (
    echo.
    echo Error updating requirements.
)

pause

