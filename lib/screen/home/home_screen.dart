import 'package:appchat/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../contact/contact_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/setting_screen.dart';
import '../widgets/main_buttom_navigation.dart';
import 'home_app_bar.dart';
import 'home_chat_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late ChatController controller;

  int selectedIndex = 0;

  final List<String> titles = [
    'Chats',
    'Contacts',
    'Settings',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<ChatController>()) {
      controller = Get.find<ChatController>();
    } else {
      controller = Get.put(ChatController());
    }
  }

  void changePage(int index) {
    if (index == selectedIndex) {
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeChatList(
        controller: controller,
      ),
      ContactScreen(),
      SettingScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      appBar: HomeAppBar(
        selectedIndex: selectedIndex,
        titles: titles,
        controller: controller,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: MainBottomNavigation(
        currentIndex: selectedIndex,
        onTap: changePage,
      ),
    );
  }
}