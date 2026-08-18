@echo off
net session >nul 2>&1
if %errorlevel%==0 exit /b 0
if not exist "%~f1" exit /b 1
set "JS=%TEMP%\gbzap_uac_%RANDOM%%RANDOM%.js"
 >"%JS%" echo var sh=new ActiveXObject("Shell.Application");
>>"%JS%" echo sh.ShellExecute(WScript.Arguments(0),"",WScript.Arguments(1),"runas",1);
if exist "%JS%" (
  wscript //nologo //E:JScript "%JS%" "%~f1" "%~dp1" >nul 2>&1
  del "%JS%" >nul 2>&1
  exit
)
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%PS%" set "PS=%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
if exist "%PS%" (
  "%PS%" -NoLogo -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Start-Process -LiteralPath '%~f1' -WorkingDirectory '%~dp1' -Verb RunAs" >nul 2>&1
  exit
)
echo.
echo  Запустите файл от имени администратора:
echo  ПКМ по bat -^> "Запуск от имени администратора"
echo.
pause
exit
