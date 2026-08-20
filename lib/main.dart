import 'package:appchat/route/app_pages.dart';
import 'package:appchat/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_binding.dart';
import 'controllers/notification/notification_controller.dart';
import 'controllers/settings/settings_controller.dart';
import 'core/localization/app_translation.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize local storage
  await GetStorage.init();

  // 2. IMPORTANT: Manually initialize all services/bindings first
  // This ensures AuthApiService is available before SettingsController starts
  AppBinding().dependencies();

  // 3. Register high-level controllers needed for the app shell
  Get.put<SettingsController>(
    SettingsController(),
    permanent: true,
  );

  Get.put<NotificationController>(
    NotificationController(),
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the settings controller to react to theme/locale changes
    final SettingsController settingsController = Get.find<SettingsController>();

    return Obx(
          () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pii Chat',
        translations: AppTranslations(),
        locale: settingsController.currentLocale,
        fallbackLocale: const Locale('en', 'US'),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: settingsController.themeMode.value,
        // Bindings are already loaded in main, but keeping this is fine for deep-linking
        initialBinding: AppBinding(),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}
