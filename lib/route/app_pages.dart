import 'package:appchat/screen/chat_detail/chat_detail_screen.dart';
import 'package:appchat/screen/settings/setting_screen.dart';
import 'package:get/get.dart';

import '../controllers/chat/chat_controller.dart';
import '../controllers/contact/qr_contact_scanner_controller.dart';
import '../controllers/settings/settings_search_controller.dart';
import '../models/chat_model.dart';
import '../screen/auth/login_screen.dart';
import '../screen/contact/qr_scan/qr_contact_scanner_binding.dart';
import '../screen/contact/qr_scan/qr_contact_scanner_screen.dart';
import '../screen/home/home_screen.dart';
import '../screen/home/save/save_message_screen.dart';
import '../screen/home/search/search_screen.dart';
import '../screen/profile/profile_detail_screen.dart';
import '../screen/profile/profile_edit_screen.dart';
import '../screen/settings/settings_search_screen.dart';
import '../screen/splash/splash_screen.dart';
import '../screen/testing/phone_input_screen.dart';
import 'app_route.dart';

/// Central registry of every named route in the app.
///
/// Each entry maps a route name (from [AppRoutes]) to:
/// - the screen widget to build,
/// - an optional [binding] to set up controllers/dependencies
///   right before the screen is shown,
/// - and a page transition animation.
///
/// To navigate: `Get.toNamed(AppRoutes.someRoute)`.
class AppPages {
  static final List<GetPage<dynamic>> pages = [
    // ── Splash ──────────────────────────────────────────────
    // First screen shown on app launch (loading/branding screen).
    // No transition — it's the entry point, nothing to animate from.
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),

    // ── Login ───────────────────────────────────────────────
    // Authentication screen. Fades in after splash.
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // ── Home ────────────────────────────────────────────────
    // Main screen after login — holds the Chats / Contacts tabs.
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // ── Settings ────────────────────────────────────────────
    // App settings screen (account, notifications, privacy, etc).
    // Cupertino transition = iOS-style slide-in from the right.
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 280,
      ),
    ),

    // ── QR Contact Scanner ──────────────────────────────────
    // Scans a QR code to add a new contact.
    // Has its own binding to set up QrContactScannerController
    // only while this screen is active (auto-disposed after).
    GetPage(
      name: AppRoutes.qrScanner,
      page: () => QrContactScannerScreen(),
      binding: QrContactScannerBinding(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 280,
      ),
    ),

    // ── Settings Search ─────────────────────────────────────
    // Search bar for finding a specific setting quickly.
    GetPage(
      name: AppRoutes.settingsSearch,
      page: () => SettingsSearchScreen(),
      binding: SettingsSearchBinding(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 280,
      ),
    ),

    // ── Profile Detail ──────────────────────────────────────
    // View-only screen showing the current user's profile info.
    GetPage(
      name: AppRoutes.profileDetail,
      page: () => ProfileDetailScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 280,
      ),
    ),

    // ── Edit Profile ────────────────────────────────────────
    // Editable form for changing name, avatar, bio, etc.
    GetPage(
      name: AppRoutes.editProfile,
      page: () => ProfileEditScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // ── Search Chats ────────────────────────────────────────
    // Full-screen search over the chat list.
    // Reuses the existing ChatController instance (must already
    // be registered via Get.put/Get.find before this route opens,
    // otherwise Get.find<ChatController>() will throw).
    GetPage(
      name: AppRoutes.searchChats,
      page: () => SearchScreen(
        controller: Get.find<ChatController>(),
      ),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    GetPage(
      name: AppRoutes.savedMessages,
      page: () => SavedMessagesScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 280),
    ),

    // ── Testing / Dev screen ────────────────────────────────
    // Phone number input screen — likely used for testing the
    // auth/OTP flow in isolation. Consider removing before release.
    GetPage(
      name: AppRoutes.testing,
      page: () => PhoneInputScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // NOTE: ChatDetailScreen is intentionally NOT registered as a
    // named route. It's opened directly via Get.to() (see ChatTile
    // and ContactController.openContact), passing the ChatModel
    // straight into the constructor instead of through Get.arguments.
    // Keep it that way — a named route here previously caused a
    // crash (`chat: null`) because Get.arguments wasn't being read.
  ];
}