# eGündem - Flutter News Application

Modern bir haber uygulaması. Flutter ve Riverpod ile geliştirilmiştir.

## İçindekiler

- [Özellikler](#özellikler)
- [Proje Yapısı](#proje-yapısı)
- [Gereksinimler](#gereksinimler)
- [Kurulum](#kurulum)
- [Çalıştırma](#çalıştırma)
- [Testler](#testler)
- [Kod Üretimi](#kod-üretimi)
- [Mimari](#mimari)
- [Teknolojiler](#teknolojiler)

## Ekran Kaydı

https://drive.google.com/file/d/1HKxOPKclBL1663AssUc3LN8go9FkQunC/view?usp=sharing

## Özellikler

- **Kimlik Doğrulama**: Kullanıcı kaydı ve girişi
- **Haberler**: Kategorilere göre haberler, popüler haberler
- **Kaynak Yönetimi**: Haber kaynaklarını takip etme
- **Twitter Entegrasyonu**: Twitter feed'i görüntüleme
- **Yerel Depolama**: Token ve cache yönetimi
- **Modern UI**: Dark mode, responsive tasarım

## Proje Yapısı

```
lib/
├── core/                          # Çekirdek modüller
│   ├── cache/                     # Cache yönetimi
│   │   └── popular_news_cache.dart
│   ├── constants/                 # Sabitler
│   │   └── app_constants.dart
│   ├── di/                        # Dependency Injection (Riverpod Providers)
│   │   ├── app_providers.dart
│   │   ├── cache_providers.dart
│   │   ├── env_providers.dart
│   │   ├── logging_providers.dart
│   │   ├── network_providers.dart
│   │   └── storage_providers.dart
│   ├── network/                   # Network katmanı
│   │   ├── api_client.dart
│   │   └── endpoints.dart
│   ├── storage/                    # Yerel depolama
│   │   └── token_storage.dart
│   └── widgets/                   # Ortak widget'lar
│       ├── button.dart
│       └── input.dart
│
├── features/                      # Özellik modülleri
│   ├── auth/                      # Kimlik doğrulama
│   │   ├── data/
│   │   │   ├── dto/
│   │   │   └── repositories/
│   │   ├── di/
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   └── screens/
│   │   └── states/
│   │
│   ├── home/                      # Ana ekran
│   │   ├── data/
│   │   │   └── models/
│   │   ├── di/
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   └── screens/
│   │   └── states/
│   │
│   ├── category_news/             # Kategori haberleri
│   │   ├── data/
│   │   │   └── models/
│   │   ├── di/
│   │   └── presentation/
│   │       ├── controllers/
│   │       └── pages/
│   │
│   ├── sources/                    # Haber kaynakları
│   │   ├── data/
│   │   │   └── models/
│   │   ├── di/
│   │   ├── presentation/
│   │   │   ├── controllers/
│   │   │   └── screens/
│   │   └── states/
│   │
│   └── twitter/                    # Twitter entegrasyonu
│       ├── data/
│       │   └── models/
│       ├── di/
│       └── presentation/
│           ├── controllers/
│           └── screens/
│
├── main.dart                       # Uygulama giriş noktası
└── routes.dart                     # Route yönetimi

test/                               # Test dosyaları
├── core/                           # Core modül testleri
├── features/                       # Feature testleri
├── main_test.dart
└── routes_test.dart
```

## Gereksinimler

- Flutter SDK: ^3.7.2
- Dart SDK: ^3.7.2
- Android Studio / VS Code
- iOS Simulator / Android Emulator veya fiziksel cihaz

## Kurulum

1. **Projeyi klonlayın:**
   ```bash
   git clone <repository-url>
   cd mytech_egundem_case
   ```

2. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Environment dosyası oluşturun:**
   Proje kök dizininde `.env` dosyası oluşturun:
   ```env
   BASE_URL=https://api.example.com
   ENV=dev
   XAPIKEY=your-api-key-here
   ```

4. **Kod üretimini çalıştırın:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Çalıştırma

### Development Mode

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Belirli bir cihaz
flutter devices                    # Mevcut cihazları listele
flutter run -d <device-id>         # Belirli cihazda çalıştır
```

### Release Mode

```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
flutter build appbundle --release
```

### Watch Mode (Kod üretimi için)

Kod değişikliklerini otomatik olarak izler ve gerekli dosyaları yeniden oluşturur:

```bash
flutter pub run build_runner watch
```

## 🧪 Testler

### Tüm Testleri Çalıştırma

```bash
# Tüm testler
flutter test

# Belirli bir test dosyası
flutter test test/features/auth/auth_controller_test.dart

# Belirli bir test grubu
flutter test --plain-name "AuthController"

# Coverage raporu ile
flutter test --coverage
```

### Test Kategorileri

Projede şu test kategorileri bulunmaktadır:

1. **Unit Testler:**
   - Core modüller (ApiClient, TokenStorage, PopularNewsCache)
   - Repository'ler
   - Controller'lar
   - State'ler

2. **Widget Testleri:**
   - Custom widget'lar (EgundemButton, EgundemInput)

3. **Integration Testleri:**
   - Route testleri
   - Main app testleri

### Test Yapısı

```
test/
├── core/                           # Core modül testleri
│   ├── cache/
│   ├── network/
│   ├── storage/
│   └── widgets/
│
└── features/                       # Feature testleri
    ├── auth/
    │   ├── data/
    │   ├── presentation/
    │   └── states/
    ├── home/
    ├── category_news/
    ├── sources/
    └── twitter/
```

### Test Örnekleri

```bash
# Sadece core testleri
flutter test test/core/

# Sadece auth feature testleri
flutter test test/features/auth/

# Sadece widget testleri
flutter test test/core/widgets/
```

## Kod Üretimi

Bu proje **Riverpod Generator** kullanmaktadır. Provider'lar `@riverpod` annotation ile tanımlanır ve otomatik olarak kod üretilir.

### Yeni Provider Ekleme

1. Provider dosyasında `@riverpod` annotation kullanın:
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';
   
   part 'example_providers.g.dart';
   
   @riverpod
   MyService myService(Ref ref) {
     return MyService();
   }
   ```

2. Kod üretimini çalıştırın:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Generated dosya (`example_providers.g.dart`) otomatik oluşturulur.

### Watch Mode

Kod değişikliklerini otomatik izlemek için:

```bash
flutter pub run build_runner watch
```

## Mimari

Proje **Clean Architecture** prensiplerine uygun olarak geliştirilmiştir:

### Katmanlar

1. **Presentation Layer:**
   - Screens/Pages
   - Controllers (Riverpod Notifiers)
   - States

2. **Data Layer:**
   - Repositories
   - Models/DTOs
   - Data Sources (API)

3. **Domain Layer:**
   - Business Logic
   - Entities

4. **Core Layer:**
   - Network
   - Storage
   - Cache
   - Widgets

### State Management

- **Riverpod 3.0** kullanılmaktadır
- **Riverpod Generator** ile code generation
- **NotifierProvider** ve **AsyncNotifierProvider** kullanımı

### Dependency Injection

- **Riverpod** ile DI
- Provider'lar `@riverpod` annotation ile tanımlanır
- Code generation ile otomatik provider oluşturma

## 🛠️ Teknolojiler

### Core Dependencies

- **flutter_riverpod**: ^3.0.3 - State management
- **riverpod_annotation**: ^3.0.3 - Code generation annotations
- **dio**: ^5.8.0+1 - HTTP client
- **flutter_dotenv**: ^6.0.0 - Environment variables
- **shared_preferences**: ^2.5.2 - Local storage
- **infinite_scroll_pagination**: ^5.1.1 - Pagination
- **loggy**: ^2.0.3 - Logging

### Development Dependencies

- **build_runner**: ^2.4.9 - Code generation
- **riverpod_generator**: ^3.0.3 - Riverpod code generation
- **riverpod_lint**: ^3.0.3 - Linting rules
- **custom_lint**: ^0.8.0 - Custom linting
- **mocktail**: ^1.0.4 - Mocking for tests
- **faker**: ^2.2.0 - Test data generation

## Önemli Notlar

### Environment Variables

Uygulama çalışmadan önce `.env` dosyasının oluşturulması gerekmektedir:

```env
BASE_URL=https://api.example.com
ENV=dev
XAPIKEY=your-api-key
```

### Code Generation

Provider dosyalarında değişiklik yaptıktan sonra mutlaka build_runner çalıştırın:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting

Proje `riverpod_lint` ve `custom_lint` kullanmaktadır. Lint hatalarını kontrol etmek için:

```bash
flutter analyze
```

## Ek Kaynaklar

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Riverpod Generator](https://riverpod.dev/docs/concepts/about_code_generation)

## Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add some amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## Lisans

Bu proje özel bir projedir.

---

**Not:** Bu README dosyası projenin mevcut durumunu yansıtmaktadır. Güncellemeler için lütfen proje geliştiricileriyle iletişime geçin.
