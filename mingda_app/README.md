# Flutter Clean Architecture — BLoC

> Aplikasi Flutter yang dibangun dengan **Clean Architecture** dan **BLoC Pattern** untuk memastikan skalabilitas, testabilitas, dan konsistensi kolaborasi tim.
>
> *Work in progress — Mingda Absensi.*

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![BLoC](https://img.shields.io/badge/BLoC-Pattern-orange)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-green)

---

## Struktur Folder

```
lib/
├── app/
│   └── config/                    # Konfigurasi global aplikasi
│       ├── app_config.dart        # Environment config (dev/staging/prod)
│       ├── routes/                # Definisi routing aplikasi
│       └── app.dart               # Root widget & MaterialApp
│
├── core/                          # Komponen reusable lintas fitur
│   ├── constants/                 # Konstanta global (API URL, keys, dll)
│   ├── di/                        # Dependency Injection (GetIt setup)
│   ├── errors/                    # Definisi Failure & Exception
│   ├── theme/                     # ThemeData, warna, typography
│   └── utils/                     # Helper, extension, formatter
│
└── features/                      # Modul fitur yang berdiri sendiri
    └── auth/                      # Contoh: Fitur autentikasi
        ├── data/                  # Layer Data
        │   ├── datasources/       # Remote & Local data source
        │   ├── models/            # Data Transfer Object (DTO/Model)
        │   └── repositories/      # Implementasi repository
        ├── domain/                # Layer Domain (murni Dart)
        │   ├── entities/          # Objek bisnis inti
        │   ├── repositories/      # Kontrak/interface repository
        │   └── usecases/          # Satu use case per file
        └── presentation/          # Layer Presentation
            ├── bloc/              # BLoC: event, state, bloc
            ├── pages/             # Halaman/Screen widget
            └── widgets/           # Widget lokal fitur ini
```

---

## Prinsip 3 Layer (Clean Architecture)

Setiap fitur **wajib** mengikuti tiga lapisan berikut. Dependensi hanya boleh mengalir **dari luar ke dalam** (Presentation → Domain ← Data). **Domain tidak boleh mengetahui lapisan lain.**

---

### 1. Domain Layer — *"Aturan Bisnis"*

**Isi:** `entities/`, `repositories/` (interface), `usecases/`

**Fungsi konkrit:**
- Mendefinisikan **entity** — objek bisnis murni tanpa anotasi JSON/database.
- Mendefinisikan **kontrak repository** sebagai abstract class (interface).
- Setiap **use case** mewakili satu aksi bisnis tunggal (misal: `LoginUseCase`, `GetUserProfileUseCase`).
- Menggunakan `Either<Failure, T>` dari package `dartz` untuk error handling fungsional.

**Aturan ketat:**
- Tidak boleh import package Flutter (`material.dart`, dll).
- Tidak boleh import dari layer `data/` atau `presentation/`.
- Boleh import hanya sesama `domain/` dan `core/errors/`.

```dart
// domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}
```

---

### 2. Data Layer — *"Sumber Data"*

**Isi:** `datasources/`, `models/`, `repositories/` (implementasi)

**Fungsi konkrit:**
- **Model** adalah DTO yang meng-extend atau memetakan entity Domain — berisi `fromJson`/`toJson`.
- **DataSource** bertanggung jawab berkomunikasi dengan sumber data (REST API, database lokal, cache).
- **Implementasi Repository** mengorkestrasi data dari datasource, menangani exception, dan mengkonversi ke `Either<Failure, Entity>`.

**Aturan ketat:**
- Tidak boleh diketahui langsung oleh layer `presentation/`.
- Boleh import `domain/` (untuk implementasi interface dan entity).
- Boleh import package eksternal (Dio, Hive, dll).

```dart
// data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

---

### 3. Presentation Layer — *"Antarmuka Pengguna"*

**Isi:** `bloc/`, `pages/`, `widgets/`

**Fungsi konkrit:**
- **BLoC** menerima `Event`, memanggil `UseCase`, dan menghasilkan `State` baru.
- **Page** adalah screen utama yang meng-consume BLoC via `BlocBuilder`/`BlocListener`.
- **Widget** adalah komponen UI kecil yang bersifat reusable dalam fitur tersebut.

**Aturan ketat:**
- BLoC tidak boleh memanggil Repository atau DataSource secara langsung.
- Tidak boleh ada logika bisnis di dalam widget.
- BLoC hanya boleh berinteraksi melalui UseCase.

```dart
// presentation/bloc/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase(LoginParams(
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });
  }
}
```

---

## Panduan GetIt (Dependency Injection)

Semua registrasi DI dilakukan di `core/di/injection_container.dart`. File DI per fitur disimpan di `features/<nama_fitur>/di/<nama_fitur>_injection.dart` dan dipanggil dari injection container utama.

### Aturan Registrasi — WAJIB DIPATUHI

| Tipe | Method | Alasan |
|------|--------|--------|
| **BLoC** | `registerFactory` | BLoC harus dibuat ulang setiap widget dibuka. Jika Singleton, state lama akan bocor ke screen baru. |
| **UseCase** | `registerLazySingleton` | UseCase stateless, aman di-share. Instance tunggal hemat memori. |
| **Repository** | `registerLazySingleton` | Repository tidak menyimpan state UI, cukup satu instance. |
| **DataSource** | `registerLazySingleton` | DataSource hanya membungkus client HTTP/DB yang sudah singleton. |
| **HTTP Client (Dio)** | `registerLazySingleton` | Satu koneksi pool untuk seluruh aplikasi. |

### Contoh Implementasi yang Benar

```dart
// core/di/injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // ===== EXTERNAL =====
  sl.registerLazySingleton(() => Dio());

  // ===== AUTH FEATURE =====
  _initAuth();
}

