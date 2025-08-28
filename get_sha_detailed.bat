@echo off
echo ========================================
echo SHA-1 ve SHA-256 Parmak Izleri Aliniyor
echo ========================================
echo.

echo 1. Gradle ile SHA alma...
cd /d "%~dp0android"
call gradlew signingReport
echo.

echo 2. Keytool ile SHA alma...
keytool -list -v -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" -storepass android -keypass android
echo.

echo ========================================
echo Yukaridaki SHA-1 ve SHA-256 degerlerini
echo Firebase Console'a ekleyin!
echo ========================================
pause
