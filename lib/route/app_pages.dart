import 'package:get/get.dart';

import '../screen/auth/login_screen.dart';
import '../screen/home/home_screen.dart';
import '../screen/profile/profile_detail_screen.dart';
import '../screen/profile/profile_edit_screen.dart';
import '../screen/splash/splash_screen.dart';
import 'app_route.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),

    // GetPage(
    //   name: AppRoutes.profileDetail,
    //   page: () => ProfileDetailScreen(userId: null,),
    //   transition: Transition.cupertino,
    //   transitionDuration: Duration(
    //     milliseconds: 280,
    //   ),
    // ),

    GetPage(
      name: AppRoutes.editProfile,
      page: () => ProfileEditScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(
        milliseconds: 250,
      ),
    ),
  ];
}