import 'package:appchat/controllers/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings/chat_folder_controller.dart';
import '../../services/chat_folder_service.dart';
import '../../services/chat_list_service.dart';
import '../../services/mock/mock_chat_folder_service.dart';
import '../../services/mock/mock_chat_list_service.dart';
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
  late ChatFolderController folderController;
  late PageController pageController;

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

    pageController = PageController(initialPage: selectedIndex);

    if (!Get.isRegistered<ChatListService>()) {
      Get.put<ChatListService>(
        MockChatListService(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<ChatController>()) {
      Get.put<ChatController>(
        ChatController(
          chatService:
          Get.find<ChatListService>(),
        ),
        permanent: true,
      );
    }

    if (!Get.isRegistered<ChatFolderService>()) {
      Get.put<ChatFolderService>(
        MockChatFolderService(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<ChatFolderController>()) {
      Get.put<ChatFolderController>(
        ChatFolderController(
          folderService:
          Get.find<ChatFolderService>(),
        ),
        permanent: true,
      );
    }

    controller = Get.find<ChatController>();
    folderController = Get.find<ChatFolderController>();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// Called when the bottom nav is tapped — animates the PageView,
  /// which in turn triggers onPageSwiped to update selectedIndex.
  void changePage(int index) {
    if (index == selectedIndex) {
      return;
    }

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  /// Called by PageView itself — covers both swipe gestures and the
  /// animateToPage() call above, so this is the single source of truth
  /// for selectedIndex instead of setState living in two places.
  void _onPageSwiped(int index) {
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
        onOpenSettings: () {},
      ),
      body: PageView(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: _onPageSwiped,
        children: screens,
      ),
      bottomNavigationBar: MainBottomNavigation(
        currentIndex: selectedIndex,
        onTap: changePage,
      ),
    );
  }
}