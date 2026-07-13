import 'package:get/get_navigation/src/routes/get_route.dart';
import '../screen/splash/splash_screen.dart';
import '../screen/auth/login_screen.dart';
import '../screen/home/home_screen.dart';

import 'app_route.dart';


class AppPages {

  static final pages = [

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),


    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),


    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
    ),

  ];

}