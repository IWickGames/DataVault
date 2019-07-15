@echo off
title Data Vault
if exist changedir.dat goto updatedir
if not exist C:\DataVaultUsers mkdir C:\DataVaultUsers
set userdir=C:\DataVaultUsers
goto start

:updatedir
set /p userdir=<changedir.dat
if not exist "%userdir%" goto erroruserdir
goto start

:erroruserdir
cls
echo.
echo.
echo.
echo Could not start as the Update user dir in changedir.dat does not exist
echo Dir: %userdir%
timeout /nobreak 5 >nul
exit

:start
cls
echo.
echo.
echo.
echo.
echo      Folder Vault
echo ======================
echo.
echo [1] Login
echo [2] Create a new account
echo.
set /p enter="Select One>"
if %enter%==1 goto login
if %enter%==2 goto newuser
echo.
echo Error: %enter% is not a option please select from one of the above options
timeout /nobreak 5 >nul
goto start

:login
cls
echo.
echo.
echo.
echo.
echo      Login to a account
echo ============================
echo.
set /p usern="Username>"
set /p passwd="Password>"
if not exist "%userdir%\%usern%" goto usernotexist
plugins\7za.exe x "%userdir%\%usern%\%usern%.zip" -p"%passwd%" -o"%userdir%\%usern%\"
move "%userdir%\%usern%\%usern%\passwd.login" "%userdir%\%usern%"
move "%userdir%\%usern%\%usern%\Data" "%userdir%\%usern%"
rd /s /q "%userdir%\%usern%\%usern%"
if not exist "%userdir%\%usern%\passwd.login" goto badpassword
set /p checkpasswd=<"%userdir%\%usern%\passwd.login"
if "%checkpasswd%"=="%passwd%" goto login2
goto badpassword
:login2
del /s /q "%userdir%\%usern%\%usern%.zip"
start "" "%userdir%\%usern%\Data"
goto logindone

:badpassword
cls
echo.
echo.
echo.
echo.
echo Error: The password you have entered was denied by the Arcive Extractor. (Bad password)
timeout /nobreak 5 >nul
del /s /q "%userdir%\%usern%\passwd.login"
rd /s /q "%userdir%\%usern%\Data"
goto start

:usernotexist
cls
echo.
echo.
echo.
echo.
echo Error: %usern% is not a user! Please try again.
timeout /nobreak 5 >nul
goto login


:newuser
cls
echo.
echo.
echo.
echo.
echo       Create a new user
echo =============================
echo.
set /p usern="Username>"
set /p passwd="Password>"
if exist "%userdir%\%usern%" goto alreadyauser
mkdir "%userdir%\%usern%"
mkdir "%userdir%\%usern%\Data"
echo %passwd%> "%userdir%\%usern%\passwd.login"
goto logindone

:alreadyauser
echo.
echo.
echo Error: %usern% is already a user! Please try again!
timeout /nobreak 5 >nul
goto newuser


:logindone
cls
echo.
echo.
echo.
echo.
echo      Welcome back %usern%
echo ==============================
echo.
echo    What do you want to do?
echo.
echo [1] Change my Vault Password
echo [2] Remove my account
echo [3] Logout
echo.
set /p enter="Select One>"
if %enter%==1 goto changepassword
if %enter%==2 goto delaccount
if %enter%==3 goto lockcurrentuser
echo.
echo.
echo Error: %enter% is not a option! Please try again.
timeout /nobreak 5 >nul
goto logindone

:changepassword
cls
echo.
echo.
echo.
echo.
echo      Change password for %usern%
echo =====================================
echo.
echo    Please enter your new password
echo.
echo.
set /p passwd="New Password>"
echo %passwd%> "%userdir%\%usern%\passwd.login"
echo.
echo Your password was updated, logging out...
timeout /nobreak 3 >nul
goto lockcurrentuser

:delaccount
echo.
echo.
echo.
echo Are you sure? This action cannot be undone!
echo.
set /p enter="[Y/N] "
if %enter%==Y goto delaccount2
if %enter%==N goto logindone
echo.
echo.
echo Error: That is not a option please type Y or N for Yes or No!
timeout /nobreak 5 >nul
goto delaccount
:delaccount2
echo.
echo.
echo.
echo Removing account %usern%...
rd /s /q "%userdir%\%usern%"
echo.
echo Account was removed!
timeout /nobreak 3 >nul
goto start


:lockcurrentuser
plugins\7za.exe a -p"%passwd%" -o"%userdir%\%usern%" -r "%userdir%\%usern%\%usern%.zip" "%userdir%\%usern%\"
rd /s /q "%userdir%\%usern%\Data"
del /s /q "%userdir%\%usern%\passwd.login"
goto start