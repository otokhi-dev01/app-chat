import 'package:appchat/screen/settings/setting_screen.dart';
import 'package:get/get.dart';
import '../controllers/chat/chat_controller.dart';
import '../controllers/profile/delete_account_controller.dart';
import '../controllers/settings/settings_search_controller.dart';
import '../screen/auth/auth_binding.dart';
import '../screen/auth/login/login_screen.dart';
import '../screen/auth/phone_input/phone_input_screen.dart';
import '../screen/auth/register/register_screen.dart';
import '../screen/auth/reset_password/reset_password_screen.dart';
import '../screen/auth/verify_otp/verity_otp_screen.dart';
import '../screen/chat_detail/call/call_screen.dart';
import '../screen/contact/add_contact/add_contact_screen.dart';
import '../screen/contact/add_group/add_group_binding.dart';
import '../screen/contact/add_group/add_group_screen.dart';
import '../screen/contact/blocked_contacts/blocked_contact_binding.dart';
import '../screen/contact/blocked_contacts/blocked_contact_screen.dart';
import '../screen/contact/contact_binding.dart';
import '../screen/contact/contact_screen.dart';
import '../screen/contact/qr_scan/qr_contact_scanner_binding.dart';
import '../screen/contact/qr_scan/qr_contact_scanner_screen.dart';
import '../screen/home/home_binding.dart';
import '../screen/home/home_screen.dart';
import '../screen/home/save/save_message_screen.dart';
import '../screen/home/search/search_screen.dart';
import '../screen/profile/delete_account/delete_account_screen.dart';
import '../screen/profile/details_profile/profile_detail_screen.dart';
import '../screen/profile/edit_profile/profile_edit_screen.dart';
import '../screen/profile/qr_code/profile_qr_code_screen.dart';
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
import '../services/auth_service /auth_service.dart';
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
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(
        milliseconds: 200, // Reduced to 200ms for snappier feel
      ),
    ),

    // Register
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // ForgotPassword

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // PhoneInput

    GetPage( name: AppRoutes.phoneInput,
      page: () => PhoneInputScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      )
    ),

    // ResetPassword
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // VerifyOtp
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => VerifyOtpScreen(
        destination:
        Get.arguments?['destination']?.toString() ?? '',
      ),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    GetPage(
      name: AppRoutes.deleteAccount,
      page: () => DeleteAccountView(),
      binding: BindingsBuilder(
            () {
          Get.lazyPut<DeleteAccountController>(
                () => DeleteAccountController(
              authService: Get.find<AuthService>(),
            ),
          );
        },
      ),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // ── Home ────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(
        milliseconds: 200, // Reduced to 200ms
      ),
    ),

    GetPage(
      name: AppRoutes.contacts,
      page: () => ContactScreen(),
      binding: ContactBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(
        milliseconds: 200, // Reduced to 200ms
      ),
    ),

    GetPage(
      name: AppRoutes.blockedContacts,
      page: () => BlockedContactsScreen(),
      binding: BlockedContactBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),




    // ── Settings ────────────────────────────────────────────
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 220, // Reduced from 280ms to 220ms
      ),
    ),

    GetPage(
      name: AppRoutes.devices,
      page: () => DevicesScreen(),
      binding: DeviceBinding(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 220, // Reduced to 220ms
      ),
    ),

    GetPage(
      name: AppRoutes.profileQrCode,
      page: () {
        Map<String, dynamic> arguments =
        Get.arguments is Map
            ? Map<String, dynamic>.from(
          Get.arguments as Map,
        )
            : <String, dynamic>{};

        return ProfileQrCodeScreen(
          name:
          arguments['name']?.toString() ??
              '',
          username:
          arguments['username']
              ?.toString() ??
              '',
        );
      },
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 200,
      ),
    ),

    GetPage(
      name: AppRoutes.call,
      page: () => CallScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 200,
      ),
    ),


    // ── QR Contact Scanner ──────────────────────────────────
    GetPage(
      name: AppRoutes.qrScanner,
      page: () => QrContactScannerScreen(),
      binding: QrContactScannerBinding(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
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
      transitionDuration: Duration(
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
      transitionDuration: Duration(
        milliseconds: 220, // Reduced to 220ms
      ),
    ),

    // ── Edit Profile ────────────────────────────────────────
    GetPage(
      name: AppRoutes.editProfile,
      page: () => ProfileEditScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 200, // Reduced to 200ms
      ),
    ),

    GetPage(
      name: AppRoutes.addContact,
      page: () {
        dynamic routeArguments = Get.arguments;

        Map<String, dynamic> arguments =
        routeArguments is Map
            ? Map<String, dynamic>.from(
          routeArguments,
        )
            : <String, dynamic>{};

        return AddContactScreen(
          name:
          arguments['name']?.toString() ??
              '',
          username:
          arguments['username']?.toString() ??
              '',
          phoneNumber:
          arguments['phoneNumber']
              ?.toString() ??
              '',
          imageUrl:
          arguments['imageUrl']?.toString() ??
              '',
        );
      },
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 220,
      ),
    ),

    // ── Search Chats ────────────────────────────────────────
    GetPage(
      name: AppRoutes.searchChats,
      page: () => SearchScreen(
        controller: Get.find<ChatController>(),
      ),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 280, // Reduced to 200ms
      ),
    ),

    GetPage(
      name: AppRoutes.savedMessages,
      page: () => SavedMessagesScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(
        milliseconds: 220, // Reduced to 220ms
      ),
    ),

  ];
}