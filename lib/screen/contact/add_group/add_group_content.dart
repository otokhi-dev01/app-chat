import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/add_group_controller.dart';
import '../../../models/chat_message_model.dart';
import '../../../models/contact_model.dart';
import '../../../services/picker_service/chat_camera_services.dart';
import '../../widgets/app_feedback.dart';
import 'add_group_contact_title.dart';
import 'add_group_header.dart';
import 'add_group_photo_sheet.dart';
import 'add_group_select_members.dart';

class AddGroupContent extends StatefulWidget {
  final AddGroupController controller;

  AddGroupContent({
    super.key,
    required this.controller,
  });

  @override
  State<AddGroupContent> createState() {
    return _AddGroupContentState();
  }
}

class _AddGroupContentState extends State<AddGroupContent> {
  final ChatCameraService _chatCameraService = ChatCameraService();

  late TextEditingController groupNameController;
  late TextEditingController searchController;

  AddGroupController get controller {
    return widget.controller;
  }

  @override
  void initState() {
    super.initState();

    groupNameController = TextEditingController(
      text: controller.groupName.value,
    );

    searchController = TextEditingController(
      text: controller.searchQuery.value,
    );

    groupNameController.addListener(_handleGroupNameChanged);
    searchController.addListener(_handleSearchChanged);
  }

  void _handleGroupNameChanged() {
    controller.setGroupName(
      groupNameController.text,
    );
  }

  void _handleSearchChanged() {
    controller.setSearchQuery(
      searchController.text,
    );
  }

  void _clearSearch() {
    searchController.clear();
    controller.clearSearchQuery();
  }

  Future<void> _openGroupPhotoSheet() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showAddGroupPhotoSheet(
      context: context,
      hasPhoto: controller.groupImagePath.value.isNotEmpty,
      groupImagePath: controller.groupImagePath.value,
      onGallery: _pickGroupImageFromGallery,
      onCamera: _takeGroupPhoto,
      onRemove: controller.removeGroupImage,
    );
  }

  Future<void> _pickGroupImageFromGallery() async {
    try {
      ChatMessageModel? result = await _chatCameraService.pickFromGallery();

      if (result == null ||
          result.mediaPath == null ||
          result.mediaPath!.trim().isEmpty) {
        return;
      }

      if (!mounted) {
        return;
      }

      controller.setGroupImage(
        result.mediaPath!,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showImageError(
        'unable_to_select_photo'.tr,
      );
    }
  }

  Future<void> _takeGroupPhoto() async {
    try {
      ChatMessageModel? result = await _chatCameraService.takePhoto();

      if (result == null ||
          result.mediaPath == null ||
          result.mediaPath!.trim().isEmpty) {
        return;
      }

      if (!mounted) {
        return;
      }

      controller.setGroupImage(
        result.mediaPath!,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showImageError(
        'unable_to_take_photo'.tr,
      );
    }
  }

  void _showImageError(String message) {
    AppFeedback.showMessage(
      title: 'error'.tr,
      message: message,
      icon: CupertinoIcons.exclamationmark_circle,
    );
  }

  @override
  void dispose() {
    groupNameController.removeListener(_handleGroupNameChanged);
    searchController.removeListener(_handleSearchChanged);

    groupNameController.dispose();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: [
          Obx(
                () {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  14,
                  14,
                  14,
                  0,
                ),
                child: AddGroupHeader(
                  nameController: groupNameController,
                  groupImagePath: controller.groupImagePath.value,
                  onPhotoTap: _openGroupPhotoSheet,
                  onRemovePhoto: controller.removeGroupImage,
                ),
              );
            },
          ),
          Obx(
                () {
              if (controller.selectedMembers.isEmpty) {
                return SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  14,
                  10,
                  14,
                  0,
                ),
                child: AddGroupSelectedMembers(
                  members: controller.selectedMembers.toList(
                    growable: false,
                  ),
                  onRemoveMember: controller.removeMember,
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              14,
              10,
              14,
              10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                            () {
                          return Text(
                            controller.memberCountText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Obx(
                          () {
                        return Text(
                          '${controller.filteredContacts.length} ${'contacts'.tr}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 9),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: searchController,
                  builder: (
                      BuildContext context,
                      TextEditingValue value,
                      Widget? child,
                      ) {
                    bool hasSearchText = value.text.trim().isNotEmpty;

                    return Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: borderColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.15 : 0.04,
                            ),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 12),
                          Icon(
                            CupertinoIcons.search,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              textInputAction: TextInputAction.search,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'search_contacts'.tr,
                                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : Colors.black.withValues(alpha: 0.4),
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 11,
                                ),
                              ),
                              onTapOutside: (PointerDownEvent event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                          if (hasSearchText)
                            Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(32, 32),
                                onPressed: _clearSearch,
                                child: Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  size: 18,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : Colors.black.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
                  () {
                List<ContactModel> contacts = controller.filteredContacts;

                if (controller.isLoading.value &&
                    controller.contacts.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.primary,
                    ),
                  );
                }

                if (controller.loadErrorMessage.value.isNotEmpty) {
                  return _AddGroupErrorView(
                    message: controller.loadErrorMessage.value,
                    onRetry: controller.loadContacts,
                  );
                }

                if (contacts.isEmpty) {
                  return _AddGroupEmptyView(
                    hasSearch: controller.searchQuery.value.isNotEmpty,
                    onClearSearch: _clearSearch,
                  );
                }

                return ListView.separated(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.zero,
                  itemCount: contacts.length,
                  separatorBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 76,
                      ),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: borderColor,
                      ),
                    );
                  },
                  itemBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    ContactModel contact = contacts[index];

                    return GetBuilder<AddGroupController>(
                      id: 'contact_${contact.id}',
                      builder: (
                          AddGroupController controller,
                          ) {
                        return AddGroupContactTile(
                          key: ValueKey<String>(
                            contact.id,
                          ),
                          contact: contact,
                          selected: controller.isSelected(
                            contact,
                          ),
                          onTap: () {
                            controller.toggleMember(
                              contact,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddGroupEmptyView extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onClearSearch;

  _AddGroupEmptyView({
    required this.hasSearch,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasSearch ? CupertinoIcons.search : CupertinoIcons.person_2,
                color: colorScheme.primary,
                size: 34,
              ),
            ),
            SizedBox(height: 16),
            Text(
              hasSearch ? 'no_contacts_found'.tr : 'no_contacts_available'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (hasSearch) ...[
              SizedBox(height: 10),
              TextButton(
                onPressed: onClearSearch,
                child: Text(
                  'clear_search'.tr,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddGroupErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  _AddGroupErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.exclamationmark_circle,
                color: colorScheme.error,
                size: 31,
              ),
            ),
            SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(
                CupertinoIcons.arrow_clockwise,
                size: 18,
              ),
              label: Text(
                'retry'.tr,
              ),
              style: FilledButton.styleFrom(
                minimumSize: Size(160, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}