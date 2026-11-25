# SafeDeck

**SafeDeck** adalah aplikasi manajemen kata sandi dan akun pribadi untuk Android yang mengutamakan privasi dan keamanan secara *offline-first*. Semua data tersimpan dan terenkripsi penuh di perangkat Anda—tanpa server, tanpa akun cloud, dan tanpa pelacakan.

## Unduh

- **Android (APK):** [Unduh SafeDeck v1.0.0](https://github.com/nluthfi/SafeDeck/releases/tag/v1.0.0)

> **Cara pemasangan:** Unduh file `SafeDeck-v1.0.0.apk` dari halaman Releases, buka di perangkat Android Anda, dan izinkan pemasangan dari sumber tidak dikenal jika diminta.

---

## Fitur Utama

- **Struktur Layanan -> Banyak Akun**: Kelompokkan beberapa akun (misalnya akun utama, smurf, kerja, atau bot) di bawah satu layanan seperti Steam, Discord, Google, dan lainnya.
- **Kustomisasi Kartu Layanan**: Pilih kategori, warna identitas, ikon brand otomatis atau foto kustom, serta atur urutan layanan dengan *drag-and-drop*.
- **Pencarian Cepat**: Cari layanan, nama akun, username, atau email secara instan.
- **Generator Kata Sandi Kuat**: Buat kata sandi acak sepanjang 8–64 karakter dengan opsi huruf besar, huruf kecil, angka, simbol, dan filter karakter mirip (`i, l, 1, 0, O`).
- **Indikator Kekuatan Sandi & Skor Keamanan**: Pantau kekuatan setiap kata sandi serta ringkasan keamanan seluruh brankas.
- **Detail Akun Lengkap**: Simpan username/ID, email, kata sandi, kode pemulihan 2FA, dan catatan tambahan dengan tombol salin cepat.
- **Multi-Bahasa**: Mendukung **Bahasa Indonesia** dan **English** (otomatis mengikuti bahasa perangkat dan dapat diganti kapan saja di menu Pengaturan).
- **Cadangan Terenkripsi**: Ekspor dan impor data brankas dalam format file `.brankas` yang dilindungi kata sandi.

---

## Keamanan

- **100% Offline & Lokal**: Tidak ada data yang dikirim ke server eksternal.
- **Enkripsi Database AES-256 (SQLCipher)**: Seluruh isi brankas dienkripsi di perangkat dengan kunci yang disimpan di Android Keystore.
- **PIN Master 6-Digit & Biometrik**: PIN di-hash lokal menggunakan PBKDF2-HMAC-SHA256 (100.000 iterasi) dan dilindungi kunci sementara 30 detik setelah 5 kali salah.
- **Kunci Otomatis & Pembersihan Clipboard**: Aplikasi dapat mengunci otomatis saat ditinggalkan, dan kata sandi yang disalin dibersihkan otomatis dari clipboard (bawaan 30 detik).
- **Proteksi Layar (`FLAG_SECURE`)**: Mencegah tangkapan layar (*screenshot*), perekaman layar, dan pratinjau di *recent apps*.
- **Cadangan AES-256-GCM**: File cadangan `.brankas` dienkripsi terotentikasi dengan kata sandi pilihan Anda.
