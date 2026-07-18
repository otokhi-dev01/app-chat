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
        onOpenSettings: () {},
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