import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../route/app_route.dart';
import '../../../controllers/contact/contact_controller.dart';
import '../../../models/contact_model.dart';
import '../chat_detail/chat_detail_screen.dart';
import '../../models/chat_model.dart';
import 'new_message_action_card.dart';

/// ADDED: Unit UI modal bottom sheet for Telegram-style New Message contact selection
class NewMessageSheet {
  NewMessageSheet._();

  /// Displays the modal bottom sheet for creating a new message / selecting a contact
  static Future<void> show({
    required BuildContext context,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (BuildContext sheetContext) {
        return const _NewMessageSheetContent();
      },
    );
  }
}

class _NewMessageSheetContent extends StatefulWidget {
  const _NewMessageSheetContent();

  @override
  State<_NewMessageSheetContent> createState() =>
      __NewMessageSheetContentState();
}

class __NewMessageSheetContentState extends State<_NewMessageSheetContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  ContactController get _contactCtrl => Get.find<ContactController>();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color sheetColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    Color cardColor = isDark ? const Color(0xFF26282E) : Colors.white;
    Color searchBackground = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double sheetHeight = screenHeight * 0.85;

    // FIXED: Container color stays anchored to bottom edge so no black background gap shows when keyboard opens/closes
    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: SafeArea(
          top: false,
          bottom: keyboardHeight == 0,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Top Drag Handle
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),

              // Sheet Header (Title + Circular Close 'X' Button)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 14, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'new_message'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    // Circular 'X' close button
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: colorScheme.onSurface,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: borderColor),

              // Search Bar Input
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: searchBackground,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.15 : 0.04,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        CupertinoIcons.search,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (val) {
                            setState(
                                    () => _searchQuery = val.trim().toLowerCase());
                          },
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'search_contacts'.tr,
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : Colors.black.withValues(alpha: 0.4),
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 11),
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                          onPressed: _clearSearch,
                          child: Icon(
                            CupertinoIcons.xmark_circle_fill,
                            size: 18,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.black.withValues(alpha: 0.4),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Scrollable Sheet Content (Action Card + Contacts List)
              Expanded(
                child: Obx(() {
                  Map<String, List<ContactModel>> grouped =
                      _contactCtrl.groupedContacts;

                  // Filter contacts matching search query
                  List<ContactModel> filteredContacts = [];
                  if (_searchQuery.isNotEmpty) {
                    for (var list in grouped.values) {
                      for (var contact in list) {
                        if (contact.name.toLowerCase().contains(_searchQuery) ||
                            contact.phoneNumber.contains(_searchQuery)) {
                          filteredContacts.add(contact);
                        }
                      }
                    }
                  }

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      // 1. Action Card (New Group, New Channel, New Contact)
                      if (_searchQuery.isEmpty) ...[
                        NewMessageActionCard(
                          onNewGroup: () {
                            Navigator.of(context).pop();
                            Get.toNamed(AppRoutes.addGroup);
                          },
                          onNewChannel: () {
                            Navigator.of(context).pop();
                            // Navigate to New Channel screen
                          },
                          onAddContactSave:
                              (firstName, lastName, phone, countryCode) async {
                            try {
                              await _contactCtrl.addPhoneContact(
                                firstName: firstName,
                                lastName: lastName,
                                phoneNumber: '$countryCode$phone',
                              );
                            } catch (_) {}
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // 2. Section Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          _searchQuery.isNotEmpty
                              ? 'search_results'.tr
                              : 'contacts'.tr,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 3. Alphabet-Grouped Contacts or Search Results
                      if (_searchQuery.isNotEmpty) ...[
                        if (filteredContacts.isEmpty)
                          _buildEmptyState(theme, colorScheme)
                        else
                          _buildContactCard(
                            filteredContacts,
                            cardColor,
                            borderColor,
                            isDark,
                          ),
                      ] else ...[
                        ...grouped.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(6, 12, 6, 6),
                                child: Text(
                                  entry.key,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              _buildContactCard(
                                entry.value,
                                cardColor,
                                borderColor,
                                isDark,
                              ),
                            ],
                          );
                        }),
                      ],
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
      List<ContactModel> contacts,
      Color cardColor,
      Color borderColor,
      bool isDark,
      ) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.04,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(contacts.length, (index) {
          ContactModel contact = contacts[index];
          bool showDivider = index < contacts.length - 1;

          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).pop();
                    Get.to(() => ChatDetailScreen(
                      chat: ChatModel(
                        id: contact.contactUserId,
                        peerUserId: contact.contactUserId,
                        name: contact.name,
                        message: '',
                        dateTime: DateTime.now(),
                        type: 'personal',
                        image: contact.avatarUrl,
                        isOnline: contact.isOnline,
                      ),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        // Avatar (42x42 circle)
                        CircleAvatar(
                          radius: 21,
                          backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.12),
                          backgroundImage: contact.avatarUrl.isNotEmpty
                              ? NetworkImage(contact.avatarUrl)
                              : null,
                          child: contact.avatarUrl.isEmpty
                              ? Text(
                            contact.name.isNotEmpty
                                ? contact.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                contact.phoneNumber.isNotEmpty
                                  ? contact.phoneNumber
                                  : 'online'.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (showDivider)
                Padding(
                  padding: const EdgeInsets.only(left: 68),
                  child: Divider(height: 1, color: borderColor),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'no_contacts_found'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}