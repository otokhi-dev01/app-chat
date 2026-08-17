import 'package:appchat/controllers/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings/chat_folder_controller.dart';
import '../../services/folder_service/chat_folder_api_service.dart';
import '../../services/massage_service /chat_list_service.dart';

import '../../services/mock/mock_chat_list_service.dart';
import '../contact/contact_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/setting_screen.dart';
import '../widgets/navigation/main_bottom_navigation.dart';
import 'chat_list/home_chat_list.dart';
import 'home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
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

    pageController = PageController(
      initialPage: selectedIndex,
    );

    if (!Get.isRegistered<ChatListService>()) {
      Get.put<ChatListService>(
        MockChatListService(),
        permanent: true,
      );
    }

    if (!Get.isRegistered<ChatController>()) {
      Get.put<ChatController>(
        ChatController(
          chatService: Get.find<ChatListService>(),
        ),
        permanent: true,
      );
    }

    if (!Get.isRegistered<ChatFolderController>()) {
      Get.put<ChatFolderController>(
        ChatFolderController(
          chatFolderApiService: Get.find<ChatFolderApiService>(),
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

  void _onPageSwiped(int index) {
    if (index == selectedIndex) {
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  void _onHeaderSwipe(DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0;

    if (velocity < -250 && selectedIndex < titles.length - 1) {
      changePage(selectedIndex + 1);
    } else if (velocity > 250 && selectedIndex > 0) {
      changePage(selectedIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeChatList(
        controller: controller,
      ),
      ContactScreen(),
      SettingScreen(),
      ProfileScreen(),
    ];

    final HomeAppBar homeAppBar = HomeAppBar(
      selectedIndex: selectedIndex,
      titles: titles,
      controller: controller,
      onOpenSettings: () {},
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,

      appBar: PreferredSize(
        preferredSize: homeAppBar.preferredSize,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: _onHeaderSwipe,
          child: homeAppBar,
        ),
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