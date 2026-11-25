// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'SafeDeck';

  @override
  String get navVault => 'Brankas';

  @override
  String get navGenerator => 'Generator';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get cancel => 'Batal';

  @override
  String get cancelOrBack => 'Batal / Kembali';

  @override
  String get done => 'Selesai';

  @override
  String get understood => 'Mengerti';

  @override
  String get confirmDeletePermanent => 'Ya, Hapus Permanen';

  @override
  String get copyId => 'Salin ID';

  @override
  String get copyPassword => 'Salin Password';

  @override
  String get copyValue => 'Salin nilai';

  @override
  String get hidePassword => 'Sembunyikan kata sandi';

  @override
  String get showPassword => 'Lihat kata sandi';

  @override
  String copiedSuccess(String label) {
    return '$label Berhasil Disalin!';
  }

  @override
  String clipboardAutoClearNotice(int seconds) {
    return 'Clipboard dibersihkan otomatis dalam $seconds detik.';
  }

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get idLabel => 'ID';

  @override
  String get emailLabel => 'Email';

  @override
  String get recoveryCodeShort => 'Kode Pemulihan';

  @override
  String get allAccountInfo => 'Semua Info Akun';

  @override
  String get localLabel => 'Lokal';

  @override
  String get serviceFallback => 'Layanan';

  @override
  String savedAccountsCount(int count) {
    return '$count akun tersimpan';
  }

  @override
  String get strengthEmpty => 'Kosong';

  @override
  String get strengthEmptyDetail => 'Masukkan kata sandi';

  @override
  String get strengthWeak => 'Lemah';

  @override
  String get strengthWeakDetail =>
      'Kurang dari 8 karakter atau terlalu sederhana';

  @override
  String get strengthFair => 'Sedang';

  @override
  String get strengthFairDetail =>
      'Kombinasi huruf dan angka cukup, tambahkan simbol';

  @override
  String get strengthStrong => 'Kuat';

  @override
  String strengthStrongDetail(int length) {
    return '$length karakter unik dengan variasi karakter';
  }

  @override
  String get strengthVeryStrong => 'Sangat Kuat';

  @override
  String strengthVeryStrongDetail(int length) {
    return '$length Karakter: Angka & Simbol';
  }

  @override
  String get categoryAll => 'Semua';

  @override
  String get categoryGame => 'Game';

  @override
  String get categorySocial => 'Sosial';

  @override
  String get categorySocialMedia => 'Sosial Media';

  @override
  String get categoryWork => 'Kerja';

  @override
  String get categoryWorkBusiness => 'Kerja & Bisnis';

  @override
  String get categoryFinance => 'Keuangan';

  @override
  String get categoryEntertainment => 'Hiburan';

  @override
  String get lockTitleUnlock => 'Buka Kunci SafeDeck';

  @override
  String get lockSubtitleUnlock =>
      'Masukkan 6-digit PIN master atau gunakan biometrik';

  @override
  String get lockTitleCreate => 'Buat PIN Master 6-Digit';

  @override
  String get lockSubtitleCreate =>
      'Tentukan PIN master untuk mengamankan seluruh brankas';

  @override
  String get lockTitleConfirm => 'Konfirmasi PIN Master';

  @override
  String get lockSubtitleConfirm =>
      'Masukkan kembali 6-digit PIN yang baru dibuat';

  @override
  String get lockPinMismatch =>
      'PIN konfirmasi tidak cocok. Ulangi pembuatan PIN.';

  @override
  String lockTooManyAttempts(int seconds) {
    return 'Terlalu banyak percobaan. Terkunci selama $seconds detik.';
  }

  @override
  String lockTooManyAttemptsRetry(int seconds) {
    return 'Terlalu banyak percobaan salah. Coba lagi dalam $seconds detik.';
  }

  @override
  String lockWrongPinAttempts(int attempts) {
    return 'PIN salah. Sisa percobaan: $attempts';
  }

  @override
  String get lockWrongPin => 'PIN salah.';

  @override
  String get lockForgotPin => 'Lupa PIN Master?';

  @override
  String get lockForgotPinMessage =>
      'Demi keamanan data tingkat tinggi, PIN master Anda tidak disimpan di server dan hanya di-hash secara lokal di perangkat.\n\nJika lupa PIN, Anda dapat memulihkan brankas dengan mengimpor file cadangan terenkripsi (.brankas) yang pernah diekspor sebelumnya.';

  @override
  String get lockBiometricFailed =>
      'Autentikasi biometrik dibatalkan atau tidak cocok';

  @override
  String get biometricReason =>
      'Pindai sidik jari atau biometrik untuk membuka SafeDeck';

  @override
  String get biometricSignInTitle => 'Buka Kunci SafeDeck';

  @override
  String get biometricSignInHint => 'Sentuh sensor sidik jari';

  @override
  String get biometricCancelButton => 'Gunakan PIN';

  @override
  String get servicesSecurityNotification => 'Notifikasi Keamanan';

  @override
  String get servicesAllSafeTitle => 'Semua Kunci & Brankas Aman';

  @override
  String get servicesAllSafeSubtitle =>
      'Database terenkripsi penuh AES-256 lokal.';

  @override
  String get servicesEncryptedBanner => 'Terenkripsi Aman (AES-256)';

  @override
  String servicesMetricAccounts(int count) {
    return '$count Akun';
  }

  @override
  String get servicesMetricSaved => 'Tersimpan';

  @override
  String servicesMetricServices(int count) {
    return '$count Layanan';
  }

  @override
  String get servicesMetricCategories => 'Kategori';

  @override
  String get servicesMetricSafeScore => 'Skor Aman';

  @override
  String get servicesSearchHint => 'Cari layanan atau akun...';

  @override
  String get servicesEmptyTitle => 'Belum Ada Layanan';

  @override
  String get servicesEmptyDesc =>
      'Simpan akun game, media sosial, dan email Anda secara terpusat dan aman dalam satu brankas.';

  @override
  String get servicesEmptyAction => 'Tambah Layanan Pertama';

  @override
  String get servicesEmptyTip =>
      'Tips: Anda bisa mengelompokkan beberapa akun (mis. Akun 1 & 2) di satu layanan.';

  @override
  String servicesListHeader(int count) {
    return 'DAFTAR LAYANAN ($count)';
  }

  @override
  String get servicesDragHint => 'Geser untuk mengatur urutan';

  @override
  String get servicesAddButton => 'Tambah Layanan';

  @override
  String get editServiceTitleEdit => 'Ubah Layanan';

  @override
  String get editServiceTitleAdd => 'Tambah Layanan Baru';

  @override
  String get editServiceDeleteTooltip => 'Hapus Layanan';

  @override
  String get editServiceNameLabel => 'Nama Layanan';

  @override
  String get editServiceNameHint => 'mis. Epic Games Store';

  @override
  String get editServiceNameRequired => 'Nama layanan wajib diisi';

  @override
  String get editServiceCategoryLabel => 'Kategori Layanan';

  @override
  String get editServiceColorLabel => 'Pilih Warna Identitas';

  @override
  String get editServiceUrlLabel => 'URL Situs Web (Opsional)';

  @override
  String get editServicePreviewHeader => 'PRATINJAU TAMPILAN KARTU';

  @override
  String get editServiceSaveChanges => 'Simpan Perubahan';

  @override
  String get editServiceSaveNew => 'Simpan Layanan';

  @override
  String get editServiceDeleteAllButton => 'Hapus Layanan & Semua Akun';

  @override
  String get editServiceAddedToast => 'Layanan Berhasil Ditambahkan!';

  @override
  String get editServiceUpdatedToast => 'Layanan Berhasil Diperbarui!';

  @override
  String get editServiceSaveFailed => 'Gagal menyimpan layanan';

  @override
  String editServiceDeleteConfirmTitle(String name) {
    return 'Hapus Layanan $name?';
  }

  @override
  String get editServiceDeleteConfirmMessage =>
      'Semua akun yang tersimpan di bawah layanan ini akan dihapus permanen dari brankas.';

  @override
  String get editServiceDeleteConfirmAction => 'Ya, Hapus Semua Akun & Layanan';

  @override
  String get editServiceDeletedToast => 'Layanan Berhasil Dihapus';

  @override
  String get iconPickerHeader => 'IKON / FOTO LAYANAN (OPSIONAL)';

  @override
  String get iconPickerAutoDetect => 'Deteksi Otomatis';

  @override
  String get iconPickerInitial => 'Inisial';

  @override
  String get iconPickerCustomPhoto => 'Foto Kustom';

  @override
  String get iconPickerPickPhoto => 'Pilih Foto...';

  @override
  String serviceOptionsAccountCount(String category, int count) {
    return '$category • $count Akun';
  }

  @override
  String get serviceOptionsEdit => 'Ubah Nama & Kategori Layanan';

  @override
  String get serviceOptionsDuplicate => 'Duplikat Format Layanan';

  @override
  String get serviceOptionsCopySuffix => '(Salinan)';

  @override
  String get serviceOptionsDuplicatedToast =>
      'Format Layanan Berhasil Diduplikasi!';

  @override
  String get serviceOptionsExtraPin => 'Kunci dengan PIN Tambahan';

  @override
  String serviceOptionsExtraPinToast(String name) {
    return 'Proteksi PIN Tambahan Aktif untuk $name';
  }

  @override
  String get serviceOptionsDelete => 'Hapus Layanan & Semua Akun';

  @override
  String serviceOptionsDeleteMessage(int count, String name) {
    return 'Semua $count akun di bawah layanan $name akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get serviceAccountsOptionsTooltip => 'Opsi Layanan';

  @override
  String serviceAccountsActiveSummary(int count, String source) {
    return '$count Akun Aktif • $source';
  }

  @override
  String serviceAccountsSearchHint(String serviceName) {
    return 'Cari akun $serviceName...';
  }

  @override
  String get serviceAccountsEmptyTitle => 'Belum Ada Akun';

  @override
  String serviceAccountsEmptyDesc(String serviceName) {
    return 'Tambahkan akun pertama Anda untuk layanan $serviceName.';
  }

  @override
  String serviceAccountsAddButton(String serviceName) {
    return 'Tambah Akun $serviceName';
  }

  @override
  String serviceAccountsNoMatch(String query) {
    return 'Tidak ada akun yang cocok dengan \"$query\"';
  }

  @override
  String get accountDetailTitle => 'Detail Akun';

  @override
  String get accountDetailNotFound =>
      'Akun tidak ditemukan atau telah dihapus.';

  @override
  String get accountDetailEditTooltip => 'Ubah Akun';

  @override
  String get accountDetailUsernameField => 'NAMA PENGGUNA / ID';

  @override
  String get accountDetailEmailField => 'ALAMAT EMAIL';

  @override
  String get accountDetailPasswordField => 'KATA SANDI';

  @override
  String get accountDetailRecoveryField => 'KODE PEMULIHAN 2FA';

  @override
  String get accountDetailNoteField => 'CATATAN KHUSUS';

  @override
  String accountDetailTimestamps(String created, String updated) {
    return 'Dibuat: $created • Terakhir diubah: $updated';
  }

  @override
  String get accountDetailCopyAll => 'Salin Semua Info Akun';

  @override
  String get accountDetailDelete => 'Hapus Akun Ini';

  @override
  String get accountDetailDeleteTitle => 'Hapus Akun Ini?';

  @override
  String accountDetailDeleteMessage(String label) {
    return 'Akun \'$label\' beserta semua kata sandi akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get accountDetailDeleteConfirm => 'Ya, Hapus Akun Permanen';

  @override
  String get accountDetailDeletedToast => 'Akun Berhasil Dihapus';

  @override
  String get editAccountTitleEdit => 'Ubah Akun';

  @override
  String get editAccountTitleAdd => 'Tambah Akun Baru';

  @override
  String get editAccountSelectService => 'Pilih Layanan';

  @override
  String get editAccountSelectServiceHint => 'Pilih Layanan...';

  @override
  String get editAccountSelectServiceFirst => 'Pilih layanan terlebih dahulu';

  @override
  String get editAccountLabelField => 'Label Akun';

  @override
  String get editAccountLabelHint => 'mis. Akun Utama (CS2 & Dota)';

  @override
  String get editAccountLabelRequired => 'Label akun wajib diisi';

  @override
  String get editAccountUsernameField => 'ID Pengguna / Username';

  @override
  String get editAccountUsernameHint => 'mis. luthfi_steam';

  @override
  String get editAccountEmailField => 'Alamat Email';

  @override
  String get editAccountEmailHint => 'mis. luthfi.pro@gmail.com';

  @override
  String get editAccountPasswordField => 'Kata Sandi';

  @override
  String get editAccountPasswordHint => 'Masukkan kata sandi...';

  @override
  String get editAccountPasswordRequired => 'Kata sandi wajib diisi';

  @override
  String get editAccountGenerateButton => '⚡ Buat Password Kuat Otomatis';

  @override
  String get editAccountGeneratedToast => 'Kata Sandi Kuat Dibuat Otomatis!';

  @override
  String editAccountStrengthPrefix(String label, String detail) {
    return 'Kekuatan: $label ($detail)';
  }

  @override
  String get editAccountRecoveryField => 'Kode Pemulihan 2FA (Opsional)';

  @override
  String get editAccountNoteField => 'Catatan Tambahan (Opsional)';

  @override
  String get editAccountNoteHint => 'mis. 2FA aktif di HP Samsung...';

  @override
  String get editAccountSaveNew => 'Simpan Akun ke Brankas';

  @override
  String get editAccountAddedToast => 'Akun Berhasil Disimpan ke Brankas!';

  @override
  String get editAccountUpdatedToast => 'Akun Berhasil Diperbarui!';

  @override
  String get editAccountSaveFailed => 'Gagal menyimpan akun';

  @override
  String get generatorTitle => 'Generator Password';

  @override
  String generatorBadge(String label, int length) {
    return '$label ($length Karakter)';
  }

  @override
  String get generatorRegenerate => 'Acak Ulang';

  @override
  String get generatorLength => 'Panjang Karakter';

  @override
  String get generatorUpper => 'Huruf Besar (A-Z)';

  @override
  String get generatorLower => 'Huruf Kecil (a-z)';

  @override
  String get generatorNumbers => 'Angka (0-9)';

  @override
  String get generatorSymbols => 'Simbol Khusus (!@#\$%^&*)';

  @override
  String get generatorAvoidAmbiguous =>
      'Hindari Karakter Mirip (i, l, 1, 0, O)';

  @override
  String get searchEmptyTitle => 'Pencarian Cepat SafeDeck';

  @override
  String get searchEmptySubtitle =>
      'Ketik nama layanan, akun, atau email untuk mencari...';

  @override
  String searchNoResults(String query) {
    return 'Tidak ada layanan atau akun yang cocok dengan \"$query\"';
  }

  @override
  String searchServicesGroup(int count) {
    return 'LAYANAN ($count)';
  }

  @override
  String searchAccountsGroup(int count) {
    return 'AKUN ($count)';
  }

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsProfileTitle => 'Brankas Pribadi';

  @override
  String get settingsEncryptionActive => 'Enkripsi: AES-256 GCM Aktif';

  @override
  String get settingsSectionSecurity => 'KEAMANAN BRANKAS';

  @override
  String get settingsAutoLock => 'Kunci Otomatis';

  @override
  String get settingsAutoLockTitle => 'Durasi Kunci Otomatis';

  @override
  String settingsAutoLockUpdated(String duration) {
    return 'Kunci otomatis disetel ke $duration';
  }

  @override
  String get autoLockImmediate => 'Segera';

  @override
  String get autoLock1Min => '1 Menit';

  @override
  String get autoLock5Min => '5 Menit';

  @override
  String get autoLock15Min => '15 Menit';

  @override
  String get settingsBiometric => 'Buka dengan Biometrik';

  @override
  String get settingsBiometricDetected =>
      'Sidik jari atau biometrik terdeteksi';

  @override
  String get settingsBiometricDefault => 'Sensor sidik jari / kunci perangkat';

  @override
  String get settingsBiometricEnabled => 'Biometrik Diaktifkan';

  @override
  String get settingsBiometricDisabled => 'Biometrik Dinonaktifkan';

  @override
  String get settingsBiometricHint =>
      'Pastikan sidik jari terdaftar di Pengaturan HP Anda.';

  @override
  String get settingsChangePin => 'Ubah PIN Master 6-Digit';

  @override
  String get settingsOldPin => 'PIN Master Lama';

  @override
  String get settingsNewPin => 'PIN Master Baru (6 Digit)';

  @override
  String get settingsConfirmNewPin => 'Konfirmasi PIN Master Baru';

  @override
  String get settingsSavePin => 'Simpan PIN';

  @override
  String get settingsPinLengthError => 'PIN baru harus tepat 6 digit';

  @override
  String get settingsPinMismatchError => 'PIN konfirmasi tidak cocok';

  @override
  String get settingsPinUpdated => 'PIN Master Berhasil Diubah!';

  @override
  String get settingsOldPinWrong => 'PIN Master lama salah';

  @override
  String get settingsClearClipboard => 'Bersihkan Papan Klip';

  @override
  String get settingsClearClipboardTitle => 'Bersihkan Papan Klip Otomatis';

  @override
  String get settingsClipboardUpdated => 'Durasi clipboard diperbarui';

  @override
  String get clipboard30sRecommended => '30 Detik (Disarankan)';

  @override
  String clipboardSeconds(int seconds) {
    return '$seconds Detik';
  }

  @override
  String get clipboardNeverLong => 'Jangan Pernah';

  @override
  String get clipboardNeverShort => 'Jangan';

  @override
  String get settingsSectionPreferences => 'PREFERENSI';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageTitle => 'Pilih Bahasa Aplikasi';

  @override
  String get languageSystem => 'Ikuti Perangkat';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Bahasa diubah ke $language';
  }

  @override
  String get settingsSectionBackup => 'DATA & CADANGAN';

  @override
  String get settingsExportTitle => 'Ekspor Cadangan Terenkripsi';

  @override
  String get settingsExportSubtitle => 'Simpan file .brankas aman';

  @override
  String get settingsExportDialogDesc =>
      'Masukkan kata sandi untuk mengenkripsi file cadangan (.brankas) dengan AES-256-GCM.';

  @override
  String get settingsBackupPassword => 'Kata Sandi Cadangan';

  @override
  String get settingsBackupPasswordHint => 'Minimal 6 karakter...';

  @override
  String get settingsBackupPasswordMin => 'Kata sandi minimal 6 karakter';

  @override
  String get settingsExportAction => 'Ekspor File';

  @override
  String get settingsExportShareText =>
      'Cadangan Terenkripsi SafeDeck (.brankas)';

  @override
  String get settingsExportSuccess => 'File Cadangan Berhasil Diekspor!';

  @override
  String get settingsExportFailed => 'Gagal mengekspor file';

  @override
  String get settingsImportTitle => 'Impor File Cadangan (.brankas)';

  @override
  String get settingsImportSubtitle => 'Pulihkan data dari file ekspor';

  @override
  String get settingsImportDialogTitle => 'Masukkan Kata Sandi Cadangan';

  @override
  String get settingsImportDialogDesc =>
      'Masukkan kata sandi yang digunakan saat mengekspor file cadangan ini.';

  @override
  String get settingsImportAction => 'Buka & Impor';

  @override
  String get settingsImportSuccess => 'Impor Sukses!';

  @override
  String settingsImportSuccessSubtitle(int count) {
    return '$count akun berhasil ditambahkan ke brankas.';
  }

  @override
  String get settingsImportFailed => 'Gagal mengimpor file';

  @override
  String get settingsPickFileFailed => 'Gagal memilih file';

  @override
  String get settingsCloudSync => 'Sinkronisasi Cloud Aman';

  @override
  String get settingsCloudSyncSubtitle => 'Penyimpanan multi-perangkat';

  @override
  String get settingsComingSoon => 'Segera';

  @override
  String get settingsLockAndExit => 'Kunci & Keluar dari SafeDeck';
}
