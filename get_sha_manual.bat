@echo off
echo SHA-1 Fingerprint Manuel Alma
echo ================================
echo.

echo Android Studio'da Terminal acin ve su komutlari calistirin:
echo.
echo 1. cd android
echo 2. gradlew signingReport
echo.
echo Alternatif olarak:
echo.
echo keytool -list -v -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" -storepass android -keypass android
echo.
echo SHA1 degerini kopyalayin ve Firebase Console'da:
echo Project Settings ^> Your apps ^> Android app ^> SHA certificate fingerprints
echo Add fingerprint butonuna tiklayin ve SHA1 degerini yapiştirin.
echo.
pause
