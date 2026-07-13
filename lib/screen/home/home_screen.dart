import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../contact/contact_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/setting_screen.dart';
import '../widgets/main_buttom_navigation.dart';
import 'home_app_bar.dart';
import 'home_chat_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  late final PageController pageController;

  int selectedIndex = 0;

  final List<String> titles = const [
    'Chats',
    'Contacts',
    'Settings',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();

    pageController = PageController(
      initialPage: selectedIndex,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    if (index == selectedIndex) return;

    setState(() {
      selectedIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeChatList(controller: controller),
      const ContactScreen(),
      const SettingScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      // Important: body continues behind bottom navigation.
      extendBody: true,

      appBar: HomeAppBar(
        selectedIndex: selectedIndex,
        titles: titles,
        controller: controller,
      ),

      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          if (selectedIndex == index) return;

          setState(() {
            selectedIndex = index;
          });
        },
        children: screens,
      ),

      bottomNavigationBar: MainBottomNavigation(
        currentIndex: selectedIndex,
        onTap: changePage,
      ),
    );
  }
}