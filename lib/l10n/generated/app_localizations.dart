import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appName.
  ///
  /// In id, this message translates to:
  /// **'SafeDeck'**
  String get appName;

  /// No description provided for @navVault.
  ///
  /// In id, this message translates to:
  /// **'Brankas'**
  String get navVault;

  /// No description provided for @navGenerator.
  ///
  /// In id, this message translates to:
  /// **'Generator'**
  String get navGenerator;

  /// No description provided for @navSettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get navSettings;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @cancelOrBack.
  ///
  /// In id, this message translates to:
  /// **'Batal / Kembali'**
  String get cancelOrBack;

  /// No description provided for @done.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get done;

  /// No description provided for @understood.
  ///
  /// In id, this message translates to:
  /// **'Mengerti'**
  String get understood;

  /// No description provided for @confirmDeletePermanent.
  ///
  /// In id, this message translates to:
  /// **'Ya, Hapus Permanen'**
  String get confirmDeletePermanent;

  /// No description provided for @copyId.
  ///
  /// In id, this message translates to:
  /// **'Salin ID'**
  String get copyId;

  /// No description provided for @copyPassword.
  ///
  /// In id, this message translates to:
  /// **'Salin Password'**
  String get copyPassword;

  /// No description provided for @copyValue.
  ///
  /// In id, this message translates to:
  /// **'Salin nilai'**
  String get copyValue;

  /// No description provided for @hidePassword.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan kata sandi'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In id, this message translates to:
  /// **'Lihat kata sandi'**
  String get showPassword;

  /// No description provided for @copiedSuccess.
  ///
  /// In id, this message translates to:
  /// **'{label} Berhasil Disalin!'**
  String copiedSuccess(String label);

  /// No description provided for @clipboardAutoClearNotice.
  ///
  /// In id, this message translates to:
  /// **'Clipboard dibersihkan otomatis dalam {seconds} detik.'**
  String clipboardAutoClearNotice(int seconds);

  /// No description provided for @passwordLabel.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get passwordLabel;

  /// No description provided for @idLabel.
  ///
  /// In id, this message translates to:
  /// **'ID'**
  String get idLabel;

  /// No description provided for @emailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @recoveryCodeShort.
  ///
  /// In id, this message translates to:
  /// **'Kode Pemulihan'**
  String get recoveryCodeShort;

  /// No description provided for @allAccountInfo.
  ///
  /// In id, this message translates to:
  /// **'Semua Info Akun'**
  String get allAccountInfo;

  /// No description provided for @localLabel.
  ///
  /// In id, this message translates to:
  /// **'Lokal'**
  String get localLabel;

  /// No description provided for @serviceFallback.
  ///
  /// In id, this message translates to:
  /// **'Layanan'**
  String get serviceFallback;

  /// No description provided for @savedAccountsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} akun tersimpan'**
  String savedAccountsCount(int count);

  /// No description provided for @strengthEmpty.
  ///
  /// In id, this message translates to:
  /// **'Kosong'**
  String get strengthEmpty;

  /// No description provided for @strengthEmptyDetail.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi'**
  String get strengthEmptyDetail;

  /// No description provided for @strengthWeak.
  ///
  /// In id, this message translates to:
  /// **'Lemah'**
  String get strengthWeak;

  /// No description provided for @strengthWeakDetail.
  ///
  /// In id, this message translates to:
  /// **'Kurang dari 8 karakter atau terlalu sederhana'**
  String get strengthWeakDetail;

  /// No description provided for @strengthFair.
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get strengthFair;

  /// No description provided for @strengthFairDetail.
  ///
  /// In id, this message translates to:
  /// **'Kombinasi huruf dan angka cukup, tambahkan simbol'**
  String get strengthFairDetail;

  /// No description provided for @strengthStrong.
  ///
  /// In id, this message translates to:
  /// **'Kuat'**
  String get strengthStrong;

  /// No description provided for @strengthStrongDetail.
  ///
  /// In id, this message translates to:
  /// **'{length} karakter unik dengan variasi karakter'**
  String strengthStrongDetail(int length);

  /// No description provided for @strengthVeryStrong.
  ///
  /// In id, this message translates to:
  /// **'Sangat Kuat'**
  String get strengthVeryStrong;

  /// No description provided for @strengthVeryStrongDetail.
  ///
  /// In id, this message translates to:
  /// **'{length} Karakter: Angka & Simbol'**
  String strengthVeryStrongDetail(int length);

  /// No description provided for @categoryAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get categoryAll;

  /// No description provided for @categoryGame.
  ///
  /// In id, this message translates to:
  /// **'Game'**
  String get categoryGame;

  /// No description provided for @categorySocial.
  ///
  /// In id, this message translates to:
  /// **'Sosial'**
  String get categorySocial;

  /// No description provided for @categorySocialMedia.
  ///
  /// In id, this message translates to:
  /// **'Sosial Media'**
  String get categorySocialMedia;

  /// No description provided for @categoryWork.
  ///
  /// In id, this message translates to:
  /// **'Kerja'**
  String get categoryWork;

  /// No description provided for @categoryWorkBusiness.
  ///
  /// In id, this message translates to:
  /// **'Kerja & Bisnis'**
  String get categoryWorkBusiness;

  /// No description provided for @categoryFinance.
  ///
  /// In id, this message translates to:
  /// **'Keuangan'**
  String get categoryFinance;

  /// No description provided for @categoryEntertainment.
  ///
  /// In id, this message translates to:
  /// **'Hiburan'**
  String get categoryEntertainment;

  /// No description provided for @lockTitleUnlock.
  ///
  /// In id, this message translates to:
  /// **'Buka Kunci SafeDeck'**
  String get lockTitleUnlock;

  /// No description provided for @lockSubtitleUnlock.
  ///
  /// In id, this message translates to:
  /// **'Masukkan 6-digit PIN master atau gunakan biometrik'**
  String get lockSubtitleUnlock;

  /// No description provided for @lockTitleCreate.
  ///
  /// In id, this message translates to:
  /// **'Buat PIN Master 6-Digit'**
  String get lockTitleCreate;

  /// No description provided for @lockSubtitleCreate.
  ///
  /// In id, this message translates to:
  /// **'Tentukan PIN master untuk mengamankan seluruh brankas'**
  String get lockSubtitleCreate;

  /// No description provided for @lockTitleConfirm.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi PIN Master'**
  String get lockTitleConfirm;

  /// No description provided for @lockSubtitleConfirm.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kembali 6-digit PIN yang baru dibuat'**
  String get lockSubtitleConfirm;

  /// No description provided for @lockPinMismatch.
  ///
  /// In id, this message translates to:
  /// **'PIN konfirmasi tidak cocok. Ulangi pembuatan PIN.'**
  String get lockPinMismatch;

  /// No description provided for @lockTooManyAttempts.
  ///
  /// In id, this message translates to:
  /// **'Terlalu banyak percobaan. Terkunci selama {seconds} detik.'**
  String lockTooManyAttempts(int seconds);

  /// No description provided for @lockTooManyAttemptsRetry.
  ///
  /// In id, this message translates to:
  /// **'Terlalu banyak percobaan salah. Coba lagi dalam {seconds} detik.'**
  String lockTooManyAttemptsRetry(int seconds);

  /// No description provided for @lockWrongPinAttempts.
  ///
  /// In id, this message translates to:
  /// **'PIN salah. Sisa percobaan: {attempts}'**
  String lockWrongPinAttempts(int attempts);

  /// No description provided for @lockWrongPin.
  ///
  /// In id, this message translates to:
  /// **'PIN salah.'**
  String get lockWrongPin;

  /// No description provided for @lockForgotPin.
  ///
  /// In id, this message translates to:
  /// **'Lupa PIN Master?'**
  String get lockForgotPin;

  /// No description provided for @lockForgotPinMessage.
  ///
  /// In id, this message translates to:
  /// **'Demi keamanan data tingkat tinggi, PIN master Anda tidak disimpan di server dan hanya di-hash secara lokal di perangkat.\n\nJika lupa PIN, Anda dapat memulihkan brankas dengan mengimpor file cadangan terenkripsi (.brankas) yang pernah diekspor sebelumnya.'**
  String get lockForgotPinMessage;

  /// No description provided for @lockBiometricFailed.
  ///
  /// In id, this message translates to:
  /// **'Autentikasi biometrik dibatalkan atau tidak cocok'**
  String get lockBiometricFailed;

  /// No description provided for @biometricReason.
  ///
  /// In id, this message translates to:
  /// **'Pindai sidik jari atau biometrik untuk membuka SafeDeck'**
  String get biometricReason;

  /// No description provided for @biometricSignInTitle.
  ///
  /// In id, this message translates to:
  /// **'Buka Kunci SafeDeck'**
  String get biometricSignInTitle;

  /// No description provided for @biometricSignInHint.
  ///
  /// In id, this message translates to:
  /// **'Sentuh sensor sidik jari'**
  String get biometricSignInHint;

  /// No description provided for @biometricCancelButton.
  ///
  /// In id, this message translates to:
  /// **'Gunakan PIN'**
  String get biometricCancelButton;

  /// No description provided for @servicesSecurityNotification.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi Keamanan'**
  String get servicesSecurityNotification;

  /// No description provided for @servicesAllSafeTitle.
  ///
  /// In id, this message translates to:
  /// **'Semua Kunci & Brankas Aman'**
  String get servicesAllSafeTitle;

  /// No description provided for @servicesAllSafeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Database terenkripsi penuh AES-256 lokal.'**
  String get servicesAllSafeSubtitle;

  /// No description provided for @servicesEncryptedBanner.
  ///
  /// In id, this message translates to:
  /// **'Terenkripsi Aman (AES-256)'**
  String get servicesEncryptedBanner;

  /// No description provided for @servicesMetricAccounts.
  ///
  /// In id, this message translates to:
  /// **'{count} Akun'**
  String servicesMetricAccounts(int count);

  /// No description provided for @servicesMetricSaved.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan'**
  String get servicesMetricSaved;

  /// No description provided for @servicesMetricServices.
  ///
  /// In id, this message translates to:
  /// **'{count} Layanan'**
  String servicesMetricServices(int count);

  /// No description provided for @servicesMetricCategories.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get servicesMetricCategories;

  /// No description provided for @servicesMetricSafeScore.
  ///
  /// In id, this message translates to:
  /// **'Skor Aman'**
  String get servicesMetricSafeScore;

  /// No description provided for @servicesSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari layanan atau akun...'**
  String get servicesSearchHint;

  /// No description provided for @servicesEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Layanan'**
  String get servicesEmptyTitle;

  /// No description provided for @servicesEmptyDesc.
  ///
  /// In id, this message translates to:
  /// **'Simpan akun game, media sosial, dan email Anda secara terpusat dan aman dalam satu brankas.'**
  String get servicesEmptyDesc;

  /// No description provided for @servicesEmptyAction.
  ///
  /// In id, this message translates to:
  /// **'Tambah Layanan Pertama'**
  String get servicesEmptyAction;

  /// No description provided for @servicesEmptyTip.
  ///
  /// In id, this message translates to:
  /// **'Tips: Anda bisa mengelompokkan beberapa akun (mis. Akun 1 & 2) di satu layanan.'**
  String get servicesEmptyTip;

  /// No description provided for @servicesListHeader.
  ///
  /// In id, this message translates to:
  /// **'DAFTAR LAYANAN ({count})'**
  String servicesListHeader(int count);

  /// No description provided for @servicesDragHint.
  ///
  /// In id, this message translates to:
  /// **'Geser untuk mengatur urutan'**
  String get servicesDragHint;

  /// No description provided for @servicesAddButton.
  ///
  /// In id, this message translates to:
  /// **'Tambah Layanan'**
  String get servicesAddButton;

  /// No description provided for @editServiceTitleEdit.
  ///
  /// In id, this message translates to:
  /// **'Ubah Layanan'**
  String get editServiceTitleEdit;

  /// No description provided for @editServiceTitleAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Layanan Baru'**
  String get editServiceTitleAdd;

  /// No description provided for @editServiceDeleteTooltip.
  ///
  /// In id, this message translates to:
  /// **'Hapus Layanan'**
  String get editServiceDeleteTooltip;

  /// No description provided for @editServiceNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Layanan'**
  String get editServiceNameLabel;

  /// No description provided for @editServiceNameHint.
  ///
  /// In id, this message translates to:
  /// **'mis. Epic Games Store'**
  String get editServiceNameHint;

  /// No description provided for @editServiceNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama layanan wajib diisi'**
  String get editServiceNameRequired;

  /// No description provided for @editServiceCategoryLabel.
  ///
  /// In id, this message translates to:
  /// **'Kategori Layanan'**
  String get editServiceCategoryLabel;

  /// No description provided for @editServiceColorLabel.
  ///
  /// In id, this message translates to:
  /// **'Pilih Warna Identitas'**
  String get editServiceColorLabel;

  /// No description provided for @editServiceUrlLabel.
  ///
  /// In id, this message translates to:
  /// **'URL Situs Web (Opsional)'**
  String get editServiceUrlLabel;

  /// No description provided for @editServicePreviewHeader.
  ///
  /// In id, this message translates to:
  /// **'PRATINJAU TAMPILAN KARTU'**
  String get editServicePreviewHeader;

  /// No description provided for @editServiceSaveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get editServiceSaveChanges;

  /// No description provided for @editServiceSaveNew.
  ///
  /// In id, this message translates to:
  /// **'Simpan Layanan'**
  String get editServiceSaveNew;

  /// No description provided for @editServiceDeleteAllButton.
  ///
  /// In id, this message translates to:
  /// **'Hapus Layanan & Semua Akun'**
  String get editServiceDeleteAllButton;

  /// No description provided for @editServiceAddedToast.
  ///
  /// In id, this message translates to:
  /// **'Layanan Berhasil Ditambahkan!'**
  String get editServiceAddedToast;

  /// No description provided for @editServiceUpdatedToast.
  ///
  /// In id, this message translates to:
  /// **'Layanan Berhasil Diperbarui!'**
  String get editServiceUpdatedToast;

  /// No description provided for @editServiceSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan layanan'**
  String get editServiceSaveFailed;

  /// No description provided for @editServiceDeleteConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Layanan {name}?'**
  String editServiceDeleteConfirmTitle(String name);

  /// No description provided for @editServiceDeleteConfirmMessage.
  ///
  /// In id, this message translates to:
  /// **'Semua akun yang tersimpan di bawah layanan ini akan dihapus permanen dari brankas.'**
  String get editServiceDeleteConfirmMessage;

  /// No description provided for @editServiceDeleteConfirmAction.
  ///
  /// In id, this message translates to:
  /// **'Ya, Hapus Semua Akun & Layanan'**
  String get editServiceDeleteConfirmAction;

  /// No description provided for @editServiceDeletedToast.
  ///
  /// In id, this message translates to:
  /// **'Layanan Berhasil Dihapus'**
  String get editServiceDeletedToast;

  /// No description provided for @iconPickerHeader.
  ///
  /// In id, this message translates to:
  /// **'IKON / FOTO LAYANAN (OPSIONAL)'**
  String get iconPickerHeader;

  /// No description provided for @iconPickerAutoDetect.
  ///
  /// In id, this message translates to:
  /// **'Deteksi Otomatis'**
  String get iconPickerAutoDetect;

  /// No description provided for @iconPickerInitial.
  ///
  /// In id, this message translates to:
  /// **'Inisial'**
  String get iconPickerInitial;

  /// No description provided for @iconPickerCustomPhoto.
  ///
  /// In id, this message translates to:
  /// **'Foto Kustom'**
  String get iconPickerCustomPhoto;

  /// No description provided for @iconPickerPickPhoto.
  ///
  /// In id, this message translates to:
  /// **'Pilih Foto...'**
  String get iconPickerPickPhoto;

  /// No description provided for @serviceOptionsAccountCount.
  ///
  /// In id, this message translates to:
  /// **'{category} • {count} Akun'**
  String serviceOptionsAccountCount(String category, int count);

  /// No description provided for @serviceOptionsEdit.
  ///
  /// In id, this message translates to:
  /// **'Ubah Nama & Kategori Layanan'**
  String get serviceOptionsEdit;

  /// No description provided for @serviceOptionsDuplicate.
  ///
  /// In id, this message translates to:
  /// **'Duplikat Format Layanan'**
  String get serviceOptionsDuplicate;

  /// No description provided for @serviceOptionsCopySuffix.
  ///
  /// In id, this message translates to:
  /// **'(Salinan)'**
  String get serviceOptionsCopySuffix;

  /// No description provided for @serviceOptionsDuplicatedToast.
  ///
  /// In id, this message translates to:
  /// **'Format Layanan Berhasil Diduplikasi!'**
  String get serviceOptionsDuplicatedToast;

  /// No description provided for @serviceOptionsExtraPin.
  ///
  /// In id, this message translates to:
  /// **'Kunci dengan PIN Tambahan'**
  String get serviceOptionsExtraPin;

  /// No description provided for @serviceOptionsExtraPinToast.
  ///
  /// In id, this message translates to:
  /// **'Proteksi PIN Tambahan Aktif untuk {name}'**
  String serviceOptionsExtraPinToast(String name);

  /// No description provided for @serviceOptionsDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus Layanan & Semua Akun'**
  String get serviceOptionsDelete;

  /// No description provided for @serviceOptionsDeleteMessage.
  ///
  /// In id, this message translates to:
  /// **'Semua {count} akun di bawah layanan {name} akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.'**
  String serviceOptionsDeleteMessage(int count, String name);

  /// No description provided for @serviceAccountsOptionsTooltip.
  ///
  /// In id, this message translates to:
  /// **'Opsi Layanan'**
  String get serviceAccountsOptionsTooltip;

  /// No description provided for @serviceAccountsActiveSummary.
  ///
  /// In id, this message translates to:
  /// **'{count} Akun Aktif • {source}'**
  String serviceAccountsActiveSummary(int count, String source);

  /// No description provided for @serviceAccountsSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari akun {serviceName}...'**
  String serviceAccountsSearchHint(String serviceName);

  /// No description provided for @serviceAccountsEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Akun'**
  String get serviceAccountsEmptyTitle;

  /// No description provided for @serviceAccountsEmptyDesc.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan akun pertama Anda untuk layanan {serviceName}.'**
  String serviceAccountsEmptyDesc(String serviceName);

  /// No description provided for @serviceAccountsAddButton.
  ///
  /// In id, this message translates to:
  /// **'Tambah Akun {serviceName}'**
  String serviceAccountsAddButton(String serviceName);

  /// No description provided for @serviceAccountsNoMatch.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada akun yang cocok dengan \"{query}\"'**
  String serviceAccountsNoMatch(String query);

  /// No description provided for @accountDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Akun'**
  String get accountDetailTitle;

  /// No description provided for @accountDetailNotFound.
  ///
  /// In id, this message translates to:
  /// **'Akun tidak ditemukan atau telah dihapus.'**
  String get accountDetailNotFound;

  /// No description provided for @accountDetailEditTooltip.
  ///
  /// In id, this message translates to:
  /// **'Ubah Akun'**
  String get accountDetailEditTooltip;

  /// No description provided for @accountDetailUsernameField.
  ///
  /// In id, this message translates to:
  /// **'NAMA PENGGUNA / ID'**
  String get accountDetailUsernameField;

  /// No description provided for @accountDetailEmailField.
  ///
  /// In id, this message translates to:
  /// **'ALAMAT EMAIL'**
  String get accountDetailEmailField;

  /// No description provided for @accountDetailPasswordField.
  ///
  /// In id, this message translates to:
  /// **'KATA SANDI'**
  String get accountDetailPasswordField;

  /// No description provided for @accountDetailRecoveryField.
  ///
  /// In id, this message translates to:
  /// **'KODE PEMULIHAN 2FA'**
  String get accountDetailRecoveryField;

  /// No description provided for @accountDetailNoteField.
  ///
  /// In id, this message translates to:
  /// **'CATATAN KHUSUS'**
  String get accountDetailNoteField;

  /// No description provided for @accountDetailTimestamps.
  ///
  /// In id, this message translates to:
  /// **'Dibuat: {created} • Terakhir diubah: {updated}'**
  String accountDetailTimestamps(String created, String updated);

  /// No description provided for @accountDetailCopyAll.
  ///
  /// In id, this message translates to:
  /// **'Salin Semua Info Akun'**
  String get accountDetailCopyAll;

  /// No description provided for @accountDetailDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus Akun Ini'**
  String get accountDetailDelete;

  /// No description provided for @accountDetailDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Akun Ini?'**
  String get accountDetailDeleteTitle;

  /// No description provided for @accountDetailDeleteMessage.
  ///
  /// In id, this message translates to:
  /// **'Akun \'{label}\' beserta semua kata sandi akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.'**
  String accountDetailDeleteMessage(String label);

  /// No description provided for @accountDetailDeleteConfirm.
  ///
  /// In id, this message translates to:
  /// **'Ya, Hapus Akun Permanen'**
  String get accountDetailDeleteConfirm;

  /// No description provided for @accountDetailDeletedToast.
  ///
  /// In id, this message translates to:
  /// **'Akun Berhasil Dihapus'**
  String get accountDetailDeletedToast;

  /// No description provided for @editAccountTitleEdit.
  ///
  /// In id, this message translates to:
  /// **'Ubah Akun'**
  String get editAccountTitleEdit;

  /// No description provided for @editAccountTitleAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Akun Baru'**
  String get editAccountTitleAdd;

  /// No description provided for @editAccountSelectService.
  ///
  /// In id, this message translates to:
  /// **'Pilih Layanan'**
  String get editAccountSelectService;

  /// No description provided for @editAccountSelectServiceHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih Layanan...'**
  String get editAccountSelectServiceHint;

  /// No description provided for @editAccountSelectServiceFirst.
  ///
  /// In id, this message translates to:
  /// **'Pilih layanan terlebih dahulu'**
  String get editAccountSelectServiceFirst;

  /// No description provided for @editAccountLabelField.
  ///
  /// In id, this message translates to:
  /// **'Label Akun'**
  String get editAccountLabelField;

  /// No description provided for @editAccountLabelHint.
  ///
  /// In id, this message translates to:
  /// **'mis. Akun Utama (CS2 & Dota)'**
  String get editAccountLabelHint;

  /// No description provided for @editAccountLabelRequired.
  ///
  /// In id, this message translates to:
  /// **'Label akun wajib diisi'**
  String get editAccountLabelRequired;

  /// No description provided for @editAccountUsernameField.
  ///
  /// In id, this message translates to:
  /// **'ID Pengguna / Username'**
  String get editAccountUsernameField;

  /// No description provided for @editAccountUsernameHint.
  ///
  /// In id, this message translates to:
  /// **'mis. luthfi_steam'**
  String get editAccountUsernameHint;

  /// No description provided for @editAccountEmailField.
  ///
  /// In id, this message translates to:
  /// **'Alamat Email'**
  String get editAccountEmailField;

  /// No description provided for @editAccountEmailHint.
  ///
  /// In id, this message translates to:
  /// **'mis. luthfi.pro@gmail.com'**
  String get editAccountEmailHint;

  /// No description provided for @editAccountPasswordField.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get editAccountPasswordField;

  /// No description provided for @editAccountPasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi...'**
  String get editAccountPasswordHint;

  /// No description provided for @editAccountPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi wajib diisi'**
  String get editAccountPasswordRequired;

  /// No description provided for @editAccountGenerateButton.
  ///
  /// In id, this message translates to:
  /// **'⚡ Buat Password Kuat Otomatis'**
  String get editAccountGenerateButton;

  /// No description provided for @editAccountGeneratedToast.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi Kuat Dibuat Otomatis!'**
  String get editAccountGeneratedToast;

  /// No description provided for @editAccountStrengthPrefix.
  ///
  /// In id, this message translates to:
  /// **'Kekuatan: {label} ({detail})'**
  String editAccountStrengthPrefix(String label, String detail);

  /// No description provided for @editAccountRecoveryField.
  ///
  /// In id, this message translates to:
  /// **'Kode Pemulihan 2FA (Opsional)'**
  String get editAccountRecoveryField;

  /// No description provided for @editAccountNoteField.
  ///
  /// In id, this message translates to:
  /// **'Catatan Tambahan (Opsional)'**
  String get editAccountNoteField;

  /// No description provided for @editAccountNoteHint.
  ///
  /// In id, this message translates to:
  /// **'mis. 2FA aktif di HP Samsung...'**
  String get editAccountNoteHint;

  /// No description provided for @editAccountSaveNew.
  ///
  /// In id, this message translates to:
  /// **'Simpan Akun ke Brankas'**
  String get editAccountSaveNew;

  /// No description provided for @editAccountAddedToast.
  ///
  /// In id, this message translates to:
  /// **'Akun Berhasil Disimpan ke Brankas!'**
  String get editAccountAddedToast;

  /// No description provided for @editAccountUpdatedToast.
  ///
  /// In id, this message translates to:
  /// **'Akun Berhasil Diperbarui!'**
  String get editAccountUpdatedToast;

  /// No description provided for @editAccountSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan akun'**
  String get editAccountSaveFailed;

  /// No description provided for @generatorTitle.
  ///
  /// In id, this message translates to:
  /// **'Generator Password'**
  String get generatorTitle;

  /// No description provided for @generatorBadge.
  ///
  /// In id, this message translates to:
  /// **'{label} ({length} Karakter)'**
  String generatorBadge(String label, int length);

  /// No description provided for @generatorRegenerate.
  ///
  /// In id, this message translates to:
  /// **'Acak Ulang'**
  String get generatorRegenerate;

  /// No description provided for @generatorLength.
  ///
  /// In id, this message translates to:
  /// **'Panjang Karakter'**
  String get generatorLength;

  /// No description provided for @generatorUpper.
  ///
  /// In id, this message translates to:
  /// **'Huruf Besar (A-Z)'**
  String get generatorUpper;

  /// No description provided for @generatorLower.
  ///
  /// In id, this message translates to:
  /// **'Huruf Kecil (a-z)'**
  String get generatorLower;

  /// No description provided for @generatorNumbers.
  ///
  /// In id, this message translates to:
  /// **'Angka (0-9)'**
  String get generatorNumbers;

  /// No description provided for @generatorSymbols.
  ///
  /// In id, this message translates to:
  /// **'Simbol Khusus (!@#\$%^&*)'**
  String get generatorSymbols;

  /// No description provided for @generatorAvoidAmbiguous.
  ///
  /// In id, this message translates to:
  /// **'Hindari Karakter Mirip (i, l, 1, 0, O)'**
  String get generatorAvoidAmbiguous;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Pencarian Cepat SafeDeck'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Ketik nama layanan, akun, atau email untuk mencari...'**
  String get searchEmptySubtitle;

  /// No description provided for @searchNoResults.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada layanan atau akun yang cocok dengan \"{query}\"'**
  String searchNoResults(String query);

  /// No description provided for @searchServicesGroup.
  ///
  /// In id, this message translates to:
  /// **'LAYANAN ({count})'**
  String searchServicesGroup(int count);

  /// No description provided for @searchAccountsGroup.
  ///
  /// In id, this message translates to:
  /// **'AKUN ({count})'**
  String searchAccountsGroup(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsProfileTitle.
  ///
  /// In id, this message translates to:
  /// **'Brankas Pribadi'**
  String get settingsProfileTitle;

  /// No description provided for @settingsEncryptionActive.
  ///
  /// In id, this message translates to:
  /// **'Enkripsi: AES-256 GCM Aktif'**
  String get settingsEncryptionActive;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In id, this message translates to:
  /// **'KEAMANAN BRANKAS'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsAutoLock.
  ///
  /// In id, this message translates to:
  /// **'Kunci Otomatis'**
  String get settingsAutoLock;

  /// No description provided for @settingsAutoLockTitle.
  ///
  /// In id, this message translates to:
  /// **'Durasi Kunci Otomatis'**
  String get settingsAutoLockTitle;

  /// No description provided for @settingsAutoLockUpdated.
  ///
  /// In id, this message translates to:
  /// **'Kunci otomatis disetel ke {duration}'**
  String settingsAutoLockUpdated(String duration);

  /// No description provided for @autoLockImmediate.
  ///
  /// In id, this message translates to:
  /// **'Segera'**
  String get autoLockImmediate;

  /// No description provided for @autoLock1Min.
  ///
  /// In id, this message translates to:
  /// **'1 Menit'**
  String get autoLock1Min;

  /// No description provided for @autoLock5Min.
  ///
  /// In id, this message translates to:
  /// **'5 Menit'**
  String get autoLock5Min;

  /// No description provided for @autoLock15Min.
  ///
  /// In id, this message translates to:
  /// **'15 Menit'**
  String get autoLock15Min;

  /// No description provided for @settingsBiometric.
  ///
  /// In id, this message translates to:
  /// **'Buka dengan Biometrik'**
  String get settingsBiometric;

  /// No description provided for @settingsBiometricDetected.
  ///
  /// In id, this message translates to:
  /// **'Sidik jari atau biometrik terdeteksi'**
  String get settingsBiometricDetected;

  /// No description provided for @settingsBiometricDefault.
  ///
  /// In id, this message translates to:
  /// **'Sensor sidik jari / kunci perangkat'**
  String get settingsBiometricDefault;

  /// No description provided for @settingsBiometricEnabled.
  ///
  /// In id, this message translates to:
  /// **'Biometrik Diaktifkan'**
  String get settingsBiometricEnabled;

  /// No description provided for @settingsBiometricDisabled.
  ///
  /// In id, this message translates to:
  /// **'Biometrik Dinonaktifkan'**
  String get settingsBiometricDisabled;

  /// No description provided for @settingsBiometricHint.
  ///
  /// In id, this message translates to:
  /// **'Pastikan sidik jari terdaftar di Pengaturan HP Anda.'**
  String get settingsBiometricHint;

  /// No description provided for @settingsChangePin.
  ///
  /// In id, this message translates to:
  /// **'Ubah PIN Master 6-Digit'**
  String get settingsChangePin;

  /// No description provided for @settingsOldPin.
  ///
  /// In id, this message translates to:
  /// **'PIN Master Lama'**
  String get settingsOldPin;

  /// No description provided for @settingsNewPin.
  ///
  /// In id, this message translates to:
  /// **'PIN Master Baru (6 Digit)'**
  String get settingsNewPin;

  /// No description provided for @settingsConfirmNewPin.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi PIN Master Baru'**
  String get settingsConfirmNewPin;

  /// No description provided for @settingsSavePin.
  ///
  /// In id, this message translates to:
  /// **'Simpan PIN'**
  String get settingsSavePin;

  /// No description provided for @settingsPinLengthError.
  ///
  /// In id, this message translates to:
  /// **'PIN baru harus tepat 6 digit'**
  String get settingsPinLengthError;

  /// No description provided for @settingsPinMismatchError.
  ///
  /// In id, this message translates to:
  /// **'PIN konfirmasi tidak cocok'**
  String get settingsPinMismatchError;

  /// No description provided for @settingsPinUpdated.
  ///
  /// In id, this message translates to:
  /// **'PIN Master Berhasil Diubah!'**
  String get settingsPinUpdated;

  /// No description provided for @settingsOldPinWrong.
  ///
  /// In id, this message translates to:
  /// **'PIN Master lama salah'**
  String get settingsOldPinWrong;

  /// No description provided for @settingsClearClipboard.
  ///
  /// In id, this message translates to:
  /// **'Bersihkan Papan Klip'**
  String get settingsClearClipboard;

  /// No description provided for @settingsClearClipboardTitle.
  ///
  /// In id, this message translates to:
  /// **'Bersihkan Papan Klip Otomatis'**
  String get settingsClearClipboardTitle;

  /// No description provided for @settingsClipboardUpdated.
  ///
  /// In id, this message translates to:
  /// **'Durasi clipboard diperbarui'**
  String get settingsClipboardUpdated;

  /// No description provided for @clipboard30sRecommended.
  ///
  /// In id, this message translates to:
  /// **'30 Detik (Disarankan)'**
  String get clipboard30sRecommended;

  /// No description provided for @clipboardSeconds.
  ///
  /// In id, this message translates to:
  /// **'{seconds} Detik'**
  String clipboardSeconds(int seconds);

  /// No description provided for @clipboardNeverLong.
  ///
  /// In id, this message translates to:
  /// **'Jangan Pernah'**
  String get clipboardNeverLong;

  /// No description provided for @clipboardNeverShort.
  ///
  /// In id, this message translates to:
  /// **'Jangan'**
  String get clipboardNeverShort;

  /// No description provided for @settingsSectionPreferences.
  ///
  /// In id, this message translates to:
  /// **'PREFERENSI'**
  String get settingsSectionPreferences;

  /// No description provided for @settingsLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa Aplikasi'**
  String get settingsLanguageTitle;

  /// No description provided for @languageSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti Perangkat'**
  String get languageSystem;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsLanguageUpdated.
  ///
  /// In id, this message translates to:
  /// **'Bahasa diubah ke {language}'**
  String settingsLanguageUpdated(String language);

  /// No description provided for @settingsSectionBackup.
  ///
  /// In id, this message translates to:
  /// **'DATA & CADANGAN'**
  String get settingsSectionBackup;

  /// No description provided for @settingsExportTitle.
  ///
  /// In id, this message translates to:
  /// **'Ekspor Cadangan Terenkripsi'**
  String get settingsExportTitle;

  /// No description provided for @settingsExportSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Simpan file .brankas aman'**
  String get settingsExportSubtitle;

  /// No description provided for @settingsExportDialogDesc.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi untuk mengenkripsi file cadangan (.brankas) dengan AES-256-GCM.'**
  String get settingsExportDialogDesc;

  /// No description provided for @settingsBackupPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi Cadangan'**
  String get settingsBackupPassword;

  /// No description provided for @settingsBackupPasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Minimal 6 karakter...'**
  String get settingsBackupPasswordHint;

  /// No description provided for @settingsBackupPasswordMin.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi minimal 6 karakter'**
  String get settingsBackupPasswordMin;

  /// No description provided for @settingsExportAction.
  ///
  /// In id, this message translates to:
  /// **'Ekspor File'**
  String get settingsExportAction;

  /// No description provided for @settingsExportShareText.
  ///
  /// In id, this message translates to:
  /// **'Cadangan Terenkripsi SafeDeck (.brankas)'**
  String get settingsExportShareText;

  /// No description provided for @settingsExportSuccess.
  ///
  /// In id, this message translates to:
  /// **'File Cadangan Berhasil Diekspor!'**
  String get settingsExportSuccess;

  /// No description provided for @settingsExportFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengekspor file'**
  String get settingsExportFailed;

  /// No description provided for @settingsImportTitle.
  ///
  /// In id, this message translates to:
  /// **'Impor File Cadangan (.brankas)'**
  String get settingsImportTitle;

  /// No description provided for @settingsImportSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pulihkan data dari file ekspor'**
  String get settingsImportSubtitle;

  /// No description provided for @settingsImportDialogTitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan Kata Sandi Cadangan'**
  String get settingsImportDialogTitle;

  /// No description provided for @settingsImportDialogDesc.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi yang digunakan saat mengekspor file cadangan ini.'**
  String get settingsImportDialogDesc;

  /// No description provided for @settingsImportAction.
  ///
  /// In id, this message translates to:
  /// **'Buka & Impor'**
  String get settingsImportAction;

  /// No description provided for @settingsImportSuccess.
  ///
  /// In id, this message translates to:
  /// **'Impor Sukses!'**
  String get settingsImportSuccess;

  /// No description provided for @settingsImportSuccessSubtitle.
  ///
  /// In id, this message translates to:
  /// **'{count} akun berhasil ditambahkan ke brankas.'**
  String settingsImportSuccessSubtitle(int count);

  /// No description provided for @settingsImportFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengimpor file'**
  String get settingsImportFailed;

  /// No description provided for @settingsPickFileFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memilih file'**
  String get settingsPickFileFailed;

  /// No description provided for @settingsCloudSync.
  ///
  /// In id, this message translates to:
  /// **'Sinkronisasi Cloud Aman'**
  String get settingsCloudSync;

  /// No description provided for @settingsCloudSyncSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Penyimpanan multi-perangkat'**
  String get settingsCloudSyncSubtitle;

  /// No description provided for @settingsComingSoon.
  ///
  /// In id, this message translates to:
  /// **'Segera'**
  String get settingsComingSoon;

  /// No description provided for @settingsLockAndExit.
  ///
  /// In id, this message translates to:
  /// **'Kunci & Keluar dari SafeDeck'**
  String get settingsLockAndExit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
