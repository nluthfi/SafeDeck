// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SafeDeck';

  @override
  String get navVault => 'Vault';

  @override
  String get navGenerator => 'Generator';

  @override
  String get navSettings => 'Settings';

  @override
  String get cancel => 'Cancel';

  @override
  String get cancelOrBack => 'Cancel / Back';

  @override
  String get done => 'Done';

  @override
  String get understood => 'Got it';

  @override
  String get confirmDeletePermanent => 'Yes, Delete Permanently';

  @override
  String get copyId => 'Copy ID';

  @override
  String get copyPassword => 'Copy Password';

  @override
  String get copyValue => 'Copy value';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get showPassword => 'Show password';

  @override
  String copiedSuccess(String label) {
    return '$label Copied!';
  }

  @override
  String clipboardAutoClearNotice(int seconds) {
    return 'Clipboard will auto-clear in $seconds seconds.';
  }

  @override
  String get passwordLabel => 'Password';

  @override
  String get idLabel => 'ID';

  @override
  String get emailLabel => 'Email';

  @override
  String get recoveryCodeShort => 'Recovery Code';

  @override
  String get allAccountInfo => 'All Account Info';

  @override
  String get localLabel => 'Local';

  @override
  String get serviceFallback => 'Service';

  @override
  String savedAccountsCount(int count) {
    return '$count saved accounts';
  }

  @override
  String get strengthEmpty => 'Empty';

  @override
  String get strengthEmptyDetail => 'Enter a password';

  @override
  String get strengthWeak => 'Weak';

  @override
  String get strengthWeakDetail => 'Fewer than 8 characters or too simple';

  @override
  String get strengthFair => 'Fair';

  @override
  String get strengthFairDetail =>
      'Good mix of letters and numbers, add symbols';

  @override
  String get strengthStrong => 'Strong';

  @override
  String strengthStrongDetail(int length) {
    return '$length characters with good variety';
  }

  @override
  String get strengthVeryStrong => 'Very Strong';

  @override
  String strengthVeryStrongDetail(int length) {
    return '$length Chars: Numbers & Symbols';
  }

  @override
  String get categoryAll => 'All';

  @override
  String get categoryGame => 'Games';

  @override
  String get categorySocial => 'Social';

  @override
  String get categorySocialMedia => 'Social Media';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryWorkBusiness => 'Work & Business';

  @override
  String get categoryFinance => 'Finance';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get lockTitleUnlock => 'Unlock SafeDeck';

  @override
  String get lockSubtitleUnlock =>
      'Enter your 6-digit master PIN or use biometrics';

  @override
  String get lockTitleCreate => 'Create 6-Digit Master PIN';

  @override
  String get lockSubtitleCreate =>
      'Set a master PIN to protect your entire vault';

  @override
  String get lockTitleConfirm => 'Confirm Master PIN';

  @override
  String get lockSubtitleConfirm => 'Re-enter the 6-digit PIN you just created';

  @override
  String get lockPinMismatch =>
      'Confirmation PIN does not match. Please try again.';

  @override
  String lockTooManyAttempts(int seconds) {
    return 'Too many attempts. Locked for $seconds seconds.';
  }

  @override
  String lockTooManyAttemptsRetry(int seconds) {
    return 'Too many failed attempts. Try again in $seconds seconds.';
  }

  @override
  String lockWrongPinAttempts(int attempts) {
    return 'Wrong PIN. Attempts left: $attempts';
  }

  @override
  String get lockWrongPin => 'Wrong PIN.';

  @override
  String get lockForgotPin => 'Forgot Master PIN?';

  @override
  String get lockForgotPinMessage =>
      'For maximum security, your master PIN is never stored on any server and is only hashed locally on your device.\n\nIf you forget your PIN, you can restore your vault by importing a previously exported encrypted backup (.brankas) file.';

  @override
  String get lockBiometricFailed =>
      'Biometric authentication canceled or did not match';

  @override
  String get biometricReason =>
      'Scan your fingerprint or biometrics to unlock SafeDeck';

  @override
  String get biometricSignInTitle => 'Unlock SafeDeck';

  @override
  String get biometricSignInHint => 'Touch the fingerprint sensor';

  @override
  String get biometricCancelButton => 'Use PIN';

  @override
  String get servicesSecurityNotification => 'Security Status';

  @override
  String get servicesAllSafeTitle => 'All Keys & Vault Secure';

  @override
  String get servicesAllSafeSubtitle =>
      'Database is fully encrypted locally with AES-256.';

  @override
  String get servicesEncryptedBanner => 'Securely Encrypted (AES-256)';

  @override
  String servicesMetricAccounts(int count) {
    return '$count Accounts';
  }

  @override
  String get servicesMetricSaved => 'Saved';

  @override
  String servicesMetricServices(int count) {
    return '$count Services';
  }

  @override
  String get servicesMetricCategories => 'Categories';

  @override
  String get servicesMetricSafeScore => 'Safety Score';

  @override
  String get servicesSearchHint => 'Search services or accounts...';

  @override
  String get servicesEmptyTitle => 'No Services Yet';

  @override
  String get servicesEmptyDesc =>
      'Store your gaming, social media, and email accounts securely in one local vault.';

  @override
  String get servicesEmptyAction => 'Add First Service';

  @override
  String get servicesEmptyTip =>
      'Tip: You can group multiple accounts (e.g., Main & Alt) under a single service.';

  @override
  String servicesListHeader(int count) {
    return 'SERVICES ($count)';
  }

  @override
  String get servicesDragHint => 'Drag to reorder';

  @override
  String get servicesAddButton => 'Add Service';

  @override
  String get editServiceTitleEdit => 'Edit Service';

  @override
  String get editServiceTitleAdd => 'Add New Service';

  @override
  String get editServiceDeleteTooltip => 'Delete Service';

  @override
  String get editServiceNameLabel => 'Service Name';

  @override
  String get editServiceNameHint => 'e.g. Epic Games Store';

  @override
  String get editServiceNameRequired => 'Service name is required';

  @override
  String get editServiceCategoryLabel => 'Service Category';

  @override
  String get editServiceColorLabel => 'Accent Color';

  @override
  String get editServiceUrlLabel => 'Website URL (Optional)';

  @override
  String get editServicePreviewHeader => 'CARD PREVIEW';

  @override
  String get editServiceSaveChanges => 'Save Changes';

  @override
  String get editServiceSaveNew => 'Save Service';

  @override
  String get editServiceDeleteAllButton => 'Delete Service & All Accounts';

  @override
  String get editServiceAddedToast => 'Service Added!';

  @override
  String get editServiceUpdatedToast => 'Service Updated!';

  @override
  String get editServiceSaveFailed => 'Failed to save service';

  @override
  String editServiceDeleteConfirmTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get editServiceDeleteConfirmMessage =>
      'All accounts saved under this service will be permanently deleted from your vault.';

  @override
  String get editServiceDeleteConfirmAction => 'Yes, Delete Service & Accounts';

  @override
  String get editServiceDeletedToast => 'Service Deleted';

  @override
  String get iconPickerHeader => 'SERVICE ICON / PHOTO (OPTIONAL)';

  @override
  String get iconPickerAutoDetect => 'Auto Detect';

  @override
  String get iconPickerInitial => 'Initial';

  @override
  String get iconPickerCustomPhoto => 'Custom Photo';

  @override
  String get iconPickerPickPhoto => 'Pick Photo...';

  @override
  String serviceOptionsAccountCount(String category, int count) {
    return '$category • $count Accounts';
  }

  @override
  String get serviceOptionsEdit => 'Edit Service Name & Category';

  @override
  String get serviceOptionsDuplicate => 'Duplicate Service Template';

  @override
  String get serviceOptionsCopySuffix => '(Copy)';

  @override
  String get serviceOptionsDuplicatedToast => 'Service Template Duplicated!';

  @override
  String get serviceOptionsExtraPin => 'Lock with Extra PIN';

  @override
  String serviceOptionsExtraPinToast(String name) {
    return 'Extra PIN protection enabled for $name';
  }

  @override
  String get serviceOptionsDelete => 'Delete Service & All Accounts';

  @override
  String serviceOptionsDeleteMessage(int count, String name) {
    return 'All $count accounts under $name will be permanently deleted. This action cannot be undone.';
  }

  @override
  String get serviceAccountsOptionsTooltip => 'Service Options';

  @override
  String serviceAccountsActiveSummary(int count, String source) {
    return '$count Active Accounts • $source';
  }

  @override
  String serviceAccountsSearchHint(String serviceName) {
    return 'Search $serviceName accounts...';
  }

  @override
  String get serviceAccountsEmptyTitle => 'No Accounts Yet';

  @override
  String serviceAccountsEmptyDesc(String serviceName) {
    return 'Add your first account for $serviceName.';
  }

  @override
  String serviceAccountsAddButton(String serviceName) {
    return 'Add $serviceName Account';
  }

  @override
  String serviceAccountsNoMatch(String query) {
    return 'No accounts match \"$query\"';
  }

  @override
  String get accountDetailTitle => 'Account Details';

  @override
  String get accountDetailNotFound => 'Account not found or has been deleted.';

  @override
  String get accountDetailEditTooltip => 'Edit Account';

  @override
  String get accountDetailUsernameField => 'USERNAME / ID';

  @override
  String get accountDetailEmailField => 'EMAIL ADDRESS';

  @override
  String get accountDetailPasswordField => 'PASSWORD';

  @override
  String get accountDetailRecoveryField => '2FA RECOVERY CODE';

  @override
  String get accountDetailNoteField => 'NOTES';

  @override
  String accountDetailTimestamps(String created, String updated) {
    return 'Created: $created • Last updated: $updated';
  }

  @override
  String get accountDetailCopyAll => 'Copy All Account Info';

  @override
  String get accountDetailDelete => 'Delete This Account';

  @override
  String get accountDetailDeleteTitle => 'Delete This Account?';

  @override
  String accountDetailDeleteMessage(String label) {
    return 'Account \'$label\' and its password will be permanently deleted. This action cannot be undone.';
  }

  @override
  String get accountDetailDeleteConfirm => 'Yes, Delete Permanently';

  @override
  String get accountDetailDeletedToast => 'Account Deleted';

  @override
  String get editAccountTitleEdit => 'Edit Account';

  @override
  String get editAccountTitleAdd => 'Add New Account';

  @override
  String get editAccountSelectService => 'Select Service';

  @override
  String get editAccountSelectServiceHint => 'Select Service...';

  @override
  String get editAccountSelectServiceFirst => 'Please select a service first';

  @override
  String get editAccountLabelField => 'Account Label';

  @override
  String get editAccountLabelHint => 'e.g. Main Account (CS2 & Dota)';

  @override
  String get editAccountLabelRequired => 'Account label is required';

  @override
  String get editAccountUsernameField => 'User ID / Username';

  @override
  String get editAccountUsernameHint => 'e.g. luthfi_steam';

  @override
  String get editAccountEmailField => 'Email Address';

  @override
  String get editAccountEmailHint => 'e.g. luthfi.pro@gmail.com';

  @override
  String get editAccountPasswordField => 'Password';

  @override
  String get editAccountPasswordHint => 'Enter password...';

  @override
  String get editAccountPasswordRequired => 'Password is required';

  @override
  String get editAccountGenerateButton => '⚡ Auto-Generate Strong Password';

  @override
  String get editAccountGeneratedToast => 'Strong Password Generated!';

  @override
  String editAccountStrengthPrefix(String label, String detail) {
    return 'Strength: $label ($detail)';
  }

  @override
  String get editAccountRecoveryField => '2FA Recovery Code (Optional)';

  @override
  String get editAccountNoteField => 'Additional Notes (Optional)';

  @override
  String get editAccountNoteHint => 'e.g. 2FA active on Samsung phone...';

  @override
  String get editAccountSaveNew => 'Save Account to Vault';

  @override
  String get editAccountAddedToast => 'Account Saved to Vault!';

  @override
  String get editAccountUpdatedToast => 'Account Updated!';

  @override
  String get editAccountSaveFailed => 'Failed to save account';

  @override
  String get generatorTitle => 'Password Generator';

  @override
  String generatorBadge(String label, int length) {
    return '$label ($length Chars)';
  }

  @override
  String get generatorRegenerate => 'Regenerate';

  @override
  String get generatorLength => 'Character Length';

  @override
  String get generatorUpper => 'Uppercase (A-Z)';

  @override
  String get generatorLower => 'Lowercase (a-z)';

  @override
  String get generatorNumbers => 'Numbers (0-9)';

  @override
  String get generatorSymbols => 'Special Symbols (!@#\$%^&*)';

  @override
  String get generatorAvoidAmbiguous =>
      'Avoid Ambiguous Characters (i, l, 1, 0, O)';

  @override
  String get searchEmptyTitle => 'Quick SafeDeck Search';

  @override
  String get searchEmptySubtitle =>
      'Type a service name, account, or email to search...';

  @override
  String searchNoResults(String query) {
    return 'No services or accounts match \"$query\"';
  }

  @override
  String searchServicesGroup(int count) {
    return 'SERVICES ($count)';
  }

  @override
  String searchAccountsGroup(int count) {
    return 'ACCOUNTS ($count)';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfileTitle => 'Personal Vault';

  @override
  String get settingsEncryptionActive => 'Encryption: AES-256 GCM Active';

  @override
  String get settingsSectionSecurity => 'VAULT SECURITY';

  @override
  String get settingsAutoLock => 'Auto-Lock';

  @override
  String get settingsAutoLockTitle => 'Auto-Lock Duration';

  @override
  String settingsAutoLockUpdated(String duration) {
    return 'Auto-lock set to $duration';
  }

  @override
  String get autoLockImmediate => 'Immediately';

  @override
  String get autoLock1Min => '1 Minute';

  @override
  String get autoLock5Min => '5 Minutes';

  @override
  String get autoLock15Min => '15 Minutes';

  @override
  String get settingsBiometric => 'Unlock with Biometrics';

  @override
  String get settingsBiometricDetected => 'Fingerprint or biometrics detected';

  @override
  String get settingsBiometricDefault => 'Fingerprint sensor / device lock';

  @override
  String get settingsBiometricEnabled => 'Biometrics Enabled';

  @override
  String get settingsBiometricDisabled => 'Biometrics Disabled';

  @override
  String get settingsBiometricHint =>
      'Make sure biometrics are enrolled in your device settings.';

  @override
  String get settingsChangePin => 'Change 6-Digit Master PIN';

  @override
  String get settingsOldPin => 'Current Master PIN';

  @override
  String get settingsNewPin => 'New Master PIN (6 Digits)';

  @override
  String get settingsConfirmNewPin => 'Confirm New Master PIN';

  @override
  String get settingsSavePin => 'Save PIN';

  @override
  String get settingsPinLengthError => 'New PIN must be exactly 6 digits';

  @override
  String get settingsPinMismatchError => 'Confirmation PIN does not match';

  @override
  String get settingsPinUpdated => 'Master PIN Updated!';

  @override
  String get settingsOldPinWrong => 'Current Master PIN is incorrect';

  @override
  String get settingsClearClipboard => 'Clear Clipboard';

  @override
  String get settingsClearClipboardTitle => 'Auto-Clear Clipboard';

  @override
  String get settingsClipboardUpdated => 'Clipboard duration updated';

  @override
  String get clipboard30sRecommended => '30 Seconds (Recommended)';

  @override
  String clipboardSeconds(int seconds) {
    return '$seconds Seconds';
  }

  @override
  String get clipboardNeverLong => 'Never';

  @override
  String get clipboardNeverShort => 'Never';

  @override
  String get settingsSectionPreferences => 'PREFERENCES';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageTitle => 'Choose App Language';

  @override
  String get languageSystem => 'System Default';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Language changed to $language';
  }

  @override
  String get settingsSectionBackup => 'DATA & BACKUP';

  @override
  String get settingsExportTitle => 'Export Encrypted Backup';

  @override
  String get settingsExportSubtitle => 'Save a secure .brankas file';

  @override
  String get settingsExportDialogDesc =>
      'Enter a password to encrypt your backup file (.brankas) with AES-256-GCM.';

  @override
  String get settingsBackupPassword => 'Backup Password';

  @override
  String get settingsBackupPasswordHint => 'Minimum 6 characters...';

  @override
  String get settingsBackupPasswordMin =>
      'Password must be at least 6 characters';

  @override
  String get settingsExportAction => 'Export File';

  @override
  String get settingsExportShareText => 'SafeDeck Encrypted Backup (.brankas)';

  @override
  String get settingsExportSuccess => 'Backup File Exported!';

  @override
  String get settingsExportFailed => 'Failed to export file';

  @override
  String get settingsImportTitle => 'Import Backup File (.brankas)';

  @override
  String get settingsImportSubtitle => 'Restore data from an exported file';

  @override
  String get settingsImportDialogTitle => 'Enter Backup Password';

  @override
  String get settingsImportDialogDesc =>
      'Enter the password used when exporting this backup file.';

  @override
  String get settingsImportAction => 'Unlock & Import';

  @override
  String get settingsImportSuccess => 'Import Successful!';

  @override
  String settingsImportSuccessSubtitle(int count) {
    return '$count accounts added to your vault.';
  }

  @override
  String get settingsImportFailed => 'Failed to import file';

  @override
  String get settingsPickFileFailed => 'Failed to pick file';

  @override
  String get settingsCloudSync => 'Secure Cloud Sync';

  @override
  String get settingsCloudSyncSubtitle => 'Multi-device sync';

  @override
  String get settingsComingSoon => 'Soon';

  @override
  String get settingsLockAndExit => 'Lock & Exit SafeDeck';
}
