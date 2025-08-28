# Google Sign-In Sorun Giderme Rehberi

## Sorun
Google Sign-In özelliği çalışmıyor ve muhtemelen `ApiException: 10` hatası alınıyor.

## Ana Sebepler
1. SHA-1 ve SHA-256 parmak izlerinin (fingerprints) Firebase projesine eklenmemiş olması
2. `google-services.json` dosyasının güncel olmaması
3. Google Cloud Console'da OAuth izinlerinin yapılandırılmamış olması

## Çözüm Adımları

### 1. SHA Anahtarlarını Alma
Debug sürümü için SHA anahtarlarını almak için:

```
keytool -list -v -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" -storepass android -keypass android
```

### 2. Firebase Console'a SHA Anahtarı Ekleme
1. Firebase Console'a gidin: https://console.firebase.google.com/
2. Projenizi seçin: "seyahatname-c3d44"
3. Sol menüden "Project settings" (⚙️ ikonu) tıklayın
4. "General" sekmesinde aşağıya kaydırın ve "Your apps" kısmında Android uygulamanızı bulun
5. "SHA certificate fingerprints" bölümünde "Add fingerprint" butonuna tıklayın
6. Keytool'dan aldığınız SHA-1 ve SHA-256 değerlerini ekleyin

### 3. google-services.json Dosyasını Güncelleme
SHA anahtarlarını ekledikten sonra:
1. Firebase Console'da "Project settings" > "Your apps" bölümünde Android uygulamanızı bulun
2. "google-services.json" indir butonuna tıklayın
3. İndirdiğiniz dosyayı `android/app/` klasörüne kopyalayıp mevcut dosyanın üzerine yazın

### 4. Alternatif Çözüm: SHA Değerini Direkt Eklemek
Eğer hala sorun yaşıyorsanız, `google-services.json` dosyasına SHA değerini manuel ekleyebilirsiniz:

```json
"oauth_client": [
  {
    "client_id": "MEVCUT_CLIENT_ID",
    "client_type": 1,
    "android_info": {
      "package_name": "com.example.seyahatname",
      "certificate_hash": "BURAYA_SHA1_DEĞERINIZI_EKLEYIN"
    }
  },
  ...
]
```

### 5. Email/Şifre ile Giriş Kullanma
Google Sign-In sorununuz çözülene kadar email/şifre ile giriş yaparak uygulamayı kullanmaya devam edebilirsiniz.

## Google Sign-In Bağımlılıkları Kontrolü

`pubspec.yaml` dosyasında aşağıdaki bağımlılıkların olduğundan emin olun:
```yaml
dependencies:
  google_sign_in: ^6.2.1
  firebase_auth: ^5.3.1
```

## Unutmayın
SHA anahtarları, uygulamanızı geliştirdiğiniz bilgisayara özgüdür. Farklı bir bilgisayarda geliştirme yapacaksanız, o bilgisayarın SHA anahtarlarını da Firebase projenize eklemeniz gerekecektir.
