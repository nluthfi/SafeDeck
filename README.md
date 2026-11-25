# SafeDeck — Password & Vault Manager

Aplikasi mobile brankas kata sandi pribadi yang aman, *offline-first*, dan berstandar industri untuk Android dan iOS, dibangun menggunakan Flutter, Dart 3, Material 3, dan Riverpod mengikuti acuan desain Figma.

---

## 1. Fitur Utama

- **Penyimpanan Berstruktur Hirarki**: Pengelompokan Layanan (Steam, Discord, Google, dll.) yang memiliki banyak Akun (Akun Utama, Smurf, Bot, dll.).
- **Tampilan Sesuai Desain Figma**:
  - **Layar Kunci Aplikasi**: 6 titik indikator PIN, keypad 3x4 ergonomis, jalan pintas biometrik, dialog "Lupa PIN Master".
  - **Beranda & Ringkasan Keamanan**: Metrik langsung (jumlah akun, layanan, persentase skor keamanan aman), filter pencarian real-time, chip kategori (Semua, Game, Sosial, Kerja, Hiburan), daftar kartu layanan beravatar warna.
  - **Daftar Akun per Layanan**: Banner header layanan, daftar kartu akun dengan badge kekuatan sandi, tombol langsung "Salin ID" dan "Salin Password".
  - **Detail Akun Lengkap**: Field nama pengguna, email, kata sandi tersamar dengan tombol buka/tutup intip & indikator bar kekuatan 4 segmen, kode pemulihan 2FA, catatan, metadata tanggal dibuat/diubah, serta tombol "Salin Semua Info Akun" dan "Hapus Akun Ini".
  - **Tambah/Edit Layanan & Akun**: Pemilih swatch warna (6 palet), generator otomatis kata sandi kuat terintegrasi (⚡ Buat Password Kuat Otomatis), pratinjau kartu langsung, dan validasi form berbahasa Indonesia.
  - **Pencarian Real-Time**: Debounce 250ms, pengelompokan hasil ke dalam kategori "LAYANAN" dan "AKUN".
  - **Generator Password**: Kontrol panjang 8–64 karakter, opsi huruf besar, huruf kecil, angka, simbol, serta filter "Hindari Karakter Mirip (i, l, 1, 0, O)" menggunakan `Random.secure()`.
  - **Pengaturan & Cadangan**: Konfigurasi kunci otomatis, biometrik, ubah PIN master, pembersihan papan klip (clipboard) otomatis, ekspor cadangan terenkripsi `.brankas` (AES-256-GCM), dan impor data cadangan.
  - **State Khusus**: State kosong (*Empty State*), *shimmer loading skeleton*, toast kustom floating ("Kata Sandi Berhasil Disalin!"), modal menu opsi layanan, dan dialog konfirmasi hapus permanen.

---

## 2. Arsitektur & Struktur Folder (Feature-First)

```
lib/
├── core/
│   ├── router/
│   │   └── app_router.dart           # GoRouter dengan StatefulShellRoute & route redirect
│   ├── security/
│   │   ├── auth_provider.dart        # Notifier state kunci, PIN, biometrik, auto-lock
│   │   ├── backup_service.dart       # Enkripsi & dekripsi file .brankas (AES-256-GCM + PBKDF2)
│   │   └── security_service.dart     # Hash PIN PBKDF2, local_auth, secure storage, clipboard timer
│   ├── theme/
│   │   ├── app_colors.dart           # Palet warna design tokens Figma
│   │   ├── app_shadows.dart          # Shadow tokens (sm, md, lg)
│   │   ├── app_typography.dart       # Tipografi Inter (Title, H1-H3, Body, Small, Caption)
│   │   └── app_theme.dart            # ThemeData Material 3 & ThemeExtension
│   ├── utils/
│   │   └── password_generator.dart   # Generator sandi kriptografis Random.secure()
│   └── widgets/
│       ├── account_card.dart         # Kartu akun dengan tombol salin
│       ├── app_button.dart           # Varian primary, outline, soft, destructive, ghost
│       ├── app_header.dart           # Header standar dengan aksi & tombol kembali
│       ├── app_switch.dart           # Switch adaptif bertema primer
│       ├── app_text_field.dart       # Input teks standar, password toggle, & pencarian
│       ├── app_toast.dart            # Floating dark toast notifikasi
│       ├── bottom_nav_bar.dart       # Navigasi 3 tab (Brankas, Generator, Pengaturan)
│       ├── category_chip.dart        # Chip filter kategori aktif/inaktif
│       ├── color_swatch_picker.dart  # Pemilih 6 swatch warna layanan
│       ├── confirm_dialog.dart       # Dialog konfirmasi aksi destruktif
│       ├── empty_state.dart          # Komponen tampilan kosong beserta kartu tips
│       ├── field_card.dart           # Kartu label kapital + nilai + salin + intip sandi
│       ├── service_card.dart         # Kartu layanan beravatar warna & chevron
│       ├── settings_row.dart         # Baris menu pengaturan
│       ├── skeleton_card.dart        # Shimmer card loading
│       └── strength_indicator.dart   # StrengthBadge & StrengthBar (4 segmen)
├── data/
│   ├── database/
│   │   ├── database.dart             # Drift SQLite database dengan enkripsi SQLCipher
│   │   └── database.g.dart           # Kode ter-generate Drift
│   └── repositories/
│       └── vault_repository.dart     # Repository reaktif (Stream/watch), CRUD, kalkulasi skor
├── features/
│   ├── accounts/
│   │   ├── account_detail_screen.dart
│   │   ├── edit_account_screen.dart
│   │   └── service_accounts_screen.dart
│   ├── gallery/
│   │   └── component_gallery_screen.dart # Galeri komponen & token desain
│   ├── generator/
│   │   └── generator_screen.dart
│   ├── lock/
│   │   └── lock_screen.dart
│   ├── search/
│   │   └── search_screen.dart
│   ├── services/
│   │   ├── edit_service_screen.dart
│   │   ├── services_screen.dart
│   │   └── widgets/
│   │       └── service_options_bottom_sheet.dart
│   └── settings/
│       └── settings_screen.dart
└── main.dart
```

