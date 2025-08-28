# Seyahatname 

Firebase tabanlı seyahat uygulaması - Almanya, Avusturya ve İsviçre seyahatleri için geliştirilmiş modern Flutter uygulaması.

## Özellikler

- **Kimlik Doğrulama**: Email/şifre ve Google ile giriş
- **Modern UI**: Material Design 3 ile tasarlanmış kullanıcı dostu arayüz
- **Çoklu Dil Desteği**: Türkçe, İngilizce ve Almanca
- **Splash Screen**: Animasyonlu başlangıç ekranı
- **Gelişmiş Filtreleme**: Ülke, bölge, kategori ve tarih filtreleri
- **Görünüm Seçenekleri**: Liste ve ızgara görünümü
- **Favoriler**: Seyahatleri favorilere ekleme
- **Firebase Entegrasyonu**: Gerçek zamanlı veri senkronizasyonu

## Teknolojiler

- **Flutter** - Cross-platform mobil uygulama geliştirme
- **Firebase Auth** - Kullanıcı kimlik doğrulama
- **Cloud Firestore** - NoSQL veritabanı
- **Provider** - State management
- **Material Design 3** - Modern UI tasarımı

## Ekran Görüntüleri

### Splash Screen
- Animasyonlu logo ve şehir silueti
- Gradient mavi arka plan

### Login Screen  
- Email/şifre girişi
- Google ile giriş
- Kayıt olma özelliği
- Çoklu dil desteği

### Home Screen
- Seyahat listesi/ızgara görünümü
- Gelişmiş filtreleme
- Arama özelliği

## Kurulum

1. **Projeyi klonlayın**
   ```bash
   git clone https://github.com/[kullanici-adi]/seyahatname.git
   cd seyahatname
   ```

2. **Bağımlılıkları yükleyin**
   ```bash
   flutter pub get
   ```

3. **Firebase yapılandırması**
   - Firebase Console'da yeni proje oluşturun
   - Android/iOS uygulamaları ekleyin
   - `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ekleyin

4. **Uygulamayı çalıştırın**
   ```bash
   flutter run
   ```

## Proje Yapısı

```
lib/
├── config/          # Tema ve yapılandırma
├── models/          # Veri modelleri
├── providers/       # State management
├── screens/         # Uygulama ekranları
├── services/        # Firebase servisleri
├── widgets/         # Yeniden kullanılabilir widget'lar
└── main.dart        # Ana uygulama dosyası
```

## Desteklenen Diller

- Türkçe
- İngilizce  
- Almanca

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## İletişim

Proje hakkında sorularınız için issue açabilirsiniz.
