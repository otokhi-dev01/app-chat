import 'package:appchat/screen/chat_detail/chat_detail_screen.dart';
import 'package:appchat/screen/settings/setting_screen.dart';
import 'package:get/get.dart';

import '../controllers/chat/chat_controller.dart';
import '../controllers/contact/qr_contact_scanner_controller.dart';
import '../controllers/settings/settings_search_controller.dart';
import '../models/chat_model.dart';
import '../screen/auth/login_screen.dart';
import '../screen/contact/add_group/add_group_binding.dart';
import '../screen/contact/add_group/add_group_screen.dart';
import '../screen/contact/qr_scan/qr_contact_scanner_binding.dart';
import '../screen/contact/qr_scan/qr_contact_scanner_screen.dart';
import '../screen/home/home_screen.dart';
import '../screen/home/save/save_message_screen.dart';
import '../screen/home/search/search_screen.dart';
import '../screen/profile/profile_detail_screen.dart';
import '../screen/profile/profile_edit_screen.dart';
import '../screen/settings/about/about_screen.dart';
import '../screen/settings/chat_folder/chat_folder_binding.dart';
import '../screen/settings/chat_folder/chat_folder_screen.dart';
import '../screen/settings/data_storage/data_storage_binding.dart';
import '../screen/settings/data_storage/data_storage_screen.dart';
import '../screen/settings/device/device_binding.dart';
import '../screen/settings/device/device_screen.dart';
import '../screen/settings/privacy_security/privacy_security_binding.dart';
import '../screen/settings/privacy_security/privacy_security_screen.dart';
import '../screen/settings/settings_search_screen.dart';
import '../screen/splash/splash_screen.dart';
import '../screen/testing/phone_input_screen.dart';
import 'app_route.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    // ── Splash ──────────────────────────────────────────────
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),

    // ── Login ───────────────────────────────────────────────
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(
        milliseconds: 200, // Reduced to 200ms for snappier feel
      ),
    ),

    // ── Home ────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(
        milliseconds: 200, // Reduced to 200ms
      ),
    ),

    // ── Settings ────────────────────────────────────────────
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(
        milliseconds: 220, // Reduced from 280ms to 220ms
      ),
    ),

    GetPage(
      name: AppRoutes.devices,
      page: () => DevicesScreen(),
      binding: DeviceBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(
        milliseconds: 220, // Reduced to 220ms
      ),
    ),

    // ── QR Contact Scanner ──────────────────────────────────
    GetPage(
      name: AppRoutes.qrScanner,
      page: () => QrContactScannerScreen(),
      binding: QrContactScannerBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(
        milliseconds: 220, // Reduced to 220ms
      ),
    ),

    GetPage(
      name: AppRoutes.addGroup,
      page: () => AddGroupScreen(),
      binding: AddGroupBinding(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // ── Settings Search ─────────────────────────────────────
    GetPage(
      name: AppRoutes.settingsSearch,
      page: () => SettingsSearchScreen(),
      binding: SettingsSearchBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(
        milliseconds: 220, // Reduced to 220ms
      ),
    ),

    GetPage(
      name: AppRoutes.privacySecurity,
      page: () =>
          PrivacySecurityScreen(),
      binding:
      PrivacySecurityBinding(),
      transition:
      Transition.cupertino,
      transitionDuration:
      Duration(
        milliseconds: 280,
      ),
    ),

    GetPage(
      name: AppRoutes.dataStorage,
      page: () => DataStorageScreen(),
      binding: DataStorageBinding(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 280,
      ),
    ),

    GetPage(
      name: AppRoutes.chatFolders,
      page: () => ChatFolderScreen(),
      binding: ChatFolderBinding(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 280,
      ),
    ),

    GetPage(
      name: AppRoutes.about,
      page: () => AboutScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 280,
      ),
    ),

    // ── Profile Detail ──────────────────────────────────────
    GetPage(
      name: AppRoutes.profileDetail,
      page: () => ProfileDetailScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(
        milliseconds: 220, // Reduced to 220ms
      ),
    ),

    // ── Edit Profile ────────────────────────────────────────
    GetPage(
      name: AppRoutes.editProfile,
      page: () => ProfileEditScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(
        milliseconds: 200, // Reduced to 200ms
      ),
    ),

    // ── Search Chats ────────────────────────────────────────
    GetPage(
      name: AppRoutes.searchChats,
      page: () => SearchScreen(
        controller: Get.find<ChatController>(),
      ),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(
        milliseconds: 200, // Reduced to 200ms
      ),
    ),

    GetPage(
      name: AppRoutes.savedMessages,
      page: () => SavedMessagesScreen(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(
        milliseconds: 220, // Reduced to 220ms
      ),
    ),

    // ── Testing / Dev screen ────────────────────────────────
    GetPage(
      name: AppRoutes.testing,
      page: () => PhoneInputScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(
        milliseconds: 200, // Reduced to 200ms
      ),
    ),
  ];
}