---

## 3. Catatan Keamanan (Security Architecture)

1. **Enkripsi Penuh SQLCipher (Database)**:
   - Basis data SQLite dienkripsi penuh menggunakan `sqlcipher_flutter_libs`.
   - Kunci enkripsi 256-bit dihasilkan secara acak melalui `Random.secure()` saat pertama kali aplikasi dijalankan dan disimpan di `flutter_secure_storage` (Android Keystore / iOS Keychain).
2. **Hashing PIN Master 6-Digit**:
   - Kata sandi/PIN master tidak pernah disimpan dalam bentuk plaintext.
   - Menggunakan algoritma derivasi kunci **PBKDF2-HMAC-SHA256** dengan **100.000 iterasi** dan garam (*salt*) acak 128-bit unik per perangkat.
   - **Analisis Batasan PIN 6-Digit**: PIN 6 digit memiliki ruang kunci terbatas ($10^6 = 1.000.000$ kombinasi). Oleh karena itu, proteksi utama diterapkan melalui:
     - Pembatasan percobaan (*rate limiting*): jeda waktu bertambah dan kunci akun selama 30 detik setelah 5 kali salah.
     - Penyimpanan hash dan salt di hardware-backed storage perangkat.
3. **Pembersihan Otomatis Papan Klip (Clipboard Auto-Clear)**:
   - Sandi atau ID yang disalin otomatis dihapus dari papan klip sistem setelah durasi yang dikonfigurasi (bawaan: 30 detik), meminimalkan risiko pencurian data oleh aplikasi pihak ketiga.
4. **Proteksi Layar (FLAG_SECURE & Screen Blurring)**:
   - Diaktifkan di level native (`MainActivity.kt` menggunakan `window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)`) untuk mencegah tangkapan layar (*screenshot*), perekaman layar, dan penyadapan via *app switcher preview*.
5. **Format Cadangan Terenkripsi (.brankas)**:
   - Menggunakan skema enkripsi terotentikasi **AES-256-GCM** dengan *nonce* acak 96-bit dan kunci yang diturunkan dari kata sandi cadangan pengguna (PBKDF2-HMAC-SHA256, 100.000 iterasi). File memvalidasi tag MAC dan integritas data saat impor.

---

## 4. Cara Menjalankan & Menjalankan Pengujian

### Prasyarat
- Flutter SDK (versi stable 3.24+ / 3.50+) & Dart 3.5+
- Android Studio / Xcode

### Langkah Instalasi & Menjalankan Aplikasi
```bash
# 1. Unduh dependensi
flutter pub get

# 2. Generate kode Drift database (jika ada perubahan skema)
dart run build_runner build --delete-conflicting-outputs

# 3. Jalankan analisis kode
flutter analyze

# 4. Jalankan seluruh rangkaian tes (19 tes lulus)
flutter test

# 5. Jalankan aplikasi di emulator atau perangkat fisik
flutter run
```

---

## 5. Rangkaian Pengujian (Test Suite)

Proyek ini dilengkapi dengan 19 tes otomatis tanpa error:
- `test/password_strength_test.dart`: Evaluasi rumus kekuatan kata sandi dan skor segmen 0–4.
- `test/password_generator_test.dart`: Pengujian panjang karakter, karakter set wajib, dan penghindaran karakter mirip.
- `test/backup_encryption_test.dart`: Pengujian ekspor AES-256-GCM `.brankas`, verifikasi MAC, penolakan kata sandi salah, dan pemulihan data.
- `test/database_repository_test.dart`: Pengujian operasi CRUD database Drift in-memory, cascade delete, dan kalkulasi ringkasan keamanan.
- `test/security_service_test.dart`: Pengujian deterministik derivasi PBKDF2 dan verifikasi salt.
- `test/card_widgets_test.dart`: Widget test interaksi dan rendering `ServiceCard` dan `AccountCard`.
- `test/form_validation_test.dart`: Pengujian validasi form tambah layanan dan akun dengan pesan berbahasa Indonesia.
- `test/widget_test.dart`: Smoke test inisialisasi aplikasi Brankas dan galeri komponen.
- `test/main_flow_test.dart`: Integration test alur utama (Buat PIN Master -> Buka Kunci -> Lihat Daftar Layanan Steam, Discord, Google).
