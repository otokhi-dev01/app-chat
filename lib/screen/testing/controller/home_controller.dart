import 'package:get/get.dart';

class HomeController extends GetxController {
  // 2026 Redesign maps Index 0 to "Chats" as default
  final RxInt currentTab = 0.obs;

  // Active folder/category for Chats (e.g., All, Personal, Work)
  final RxInt activeChatFolder = 0.obs;

  void changeTab(int index) {
    currentTab.value = index;
  }

  void changeChatFolder(int index) {
    activeChatFolder.value = index;
  }
}