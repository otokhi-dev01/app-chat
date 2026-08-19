import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat/chat_controller.dart';
import '../../controllers/settings/chat_folder_controller.dart';
import '../../services/folder_service/chat_folder_api_service.dart';
import '../../services/massage_service /chat_list_service.dart';
import '../../services/mock/mock_chat_list_service.dart';
import '../contact/contact_screen.dart';
import '../home/search/search_screen.dart';
import '../widgets/navigation/main_bottom_navigation.dart';
import 'chat_list/home_chat_list.dart';
import 'home_app_bar.dart';
import 'settings_side_drawer.dart';

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
  // GlobalKey to control Scaffold and open the Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ChatController controller;
  late ChatFolderController folderController;
  late PageController pageController;

  int selectedIndex = 0;

  final List<String> titles = [
    'Chats',
    'Contacts',
    'Calls',
    'Search',
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
    final ThemeData theme = Theme.of(context);

    final List<Widget> screens = [
      HomeChatList(
        controller: controller,
      ),
      ContactScreen(),
      Center(child: Text('Calls Tab Placeholder')),
      SearchScreen(),
    ];

    final HomeAppBar homeAppBar = HomeAppBar(
      selectedIndex: selectedIndex,
      titles: titles,
      controller: controller,
      // Opens the left-to-right drawer
      onOpenSettings: () {
        _scaffoldKey.currentState?.openDrawer();
      },
      // Switches to the Contacts tab
      onNavigateToContacts: () {
        setState(() => selectedIndex = 1);
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,

      // Left-to-right sliding Drawer/Sheet
      drawer: const SettingsSideDrawer(),

      appBar: selectedIndex == 3
          ? null
          : PreferredSize(
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