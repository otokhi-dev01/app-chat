import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsSearchItem {
  final String id;
  final String title;
  final String subtitle;
  final String section;
  final IconData icon;
  final List<String> keywords;

  SettingsSearchItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.section,
    required this.icon,
    required this.keywords,
  });
}

class SettingsSearchController
    extends GetxController {
  final TextEditingController searchController =
  TextEditingController();

  final FocusNode searchFocusNode =
  FocusNode();

  final RxString searchQuery = ''.obs;

  final List<SettingsSearchItem> settingsItems = [
    SettingsSearchItem(
      id: 'account',
      title: 'Account',
      subtitle:
      'Manage your account information',
      section: 'Account',
      icon: Icons.person_outline_rounded,
      keywords: [
        'account',
        'profile',
        'user',
        'name',
        'phone',
      ],
    ),
    SettingsSearchItem(
      id: 'notifications',
      title: 'Notifications',
      subtitle:
      'Control message and app notifications',
      section: 'General',
      icon:
      Icons.notifications_none_rounded,
      keywords: [
        'notification',
        'alert',
        'sound',
        'message',
      ],
    ),
    SettingsSearchItem(
      id: 'privacy',
      title: 'Privacy',
      subtitle:
      'Manage privacy and security options',
      section: 'General',
      icon:
      Icons.lock_outline_rounded,
      keywords: [
        'privacy',
        'security',
        'lock',
        'blocked',
      ],
    ),
    SettingsSearchItem(
      id: 'theme',
      title: 'Theme',
      subtitle:
      'Choose system, light, or dark mode',
      section: 'Display',
      icon:
      Icons.dark_mode_outlined,
      keywords: [
        'theme',
        'dark',
        'light',
        'system',
        'display',
      ],
    ),
    SettingsSearchItem(
      id: 'language',
      title: 'Language',
      subtitle:
      'Change application language',
      section: 'Display',
      icon:
      Icons.language_rounded,
      keywords: [
        'language',
        'english',
        'khmer',
        'translation',
      ],
    ),
    SettingsSearchItem(
      id: 'text_size',
      title: 'Text size',
      subtitle:
      'Adjust application text size',
      section: 'Display',
      icon:
      Icons.text_fields_rounded,
      keywords: [
        'text',
        'font',
        'size',
        'display',
      ],
    ),
    SettingsSearchItem(
      id: 'data_storage',
      title: 'Data and storage',
      subtitle:
      'Manage media, files, and storage',
      section: 'Storage',
      icon:
      Icons.storage_outlined,
      keywords: [
        'data',
        'storage',
        'media',
        'download',
        'cache',
      ],
    ),
    SettingsSearchItem(
      id: 'backup_sync',
      title: 'Backup and sync',
      subtitle:
      'Control chat backup and synchronization',
      section: 'Storage',
      icon:
      Icons.cloud_sync_outlined,
      keywords: [
        'backup',
        'sync',
        'cloud',
        'restore',
      ],
    ),
    SettingsSearchItem(
      id: 'help_support',
      title: 'Help and support',
      subtitle:
      'Get help and contact support',
      section: 'Support',
      icon:
      Icons.help_outline_rounded,
      keywords: [
        'help',
        'support',
        'contact',
        'problem',
      ],
    ),
    SettingsSearchItem(
      id: 'about',
      title: 'About',
      subtitle:
      'Application version and information',
      section: 'Support',
      icon:
      Icons.info_outline_rounded,
      keywords: [
        'about',
        'version',
        'app',
        'information',
      ],
    ),
    SettingsSearchItem(
      id: 'logout',
      title: 'Log out',
      subtitle:
      'Sign out from your account',
      section: 'Account',
      icon:
      Icons.logout_rounded,
      keywords: [
        'logout',
        'log out',
        'sign out',
        'account',
      ],
    ),
  ];

  List<SettingsSearchItem>
  get filteredItems {
    String query =
    searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      return settingsItems;
    }

    return settingsItems.where(
          (SettingsSearchItem item) {
        bool matchesTitle = item.title
            .toLowerCase()
            .contains(query);

        bool matchesSubtitle = item.subtitle
            .toLowerCase()
            .contains(query);

        bool matchesSection = item.section
            .toLowerCase()
            .contains(query);

        bool matchesKeyword =
        item.keywords.any(
              (String keyword) {
            return keyword
                .toLowerCase()
                .contains(query);
          },
        );

        return matchesTitle ||
            matchesSubtitle ||
            matchesSection ||
            matchesKeyword;
      },
    ).toList();
  }

  Map<String, List<SettingsSearchItem>>
  get groupedItems {
    Map<String, List<SettingsSearchItem>>
    grouped =
    <String, List<SettingsSearchItem>>{};

    for (SettingsSearchItem item
    in filteredItems) {
      grouped.putIfAbsent(
        item.section,
            () {
          return <SettingsSearchItem>[];
        },
      );

      grouped[item.section]!.add(item);
    }

    return grouped;
  }

  void updateSearch(
      String value,
      ) {
    searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';

    searchFocusNode.requestFocus();
  }

  void closeSearch() {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    Get.back();
  }

  void selectSetting(
      SettingsSearchItem item,
      ) {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    Get.back(
      result: item.id,
    );
  }

  @override
  void onReady() {
    super.onReady();

    Future<void>.delayed(
      Duration(milliseconds: 250),
          () {
        searchFocusNode.requestFocus();
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();

    super.onClose();
  }
}

class SettingsSearchBinding
    extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsSearchController>(
          () {
        return SettingsSearchController();
      },
    );
  }
}