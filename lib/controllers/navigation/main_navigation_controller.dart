import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../route/app_route.dart';

enum MainTab {
  chats,
  contacts,
  calls,
  search,
}

class MainNavigationController extends GetxController {
  final RxInt currentIndex = MainTab.chats.index.obs;

  void changeTab(int index) {
    if (index < 0 || index >= MainTab.values.length) {
      return;
    }

    if (currentIndex.value == index) {
      return;
    }

    currentIndex.value = index;
  }

  void goToChats() {
    changeTab(MainTab.chats.index);
  }

  void goToContacts() {
    changeTab(MainTab.contacts.index);
  }

  void gotoCalls() {
    changeTab(MainTab.calls.index);
  }

  // UPDATED: Navigates to SearchScreen cleanly using AppRoutes.searchChats
  void openSearchScreen() {
    FocusManager.instance.primaryFocus?.unfocus();

    // FIXED: Opens SearchScreen via GetX route definition with 280ms Cupertino transition
    Get.toNamed(AppRoutes.searchChats);
  }


}