import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/add_group_controller.dart';
import '../../../models/chat_message_model.dart';
import '../../../models/contact_model.dart';
import '../../../services/chat_camera_services.dart';
import 'add_group_contact_title.dart';
import 'add_group_header.dart';
import 'add_group_photo_sheet.dart';
import 'add_group_select_members.dart';

class AddGroupContent
    extends StatefulWidget {
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

class _AddGroupContentState
    extends State<AddGroupContent> {
  final ChatCameraService
  _chatCameraService =
  ChatCameraService();

  late TextEditingController
  groupNameController;

  late TextEditingController
  searchController;

  AddGroupController get controller {
    return widget.controller;
  }

  @override
  void initState() {
    super.initState();

    groupNameController =
        TextEditingController(
          text: controller.groupName.value,
        );

    searchController =
        TextEditingController(
          text: controller.searchQuery.value,
        );

    groupNameController.addListener(
      _handleGroupNameChanged,
    );

    searchController.addListener(
      _handleSearchChanged,
    );
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

  Future<void>
  _openGroupPhotoSheet() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    await showAddGroupPhotoSheet(
      context: context,
      hasPhoto: controller
          .groupImagePath.value
          .isNotEmpty,
      onGallery:
      _pickGroupImageFromGallery,
      onCamera: _takeGroupPhoto,
      onRemove:
      controller.removeGroupImage,
    );
  }

  Future<void>
  _pickGroupImageFromGallery() async {
    try {
      ChatMessageModel? result =
      await _chatCameraService
          .pickFromGallery();

      if (result == null ||
          result.mediaPath == null ||
          result.mediaPath!
              .trim()
              .isEmpty) {
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
        'Unable to select the photo.',
      );
    }
  }

  Future<void> _takeGroupPhoto() async {
    try {
      ChatMessageModel? result =
      await _chatCameraService
          .takePhoto();

      if (result == null ||
          result.mediaPath == null ||
          result.mediaPath!
              .trim()
              .isEmpty) {
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
        'Unable to take the photo.',
      );
    }
  }

  void _showImageError(
      String message,
      ) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: colorScheme.onError,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor:
          colorScheme.error,
          behavior:
          SnackBarBehavior.floating,
          margin: EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  void dispose() {
    groupNameController.removeListener(
      _handleGroupNameChanged,
    );

    searchController.removeListener(
      _handleSearchChanged,
    );

    groupNameController.dispose();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness ==
            Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Obx(
                () {
              return Padding(
                padding:
                EdgeInsets.fromLTRB(
                  14,
                  14,
                  14,
                  0,
                ),
                child: AddGroupHeader(
                  nameController:
                  groupNameController,
                  groupImagePath:
                  controller
                      .groupImagePath
                      .value,
                  onPhotoTap:
                  _openGroupPhotoSheet,
                  onRemovePhoto:
                  controller
                      .removeGroupImage,
                ),
              );
            },
          ),
          Obx(
                () {
              if (controller
                  .selectedMembers
                  .isEmpty) {
                return SizedBox.shrink();
              }

              return Padding(
                padding:
                EdgeInsets.fromLTRB(
                  14,
                  10,
                  14,
                  0,
                ),
                child:
                AddGroupSelectedMembers(
                  members: controller
                      .selectedMembers
                      .toList(
                    growable: false,
                  ),
                  onRemoveMember:
                  controller
                      .removeMember,
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                            () {
                          return Text(
                            controller
                                .memberCountText,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                              fontSize: 11,
                              fontWeight:
                              FontWeight
                                  .w500,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Obx(
                          () {
                        return Text(
                          '${controller.filteredContacts.length} contacts',
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                            fontSize: 11,
                            fontWeight:
                            FontWeight
                                .w500,
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
                    bool hasSearchText =
                        value.text.trim().isNotEmpty;

                    return SizedBox(
                      height: 46,
                      child: TextField(
                        controller: searchController,
                        textInputAction:
                        TextInputAction.search,
                        textAlignVertical:
                        TextAlignVertical.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(
                          color: colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search contacts',
                          hintStyle: theme.textTheme.bodyMedium
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: cardColor,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color:
                            colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          prefixIconConstraints:
                          BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                          ),
                          suffixIcon: hasSearchText
                              ? IconButton(
                            onPressed: _clearSearch,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 42,
                              minHeight: 42,
                            ),
                            icon: Icon(
                              Icons.close_rounded,
                              color: colorScheme
                                  .onSurfaceVariant,
                              size: 19,
                            ),
                            splashColor:
                            Colors.transparent,
                            highlightColor:
                            Colors.transparent,
                            hoverColor:
                            Colors.transparent,
                            focusColor:
                            Colors.transparent,
                          )
                              : null,
                          suffixIconConstraints:
                          BoxConstraints(
                            minWidth: 42,
                            minHeight: 42,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 1.35,
                            ),
                          ),
                        ),
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
                List<ContactModel>
                contacts = controller
                    .filteredContacts;

                if (controller
                    .isLoading.value &&
                    controller
                        .contacts.isEmpty) {
                  return Center(
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme
                          .primary,
                    ),
                  );
                }

                if (controller
                    .loadErrorMessage
                    .value
                    .isNotEmpty) {
                  return _AddGroupErrorView(
                    message: controller
                        .loadErrorMessage
                        .value,
                    onRetry: controller
                        .loadContacts,
                  );
                }

                if (contacts.isEmpty) {
                  return _AddGroupEmptyView(
                    hasSearch: controller
                        .searchQuery
                        .value
                        .isNotEmpty,
                    onClearSearch:
                    _clearSearch,
                  );
                }

                return Container(
                  margin:
                  EdgeInsets.fromLTRB(
                    14,
                    0,
                    14,
                    14,
                  ),
                  clipBehavior:
                  Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      color: borderColor,
                    ),
                  ),
                  child:
                  ListView.separated(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
                    physics:
                    BouncingScrollPhysics(
                      parent:
                      AlwaysScrollableScrollPhysics(),
                    ),
                    padding:
                    EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    itemCount:
                    contacts.length,
                    separatorBuilder: (
                        BuildContext context,
                        int index,
                        ) {
                      return Padding(
                        padding:
                        EdgeInsets.only(
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
                      ContactModel contact =
                      contacts[index];

                      return GetBuilder<
                          AddGroupController>(
                        id:
                        'contact_${contact.id}',
                        builder: (
                            AddGroupController
                            controller,
                            ) {
                          return AddGroupContactTile(
                            key: ValueKey<String>(
                              contact.id,
                            ),
                            contact: contact,
                            selected: controller
                                .isSelected(
                              contact,
                            ),
                            onTap: () {
                              controller
                                  .toggleMember(
                                contact,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddGroupEmptyView
    extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onClearSearch;

  _AddGroupEmptyView({
    required this.hasSearch,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              hasSearch
                  ? Icons
                  .person_search_outlined
                  : Icons
                  .person_outline_rounded,
              color: colorScheme
                  .onSurfaceVariant,
              size: 44,
            ),
            SizedBox(height: 12),
            Text(
              hasSearch
                  ? 'No contacts found'
                  : 'No contacts available',
              style: theme
                  .textTheme.titleMedium
                  ?.copyWith(
                color:
                colorScheme.onSurface,
                fontWeight:
                FontWeight.w700,
              ),
            ),
            if (hasSearch) ...[
              SizedBox(height: 10),
              TextButton(
                onPressed: onClearSearch,
                child: Text(
                  'Clear search',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddGroupErrorView
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  _AddGroupErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    ColorScheme colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 44,
            ),
            SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme.bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}