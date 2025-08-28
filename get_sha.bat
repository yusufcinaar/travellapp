@echo off
echo SHA-1 ve SHA-256 parmak izlerini alıyor...
echo.
keytool -list -v -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" -storepass android -keypass android
pause
