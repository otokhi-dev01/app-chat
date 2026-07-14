import 'package:appchat/route/app_pages.dart';
import 'package:appchat/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/settings_controller.dart';
import 'core/localization/app_translation.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<SettingsController>(
    SettingsController(),
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find<SettingsController>();

    return Obx(
          () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Telegram Clone',

        translations: AppTranslations(),
        locale: settingsController.currentLocale,
        fallbackLocale: Locale('en', 'US'),

        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: settingsController.themeMode.value,

        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}