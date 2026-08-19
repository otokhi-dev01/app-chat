import 'package:get/get.dart';

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

  void gotoSearch() {
    changeTab(MainTab.search.index);
  }


}