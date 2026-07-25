import 'package:appchat/route/app_pages.dart';
import 'package:appchat/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/settings/settings_controller.dart';
import 'core/localization/app_translation.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  Get.put<SettingsController>(
    SettingsController(),
    permanent: true,
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController =
    Get.find<SettingsController>();

    return Obx(
          () {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AppChat',

          translations: AppTranslations(),
          locale: settingsController.currentLocale,
          fallbackLocale: Locale(
            'en',
            'US',
          ),

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode:
          settingsController.themeMode.value,

          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
        );
      },
    );
  }
}