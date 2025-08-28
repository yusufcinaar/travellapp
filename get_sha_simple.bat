@echo off
echo SHA-1 Parmak Izi Aliniyor...
echo.

echo Yontem 1: Flutter ile...
flutter doctor -v | findstr "SHA1"

echo.
echo Yontem 2: Android Studio ile...
echo Android Studio'yu acin ve Terminal'de:
echo cd android
echo gradlew signingReport

echo.
echo Yontem 3: Manuel keystore kontrolu...
echo %USERPROFILE%\.android\debug.keystore dosyasi var mi kontrol ediliyor...
if exist "%USERPROFILE%\.android\debug.keystore" (
    echo Debug keystore bulundu!
    echo Keytool ile SHA alma...
    keytool -list -v -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" -storepass android -keypass android 2>nul
) else (
    echo Debug keystore bulunamadi!
    echo Flutter projesi bir kez calistirilmali.
)

echo.
echo Eger hala SHA alamazsaniz, Firebase'de SHA olmadan da devam edebilirsiniz.
echo Sadece package name ile uygulama ekleyin: com.example.seyahatname
pause
