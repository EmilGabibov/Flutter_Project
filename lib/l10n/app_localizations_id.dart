// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get homeTabTitle => 'Beranda';

  @override
  String get socialTabTitle => 'Sosial';

  @override
  String get socialTabTooltip => 'Social — friends & mitras';

  @override
  String get profileTabTitle => 'Profil';

  @override
  String get profileTabTooltip => 'Profil — history & settings';

  @override
  String get activityTabTitle => 'Aktivitas';

  @override
  String get friendsTabTitle => 'Teman';

  @override
  String get leaderboardTabTitle => 'Papan Peringkat';

  @override
  String get authWelcomeTitle => 'Selamat datang di\nHable.';

  @override
  String get authLoginSubtitle => 'Masuk untuk melanjutkan perjalananmu.';

  @override
  String get authLoginButton => 'Masuk';

  @override
  String get authJoinTitle => 'Bergabung dengan Hable.';

  @override
  String get authJoinSubtitle =>
      'Pilih nama pengguna dan kata sandi. You can activate cloud recovery from Profil later.';

  @override
  String get authSignUpButton => 'Daftar';

  @override
  String get authResetTitle => 'Atur Ulang Kata Sandi';

  @override
  String get authResetSubtitle =>
      'Masukkan email untuk menerima PIN verifikasi.';

  @override
  String get authSendPinButton => 'Kirim PIN';

  @override
  String get authVerifyTitle => 'Verifikasi PIN';

  @override
  String get authVerifySubtitle =>
      'Masukkan PIN yang dikirim ke emailmu dan kata sandi baru.';

  @override
  String get authResetSuccessMessage =>
      'Kata sandi berhasil diatur ulang. Silakan masuk.';

  @override
  String get authUsernameLabel => 'Nama Pengguna';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPinLabel => 'PIN 6 digit';

  @override
  String get authPasswordLabel => 'Kata Sandi';

  @override
  String get authNewPasswordLabel => 'Kata Sandi Baru';

  @override
  String get authForgotPassword => 'Lupa Kata Sandi?';

  @override
  String get authWorking => 'Memproses...';

  @override
  String get authNeedAccount => 'Belum punya akun? Daftar';

  @override
  String get authAlreadyHaveAccount => 'Sudah punya akun? Masuk';

  @override
  String get authBackToLogin => 'Kembali ke Masuk';

  @override
  String get authGdprFooter =>
      'Hable mematuhi persyaratan perlindungan data Eropa, termasuk GDPR.';

  @override
  String get onboardingDayOneEyebrow => 'Hari pertama';

  @override
  String get onboardingDayOneTitle => 'Setiap hari adalah hari pertama.';

  @override
  String get onboardingDayOneBody =>
      'Mulai dengan bacaan yang tenang, lalu satu tindakan yang disengaja. Hable menjaga langkah pertama tetap kecil agar mudah diulang.';

  @override
  String get onboardingMudEyebrow => 'Lumpur';

  @override
  String get onboardingMudTitle => 'Mulailah melewati lumpur.';

  @override
  String get onboardingMudBody =>
      'Kebiasaan baru memerlukan tekanan stabil selama 1500 ms. Resistansi itu memang disengaja: usaha dulu, kestabilan kemudian.';

  @override
  String get onboardingCommitEyebrow => 'Komitmen';

  @override
  String get onboardingCommitTitle => 'Pilih komitmen pertamamu.';

  @override
  String get onboardingCommitBody =>
      'Pilih kebiasaan standar atau tentukan jumlah harimu sendiri. The science-backed 21, 33, and 40 day targets stay close by.';

  @override
  String get onboardingPartnersEyebrow => 'Mitra';

  @override
  String get onboardingPartnersTitle => 'Ajak seorang mitra.';

  @override
  String get onboardingPartnersBody =>
      'Kebiasaan bersama menampilkan progres mitra melalui cincin berwarna kebiasaan, sehingga dukungan hadir langsung di kartu kebiasaan.';

  @override
  String get onboardingRemindersEyebrow => 'Pengingat';

  @override
  String get onboardingRemindersTitle => 'Biarkan pengingat tetap lembut.';

  @override
  String get onboardingRemindersBody =>
      'Hable akan bertanya sebelum menjadwalkan. Aktifkan pengingat hanya saat kamu menginginkan dorongan lembut, bukan tuntutan.';

  @override
  String get onboardingPrivacyEyebrow => 'Privasi';

  @override
  String get onboardingPrivacyTitle => 'Jaga refleksi tetap privat.';

  @override
  String get onboardingPrivacyBody =>
      'Email verification waits in Pengaturan, and journal reflections stay private. Mitra melihat progres, bukan catatanmu.';

  @override
  String get onboardingTrackerEyebrow => 'Pelacak';

  @override
  String get onboardingTrackerTitle => 'Tidak ada tombol lewati pada cincin.';

  @override
  String get onboardingTrackerBody =>
      'Pelacak utama dibuat untuk tindakan. Hari yang terlewat berakhir secara alami, while private reflection stays available when needed.';

  @override
  String get onboardingStartSetup => 'Mulai penyiapan';

  @override
  String get onboardingNext => 'Berikutnya';

  @override
  String get onboardingLogIn => 'Masuk';

  @override
  String get habitSkipToday => 'Lewati hari ini';

  @override
  String get habitSkippedToday => 'Dilewati hari ini';

  @override
  String get habitCompletedToday => 'Selesai hari ini';

  @override
  String get habitNotCompletedToday => 'Not selesai hari ini';

  @override
  String get habitFollowing => 'Mengikuti';

  @override
  String get habitContinuous => 'Berkelanjutan';

  @override
  String habitDayProgress(int day, int total) {
    return 'Hari $day dari $total';
  }

  @override
  String habitNudgedBy(String name) {
    return 'Didorong oleh $name';
  }

  @override
  String habitNudgeQueued(String name) {
    return 'Dorongan diantrekan untuk $name';
  }

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsAccountTitle => 'Akun';

  @override
  String get settingsUserId => 'ID Pengguna';

  @override
  String get settingsNoEmail => 'Belum ada email tertaut';

  @override
  String get settingsLogOut => 'Keluar';

  @override
  String get settingsCloudSync => 'Sinkronisasi Cloud';

  @override
  String get settingsEnableCloudSync => 'Aktifkan Sinkronisasi Cloud';

  @override
  String get settingsCloudSyncActive => 'Sinkronisasi cloud aktif.';

  @override
  String get settingsDailyReminder => 'Pengingat harian';

  @override
  String get settingsEnableDailyReminder => 'Aktifkan Pengingat Harian';

  @override
  String get settingsRemindMeAt => 'Ingatkan saya pada';

  @override
  String get settingsMudTuning => 'Penyetelan Lumpur';

  @override
  String get settingsMudTuningDesc =>
      'Sesuaikan resistansi dan rasa cincin penyelesaian kebiasaan.';

  @override
  String get settingsDuration => 'Durasi';

  @override
  String get settingsFast => 'Cepat';

  @override
  String get settingsSlow => 'Lambat';

  @override
  String get settingsResistance => 'Resistansi';

  @override
  String get settingsLight => 'Ringan';

  @override
  String get settingsHeavy => 'Berat';

  @override
  String get settingsHaptics => 'Haptik';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsAccessibility => 'Aksesibilitas';

  @override
  String get dashboardMyHabits => 'My Kebiasaans';

  @override
  String get dashboardAddHabit => 'Tambah Kebiasaan';

  @override
  String get dashboardNoHabits =>
      'Belum ada kebiasaan. Ketuk + untuk memulai tantangan pertamamu.';

  @override
  String get appGateRestoredLocalSession => 'Sesi lokal di macOS dipulihkan.';

  @override
  String get appGateUpdatingHable => 'Memperbarui Hable...';

  @override
  String get appGateRestoringSession => 'Memulihkan sesi...';

  @override
  String get appGatePreparingHabits => 'Menyiapkan kebiasaanmu...';

  @override
  String get appGateLoadingProfileState => 'Memuat status profil...';

  @override
  String get appStartupOpening => 'Membuka Hable';

  @override
  String skipSheetTitle(String habitTitle) {
    return 'Melewati \"$habitTitle\"';
  }

  @override
  String get skipSheetBody =>
      'This will add +2 hari to your journey. Tulis catatan jurnal singkat untuk melanjutkan.';

  @override
  String get skipSheetHint => 'Mengapa kamu melewatkan hari ini?';

  @override
  String get skipSheetConfirm => 'Konfirmasi Lewati';

  @override
  String get mudCompleteHabitLabel => 'Selesaikan Kebiasaan';

  @override
  String get mudLongPressHint => 'Tekan lama untuk menyelesaikan';

  @override
  String get mudDone => 'Selesai!';

  @override
  String get mudHoldToComplete => 'Tahan untuk Menyelesaikan';

  @override
  String get socialSyncNow => 'Sinkronkan sekarang';

  @override
  String get socialFindFriends => 'Cari teman';

  @override
  String get partnerSectionTitle => 'Mitra';

  @override
  String get partnerTickerStateNotCompletedYet => 'belum selesai';

  @override
  String partnerTickerProfileSemantics(String name, String state) {
    return '$name, $state. Membuka profil.';
  }

  @override
  String get partnerNoPartnersYet => 'Belum ada mitra pada kebiasaan ini.';

  @override
  String get partnerNoPartnersShort => 'No mitras';

  @override
  String partnerStackCollapsedSemantics(int count) {
    return 'Partner stack. $count total. Long press to expand mitra states.';
  }

  @override
  String get partnerExpandedSemantics =>
      'Expanded mitra states. Ketuk untuk menciutkan. Each row shows completion, pending, or didorong state.';

  @override
  String get partnerTapToCollapse => 'Ketuk untuk menciutkan';

  @override
  String get partnerStateCompleted => 'selesai';

  @override
  String get partnerStateNudged => 'didorong';

  @override
  String get partnerStateSupporter => 'pendukung';

  @override
  String get partnerStatePending => 'menunggu';

  @override
  String get partnerStateCompletedToday => 'selesai hari ini';

  @override
  String get partnerStateSupporting => 'mendukung';

  @override
  String partnerStatusSemantics(String name, String state) {
    return 'status $name: $state';
  }

  @override
  String get partnerRoleOwner => 'pemilik';

  @override
  String get partnerRolePartner => 'mitra';

  @override
  String get partnerRoleSupporter => 'pendukung';

  @override
  String partnerProfileSemantics(String name, String role, String state) {
    return '$name, $role, $state. Membuka profil.';
  }

  @override
  String partnerNudgeSemantics(String name) {
    return 'Dorong $name on this habit.';
  }

  @override
  String partnerNudgeTooltip(String name) {
    return 'Dorong $name';
  }

  @override
  String get habitFormChooseIconTitle => 'Pilih ikon';

  @override
  String get habitFormChooseIconBody =>
      'Kebiasaan khusus dapat menggunakan ikon ini bersama judulnya.';

  @override
  String get habitFormSaveFailed =>
      'That habit did not stick yet. Silakan coba lagi.';

  @override
  String get habitFormPresetDescriptionFallback =>
      'Beri nama perilaku dengan jelas agar kamu dapat memahaminya sekilas di masa depan.';

  @override
  String get habitFormCreateButton => 'Buat kebiasaan';

  @override
  String get habitFormSaveChangesButton => 'Simpan perubahan';

  @override
  String get habitFormCreateTitle => 'Bangun kebiasaan yang layak diulang';

  @override
  String get habitFormEditTitle => 'Sempurnakan kebiasaan ini';

  @override
  String get habitFormCreateBody =>
      'Pilih nama, tentukan durasi tantangan, lalu mulai dengan rapi.';

  @override
  String get habitFormEditBody =>
      'Sesuaikan judul, linimasa, dan warna tanpa mengatur ulang progresmu.';

  @override
  String get habitFormNameLabel => 'Kebiasaan name';

  @override
  String get habitFormNameHint =>
      'Halaman pagi, tanpa ponsel setelah pukul 10, jalan kaki setiap hari...';

  @override
  String get habitFormNameHelper =>
      'Ketuk ikon di sebelah kiri untuk mempersonalisasi kebiasaan khusus.';

  @override
  String get habitFormNameErrorEmpty => 'Beri kebiasaan ini nama yang jelas.';

  @override
  String get habitFormNameErrorShort => 'Gunakan setidaknya 3 karakter.';

  @override
  String get habitFormPresetTitle => 'Mulai dari pola yang terbukti';

  @override
  String get habitFormPresetBody =>
      'Pilih templat untuk mengisi judul, durasi, warna, dan teks pengingat.';

  @override
  String get habitFormDescriptionTitle => 'Deskripsi';

  @override
  String get habitFormDescriptionBody =>
      'Use one or two lines to make the habit specific enough to repeat on rough hari.';

  @override
  String get habitFormDescriptionHelper =>
      'Deskripsi ini dapat muncul di kartu kebiasaan utama.';

  @override
  String get habitFormDescriptionErrorLong =>
      'Jaga deskripsi di bawah 160 karakter.';

  @override
  String get habitFormDurationTitle => 'Durasi';

  @override
  String get habitFormDurationBody =>
      'Default is 21 hari. Use anchors for the usual milestones or slide for any finite plan.';

  @override
  String habitFormDurationChip(int days) {
    return '$days hari';
  }

  @override
  String get habitFormCustomDaysLabel => 'Custom number of hari';

  @override
  String get habitFormDurationErrorInvalid => 'Enter a number of hari.';

  @override
  String get habitFormDurationErrorMin => 'Durasi harus setidaknya 1 hari.';

  @override
  String get habitFormColorTitle => 'Warna cincin';

  @override
  String get habitFormColorBody =>
      'Pilih warna yang akan digunakan kebiasaan ini pada kartu dan perayaannya.';

  @override
  String get habitFormPartnersTitle => 'Undang mitra';

  @override
  String get habitFormPartnersBody =>
      'Kebiasaan bersamas can start with friends who already follow you.';

  @override
  String get habitFormNoFriends =>
      'Teman tidak ditemukan. Add friends from the Social tab first.';

  @override
  String get habitFormFriendsLoadFailed =>
      'Hable tidak dapat memuat your friend list right now.';

  @override
  String get homeCreateHabitSemantics => 'Buat kebiasaan baru';

  @override
  String get homeCreateHabitCta => 'Kebiasaan';

  @override
  String get homeLoadFailed =>
      'Hable tidak dapat memuat today\'s habits right now.';

  @override
  String get homeFriendFallback => 'Teman';

  @override
  String get homeOpenDashboard => 'Buka dasbor';

  @override
  String get homeOpenNotifications => 'Buka notifikasi';

  @override
  String get homeNoHabits => 'Belum ada kebiasaan aktif.\nStart one from Home.';

  @override
  String get homeAddHabit => 'Tambah kebiasaan';

  @override
  String get homeGreetingMorning => 'Selamat pagi';

  @override
  String get homeGreetingAfternoon => 'Selamat siang';

  @override
  String get homeGreetingEvening => 'Selamat malam';

  @override
  String get homeSuggestedHabits => 'Kebiasaan yang Disarankan';

  @override
  String get profileBack => 'Kembali';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileOpenSettings => 'Buka pengaturan';

  @override
  String get profileUserFallback => 'Pengguna';

  @override
  String get profileUsernameFallback => 'pengguna';

  @override
  String get profileLevelFallback => 'Pemula';

  @override
  String profileLifetimePoints(int points) {
    return '$points poin seumur hidup';
  }

  @override
  String get profileLifetimeScoreHint =>
      'Skor seumur hidup comes from backend sync. Journey and history show per-check-in awards.';

  @override
  String get profileTrophyRoomTab => 'Ruang Trofi';

  @override
  String get profileJourneyTab => 'Perjalanan';

  @override
  String get profileAchievementsTitle => 'Pencapaian';

  @override
  String get profileFirstBadgeHint =>
      'Selesaikan kebiasaan untuk mendapatkan lencana pertamamu!';

  @override
  String get profileHabitDistributionTitle => 'Kebiasaan Distribution';

  @override
  String get profileNoData => 'Belum ada data';

  @override
  String get profileCompletedLegend => 'Selesai';

  @override
  String get profileSkippedLegend => 'Dilewati';

  @override
  String get profileOverdueLegend => 'Terlambat';

  @override
  String get profileThirtyDayPointsTitle => 'Poin yang Diperoleh dalam 30 Hari';

  @override
  String get profileThirtyDayPointsHint =>
      'Per-check-in awards from local history. Skor seumur hidup updates separately from daily sync.';

  @override
  String get profileCalendarSubscriptionTitle => 'Langganan Kalender';

  @override
  String get profileCalendarSubscriptionBody =>
      'Tambahkan kebiasaanmu ke aplikasi kalender perangkat';

  @override
  String get profileManageHabitsTitle => 'Kelola Kebiasaan';

  @override
  String get profileAddNew => 'Tambah Baru';

  @override
  String get profileSectionActive => 'Aktif';

  @override
  String get profileSectionHallOfFame => 'Hall of Fame';

  @override
  String get profileSectionArchivedHistory => 'Riwayat yang Diarsipkan';

  @override
  String get profileFriendProfileTitle => 'Profil Teman';

  @override
  String profileFriendLevel(String level) {
    return 'level $level';
  }

  @override
  String get profileActiveHabitsTitle => 'Active Kebiasaans';

  @override
  String get profileNoActiveHabits => 'Tidak ada kebiasaan aktif.';

  @override
  String get profileFriendLoadFailed => 'Gagal memuat profil teman.';

  @override
  String get dashboardTitle => 'Dasbor Kebiasaan';

  @override
  String get dashboardAchievementUnlocked => 'Kamu membuka lencana baru!';

  @override
  String get dashboardLoadFailed =>
      'Hable tidak dapat memuat this habit dashboard right now.';

  @override
  String get dashboardEmptyState =>
      'Belum ada kebiasaan aktif. Create one from Home to see it here.';

  @override
  String get dashboardSummaryTitle => 'Ringkasan Dasbor';

  @override
  String get dashboardActiveHabitsLabel => 'Kebiasaan aktif';

  @override
  String get dashboardChallengeHabitsLabel => 'Kebiasaan tantangan';

  @override
  String get dashboardContinuousHabitsLabel => 'Kebiasaan berkelanjutan';

  @override
  String get dashboardQuoteOfDayTitle => 'Kutipan hari ini';

  @override
  String get dashboardQuoteLoading => 'Memuat kutipan...';

  @override
  String get dashboardQuoteFallback =>
      'Teruskan. Dasbor tersedia saat kamu membutuhkan tampilan lengkap.';

  @override
  String get notificationTitle => 'Notifikasi';

  @override
  String get notificationMarkAllRead => 'Tandai semua sudah dibaca';

  @override
  String get notificationEmptyTitle => 'Belum ada notifikasi';

  @override
  String get notificationEmptyBody =>
      'Permintaan pertemanan, undangan, dorongan, dan pembaruan pengingat akan muncul di sini.';

  @override
  String get notificationToday => 'Hari ini';

  @override
  String get notificationYesterday => 'Kemarin';

  @override
  String get notificationOlder => 'Lebih lama';

  @override
  String get notificationLoadFailed =>
      'Hable tidak dapat memuat your notifications right now.';

  @override
  String get notificationJustNow => 'Baru saja';

  @override
  String notificationMinutesAgo(int minutes) {
    return '$minutes m lalu';
  }

  @override
  String notificationHoursAgo(int hours) {
    return '$hours jam lalu';
  }

  @override
  String notificationDaysAgo(int days) {
    return '$days hari lalu';
  }

  @override
  String get settingsSessionTitle => 'Sesi';

  @override
  String get settingsSessionBody =>
      'Keluar of this device. Local reminder scheduling is canceled for this user.';

  @override
  String get settingsRecoverTitle => 'Pulihkan Perangkat Ini';

  @override
  String get settingsRecoverBody =>
      'Ini akan menghapus data Hable lokal di perangkat ini dan mengembalikanmu ke halaman masuk. Gunakan jika aplikasi macet atau menampilkan data cache lama.';

  @override
  String get settingsCancel => 'Batal';

  @override
  String get settingsClearAndSignInAgain => 'Hapus dan Masuk Lagi';

  @override
  String get settingsRecoverAction => 'Perbarui / Pulihkan Aplikasi';

  @override
  String get settingsSignOut => 'Keluar';

  @override
  String get commonAccept => 'Terima';

  @override
  String get commonDecline => 'Tolak';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonRemove => 'Hapus';

  @override
  String get commonRetry => 'Coba lagi';

  @override
  String get commonYou => 'Kamu';

  @override
  String get socialActivityUnread => 'Belum dibaca';

  @override
  String get socialActivityEarlier => 'Sebelumnya';

  @override
  String get socialSearchFailed =>
      'Hable tidak dapat mencari teman saat ini. Silakan coba lagi.';

  @override
  String get socialFriendRequestSendFailed =>
      'Hable tidak dapat mengirim permintaan pertemanan saat ini.';

  @override
  String get socialFriendRequestAcceptFailed =>
      'Hable tidak dapat menerima permintaan itu saat ini.';

  @override
  String get socialFriendRequestDeclineFailed =>
      'Hable tidak dapat menolak permintaan itu saat ini.';

  @override
  String get socialFriendRevokeFailed =>
      'Hable tidak dapat memperbarui pertemanan itu saat ini.';

  @override
  String socialFriendRequestAlreadyFriends(String username) {
    return 'Kamu sudah berteman dengan $username.';
  }

  @override
  String socialFriendRequestIncomingExists(String username) {
    return '$username already sent you a request. Periksa Permintaan.';
  }

  @override
  String socialFriendRequestSent(String username) {
    return 'Permintaan pertemanan terkirim ke $username.';
  }

  @override
  String socialFriendAccepted(String username) {
    return 'Kamu sekarang berteman dengan $username!';
  }

  @override
  String socialFriendDeclined(String username) {
    return 'Permintaan dari $username.';
  }

  @override
  String socialFriendRemoved(String username) {
    return 'Menghapus $username from friends.';
  }

  @override
  String get socialFriendActionsUnfriend => 'Hapus pertemanan';

  @override
  String get socialFriendActionsRemoveTitle => 'Hapus teman?';

  @override
  String socialFriendActionsRemoveBody(String username) {
    return 'Hapus $username dari daftar temanmu?';
  }

  @override
  String get socialNoFriendsTitle => 'Belum ada teman';

  @override
  String get socialNoFriendsBody =>
      'Ketuk ikon pencarian di atas to find and add friends.';

  @override
  String get socialFriendLongPressActions =>
      'Tekan lama untuk melihat tindakan';

  @override
  String get socialFriendsLoadFailed =>
      'Hable tidak dapat memuat your friends right now.';

  @override
  String get socialNotSignedIn => 'Belum masuk';

  @override
  String get socialNoActivityTitle => 'Belum ada aktivitas';

  @override
  String get socialNoActivityBody =>
      'Dorongan, permintaan pertemanan, undangan, dan pesan dari teman akan muncul di sini.';

  @override
  String get socialLeaderboardEmpty => 'Belum ada skor papan peringkat.';

  @override
  String get socialLeaderboardNoValidScores =>
      'Tidak ada skor papan peringkat yang valid.';

  @override
  String get socialLeaderboardTitle => 'Papan Peringkat Teman';

  @override
  String get socialLeaderboardSubtitle =>
      'Teman yang diterima diurutkan berdasarkan skor seumur hidup';

  @override
  String get socialLeaderboardScopeFriends => 'Teman';

  @override
  String get socialLeaderboardLoadTitle => 'Papan peringkat tidak dapat dimuat';

  @override
  String get socialLeaderboardLoadFailed =>
      'Hable tidak dapat memuat the leaderboard right now.';

  @override
  String get socialFriendRequestsTitle => 'Permintaan Pertemanan';

  @override
  String get socialFriendRequestIncomingSubtitle =>
      'Mengirimkan permintaan pertemanan kepadamu';

  @override
  String get socialFindFriendsTitle => 'Cari Teman';

  @override
  String get socialFindFriendsSearchLabel => 'Cari nama pengguna...';

  @override
  String get socialFindFriendsTypeMore =>
      'Ketik setidaknya 2 karakter untuk mencari.';

  @override
  String get socialFindFriendsNoMatches => 'Tidak ada hasil yang cocok.';

  @override
  String get socialRelationshipAcceptedFriend => 'Teman yang diterima';

  @override
  String get socialRelationshipRequestSent => 'Permintaan terkirim';

  @override
  String get socialRelationshipWaiting => 'Menunggu jawabanmu';

  @override
  String get socialRelationshipNotConnected => 'Belum terhubung';

  @override
  String get socialChipFriends => 'Teman';

  @override
  String get socialChipRequested => 'Diminta';

  @override
  String get socialChipRespondInFriends => 'Tanggapi di Teman';

  @override
  String get socialSendFriendRequestTooltip => 'Kirim permintaan pertemanan';

  @override
  String habitCompletionProgressSemantics(int percent) {
    return 'Progres penyelesaian $percent persen.';
  }

  @override
  String get leaderboardRankingsTitle => 'Peringkat';

  @override
  String leaderboardShowMore(int count) {
    return 'Tampilkan $count lagi';
  }

  @override
  String leaderboardShowingAll(int count) {
    return 'Menampilkan semua $count';
  }

  @override
  String get leaderboardYou => 'Kamu';

  @override
  String get leaderboardUnknownUser => 'Tidak dikenal';

  @override
  String get leaderboardLifetime => 'seumur hidup';

  @override
  String get leaderboardLifetimeScoreByline => 'Skor seumur hidup';

  @override
  String get settingsNoVerifiedEmailYet => 'Belum ada email terverifikasi';

  @override
  String get settingsCustomizeAvatar => 'Sesuaikan avatar';

  @override
  String get settingsMudFeelTitle => 'Rasa lumpur';

  @override
  String get settingsMudFeelBody =>
      'Atur resistansi tahanan dan umpan balik haptik di perangkat ini dengan preset terbatas.';

  @override
  String get settingsMudPresetGentle => 'Lembut';

  @override
  String get settingsMudPresetStandard => 'Standar';

  @override
  String get settingsMudPresetIntense => 'Intens';

  @override
  String get settingsMudHapticsTitle => 'Haptik lumpur';

  @override
  String get settingsMudHapticsSoft =>
      'Ketukan lembut saat menahan dan denyut penyelesaian ringan.';

  @override
  String get settingsMudHapticsStandard =>
      'Ketukan tahanan seimbang dan umpan balik penyelesaian standar.';

  @override
  String get settingsMudHapticsStrong =>
      'Umpan balik penyelesaian lebih kuat dengan ketukan tahanan yang lebih rapat.';

  @override
  String get settingsVerificationPinSent => 'PIN verifikasi terkirim.';

  @override
  String get settingsCloudSyncActivated => 'Sinkronisasi cloud diaktifkan.';

  @override
  String get settingsCloudSyncActiveTitle => 'Sinkronisasi cloud aktif';

  @override
  String get settingsActivateCloudSyncTitle => 'Aktifkan sinkronisasi cloud';

  @override
  String settingsCloudSyncLinkedToEmail(String email) {
    return 'Pemulihan progres tertaut ke $email.';
  }

  @override
  String get settingsCloudSyncInactiveBody =>
      'Tambahkan email terverifikasi saat kamu ingin progres cloud yang dapat dipulihkan dan dukungan pengaturan ulang kata sandi.';

  @override
  String get settingsChangeEmail => 'Ubah email';

  @override
  String get settingsDailyRemindersTitle => 'Pengingat harian';

  @override
  String get settingsDailyRemindersEmpty =>
      'Aktifkan pengingat harian untuk kembali ke kebiasaanmu.';

  @override
  String get settingsDailyRemindersEnabled =>
      'Hable akan mengingatkanmu setiap hari at these times.';

  @override
  String get settingsEnableInSystemSettings => 'Aktifkan di Pengaturan Sistem';

  @override
  String get settingsAddTime => 'Tambah Waktu';

  @override
  String get settingsStatusActive => 'Aktif';

  @override
  String get settingsStatusSaved => 'Tersimpan';

  @override
  String get settingsStatusOn => 'Aktif';

  @override
  String get settingsStatusOff => 'Nonaktif';

  @override
  String get settingsReminderUnsupported =>
      'Penjadwalan pengingat tidak tersedia di platform ini.';

  @override
  String get settingsRemindersBlocked =>
      'Notifikasi diblokir. Aktifkan di Pengaturan Sistem.';

  @override
  String get settingsRemoveReminderTooltip => 'Hapus pengingat';

  @override
  String get settingsRemindersLoadFailed =>
      'Hable tidak dapat memuat your reminders right now.';

  @override
  String get profileHabitFallbackTitle => 'Kebiasaan';

  @override
  String profileDaysLabel(int days) {
    return '$days hari';
  }

  @override
  String profileDaysLeft(int days) {
    return '$days hari tersisa';
  }

  @override
  String profileDayChallenge(int days) {
    return '$days hari tantangan';
  }

  @override
  String get profileFriendHabitBody =>
      'Semangati temanmu atau ikuti kebiasaan yang sama.';

  @override
  String profileEncouragementQueued(String title) {
    return 'Semangat diantrekan untuk $title.';
  }

  @override
  String get profileEncourage => 'Semangati';

  @override
  String get profileFollow => 'Ikuti';

  @override
  String get profileAchievementFirstCheckIn => 'Check-in pertama';

  @override
  String get profileAchievementTenStreak => 'streak 10 hari';

  @override
  String get profileAchievementHundredStreak => 'streak 100 hari';

  @override
  String get profileAchievementThousandStreak => 'streak 1000 hari';

  @override
  String get profileAchievementFirstNudge => 'Dorongan pertama';

  @override
  String get profileAchievementFirstSupporter => 'First pendukung';

  @override
  String get profileSharedHabit => 'Kebiasaan bersama';

  @override
  String get profileSoloHabit => 'Kebiasaan pribadi';

  @override
  String get profileOpenHabitActions => 'Buka tindakan kebiasaan';

  @override
  String get profileDeleteHabitTitle => 'Hapus kebiasaan?';

  @override
  String profileDeleteHabitBody(String title) {
    return 'Ini akan menghapus \"$title\" secara permanen dan menghapusnya dari perangkat yang tersinkron.';
  }

  @override
  String get profileArchive => 'Arsipkan';

  @override
  String get profileViewHistory => 'Lihat Riwayat';

  @override
  String get profileRerun => 'Jalankan lagi';

  @override
  String get profileRoleOwnerView => 'Tampilan pemilik';

  @override
  String get profileRolePartnerView => 'Tampilan mitra';

  @override
  String get profileRoleSupporterView => 'Tampilan pendukung';

  @override
  String get profileHistoryIntro =>
      'Riwayat tantangan yang diarsipkan dan penghargaan setiap check-in';

  @override
  String get profileNoHistoryYet => 'Belum ada riwayat yang tercatat.';

  @override
  String profilePointsAwarded(int points) {
    return '+$points poin';
  }

  @override
  String get profileUnableLoadHistory =>
      'Tidak dapat memuat riwayat kebiasaan.';

  @override
  String get profileHistoryCompleted => 'Selesai';

  @override
  String profileHistorySkippedWithNote(String note) {
    return 'Dilewati: $note';
  }

  @override
  String get profileHistorySkipped => 'Dilewati';

  @override
  String get profileCalendarUnknownError => 'Kesalahan tidak dikenal';

  @override
  String get profileCalendarGenerateLink => 'Buat Tautan Langganan';

  @override
  String get profileCalendarSubscriptionUrl => 'URL Langganan';

  @override
  String get profileCalendarCopied =>
      'URL umpan kalender disalin ke papan klip';

  @override
  String get profileCalendarCopyTooltip => 'Salin URL langganan';

  @override
  String get profileCalendarPasteHint =>
      'Tempel URL ini ke aplikasi kalender perangkatmu untuk berlangganan';

  @override
  String get profileCalendarRotateToken => 'Putar Token';

  @override
  String get profileCalendarRotateHint =>
      'Memutar token akan membatalkan tautan langganan lama';

  @override
  String get accessibilityReducedMotionTitle => 'Gerakan Dikurangi';

  @override
  String get accessibilityReducedMotionBody =>
      'Nonaktifkan animasi dan transisi';

  @override
  String get accessibilityHighContrastTitle => 'Kontras Tinggi';

  @override
  String get accessibilityHighContrastBody =>
      'Tingkatkan kontras warna agar lebih mudah dibaca';

  @override
  String get accessibilityLargerTextTitle => 'Teks Lebih Besar';

  @override
  String get accessibilityLargerTextBody => 'Tingkatkan skala teks global';

  @override
  String get webPushEnabled => 'Pengingat web aktif untuk browser ini.';

  @override
  String get webPushUnavailable =>
      'Pengingat web tidak tersedia atau izin ditolak.';

  @override
  String get webPushEnabling => 'Mengaktifkan pengingat web...';

  @override
  String get webPushEnable => 'Aktifkan pengingat web';

  @override
  String get socialJointCompletion =>
      'Penyelesaian bersama untuk kebiasaan ini telah dicatat.';

  @override
  String get completionContinue => 'Lanjutkan';
}
