@echo off

:DECRYPTCHROME
  call :inputbox "Please enter encryption password:" "Google Chrome"
  if "%input%"=="" (
    exit
  )

  echo Decrypting Google Chrome...
  rmdir "C:\Users\akr5321\AppData\Local\GoogleChromePortable\" /q /s
  mkdir "C:\Users\akr5321\AppData\Local\GoogleChromePortable\"
  "V:\Desktop\7zip\App\7-Zip\7z.exe" x -p%Input% -oC:\Users\akr5321\AppData\Local\GoogleChromePortable\ "V:\Desktop\7zip\chrome.7z"

:CHECKCHROME
  if exist "C:\Users\akr5321\AppData\Local\GoogleChromePortable\GoogleChromePortable.exe" (
    goto STARTCHROME
  ) else (
    goto DECRYPTCHROME
  )

:STARTCHROME
  echo Starting Google Chrome Portable...
  start /wait C:\Users\akr5321\AppData\Local\GoogleChromePortable\GoogleChromePortable.exe

:LOOP
  PSLIST chrome >nul 2>&1
  IF ERRORLEVEL 1 (
    GOTO ENCRYPTCHROME
  ) ELSE (
    echo Chrome is still running
    SLEEP 5
    GOTO LOOP
  )

:ENCRYPTCHROME
  rem CHANGE ENCRYPTION PASSWORD
  rem call :inputbox "Please enter the new encryption password:" "Google Chrome"

  echo Encrypting Google Chrome...
  del "V:\Desktop\7zip\chrome.7z"
  "V:\Desktop\7zip\App\7-Zip\7z.exe" a -sdel -r -p%Input% "V:\Desktop\7zip\chrome.7z" C:\Users\akr5321\AppData\Local\GoogleChromePortable\*

:FINISH
  rem @echo WScript.CreateObject("WScript.Shell").Popup "Encryption Complete! You can now log off.", 5 > %TEMP%\wait.vbs 
  rem wscript %TEMP%\wait.vbs
  shutdown -r -t 10 -c "Encryption complete, restarting
  rem shutdown -a
  exit

:InputBox
  set input=
  set heading=%~2
  set message=%~1
  echo wscript.echo inputbox(WScript.Arguments(0),WScript.Arguments(1)) >"%temp%\input.vbs"
  for /f "tokens=* delims=" %%a in ('cscript //nologo "%temp%\input.vbs" "%message%" "%heading%"') do set input=%%a

  REM SHA-512 Hash the password to protect password
  set salt=xaish4ADIz7YSr4nWBBLMv4h2ZHwMa
  set pepper=2dDlXlbWgZw4wb2QPRScTx1UewHzpe9Ba
  set cmd=""V:\Desktop\7zip\cmdhashgen\cmdhashgen.exe" /sha512 /s "%salt%%input%%pepper%" /b"
  FOR /F "tokens=*" %%i IN (' %cmd% ') DO SET input=%%i
  set cmd=
  set input=%input:~0,127%
  echo Hash: %input%

  goto:eof