void _initAuth() {
  // BLoC — SELALU registerFactory
  sl.registerFactory(
    () => AuthBloc(loginUseCase: sl()),
  );

  // Use Cases — SELALU registerLazySingleton
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository — SELALU registerLazySingleton
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources — SELALU registerLazySingleton
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
}
```

### Contoh yang Salah (Memory Leak)

```dart
// JANGAN LAKUKAN INI — BLoC sebagai Singleton menyebabkan state lama
// tidak di-reset saat halaman dibuka ulang
sl.registerLazySingleton(() => AuthBloc(loginUseCase: sl()));
```

---

## Workflow Developer: Membuat Fitur Baru

Gunakan pendekatan **Inside-Out**: mulai dari aturan bisnis paling inti, baru keluar ke UI. Ini memastikan setiap layer dapat ditest secara independen.

```
[Domain] → [Data] → [DI] → [Presentation]
```

---

### Langkah 1 — Domain Layer: Entity & Interface

Buat model bisnis dan kontrak terlebih dahulu.

```
features/
└── product/
    └── domain/
        ├── entities/product_entity.dart       ← Buat ini dulu
        ├── repositories/product_repository.dart  ← Kemudian ini
        └── usecases/get_product_list_usecase.dart ← Lalu ini
```

**Checklist:**
- [ ] Buat `ProductEntity` (field inti tanpa anotasi JSON)
- [ ] Buat abstract class `ProductRepository` dengan method yang dibutuhkan
- [ ] Buat `GetProductListUseCase` yang memanggil repository
- [ ] Tulis unit test untuk use case

---

### Langkah 2 — Data Layer: Model & Implementasi

Implementasikan kontrak yang sudah dibuat di Domain.

```
features/
└── product/
    └── data/
        ├── models/product_model.dart              ← fromJson/toJson
        ├── datasources/product_remote_datasource.dart
        └── repositories/product_repository_impl.dart
```

**Checklist:**
- [ ] Buat `ProductModel extends ProductEntity` dengan `fromJson`
- [ ] Implementasi `ProductRemoteDataSourceImpl` menggunakan Dio
- [ ] Implementasi `ProductRepositoryImpl` dengan error handling `try/catch`
- [ ] Tulis unit test untuk repository (mock datasource)

---

### Langkah 3 — Dependency Injection: Registrasi

Daftarkan semua komponen ke GetIt. Selalu ikuti aturan `registerFactory` vs `registerLazySingleton`.

```dart
// features/product/di/product_injection.dart
void initProduct() {
  sl.registerFactory(() => ProductBloc(getProductList: sl()));
  sl.registerLazySingleton(() => GetProductListUseCase(sl()));
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: sl()),
  );
}
```

Panggil `initProduct()` dari `injection_container.dart`.

**Checklist:**
- [ ] BLoC didaftarkan dengan `registerFactory`
- [ ] UseCase, Repository, DataSource didaftarkan dengan `registerLazySingleton`
- [ ] `initProduct()` dipanggil dari injection container utama

---

### Langkah 4 — Presentation Layer: BLoC & UI

Buat BLoC, kemudian page dan widget.

```
features/
└── product/
    └── presentation/
        ├── bloc/
        │   ├── product_event.dart
        │   ├── product_state.dart
        │   └── product_bloc.dart
        ├── pages/product_list_page.dart
        └── widgets/product_card_widget.dart
```

**Checklist:**
- [ ] Definisikan semua `Event` yang dibutuhkan
- [ ] Definisikan semua `State` (Initial, Loading, Success, Failure)
- [ ] Implementasi `ProductBloc` — hanya panggil UseCase, tidak langsung ke Repository
- [ ] Buat `ProductListPage` dengan `BlocProvider` dan `BlocBuilder`
- [ ] Daftarkan route baru di `app/config/routes/`
- [ ] Tulis widget test

---

## Setup & Menjalankan Proyek

```bash
# Clone repository
git clone <repo-url>
cd <folder-proyek>

# Install dependencies
flutter pub get

# Generate kode (jika menggunakan build_runner)
flutter pub run build_runner build --delete-conflicting-outputs

# Jalankan di mode development
flutter run --flavor development --target lib/main_development.dart

# Jalankan seluruh test
flutter test
```

---

## Dependensi Utama

| Package | Kegunaan |
|---------|----------|
| `flutter_bloc` | State management (BLoC pattern) |
| `get_it` | Dependency Injection |
| `dartz` | Functional programming (`Either`) |
| `dio` | HTTP client |
| `equatable` | Value equality untuk entity & state |
| `injectable` *(opsional)* | Code generation untuk GetIt |

---

## Konvensi Penamaan

| Komponen | Konvensi | Contoh |
|----------|----------|--------|
| File | `snake_case.dart` | `product_repository.dart` |
| Class | `PascalCase` | `ProductRepository` |
| Variabel/Method | `camelCase` | `getUserById` |
| Konstanta | `kCamelCase` | `kBaseUrl` |
| BLoC Event | `VerbNoun` | `ProductFetched`, `LoginRequested` |
| BLoC State | `NounVerb` | `ProductLoadSuccess`, `AuthLoading` |

---

## Kontribusi

1. Buat branch baru dari `develop`: `git checkout -b feat/nama-fitur`
2. Ikuti struktur folder dan aturan DI yang telah ditetapkan.
3. Pastikan semua test lulus sebelum membuat Pull Request.
4. Gunakan format commit: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`

---

> **Catatan:** Dokumentasi ini adalah *living document*. Perbarui README jika ada keputusan arsitektur baru yang disepakati tim.
