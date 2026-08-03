import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/mock_add_group_contact_data.dart';
import '../../../models/contact_model.dart';

class ChatFolderFormResult {
  final String name;
  final List<String> selectedMemberIds;

  ChatFolderFormResult({
    required this.name,
    required this.selectedMemberIds,
  });
}

class CreateFolderScreen extends StatefulWidget {
  final String title;
  final String confirmText;
  final String initialValue;
  final List<String> initialSelectedMemberIds;

  const CreateFolderScreen({
    super.key,
    required this.title,
    required this.confirmText,
    required this.initialValue,
    this.initialSelectedMemberIds = const [],
  });

  @override
  State<CreateFolderScreen> createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends State<CreateFolderScreen> {
  late TextEditingController textController;
  final List<ContactModel> availableContacts = MockAddGroupContactData.contacts;
  late Set<String> selectedMemberIds;
  bool canSubmit = false;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController(
      text: widget.initialValue,
    );

    selectedMemberIds = Set<String>.from(widget.initialSelectedMemberIds);
    canSubmit = textController.text.trim().isNotEmpty;

    textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    bool nextValue = textController.text.trim().isNotEmpty;

    if (nextValue == canSubmit) {
      return;
    }

    setState(() {
      canSubmit = nextValue;
    });
  }

  void _toggleMember(String id) {
    setState(() {
      if (selectedMemberIds.contains(id)) {
        selectedMemberIds.remove(id);
      } else {
        selectedMemberIds.add(id);
      }
    });
  }

  void _submit() {
    String result = textController.text.trim();

    if (result.isEmpty) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    Get.back(
      result: ChatFolderFormResult(
        name: result,
        selectedMemberIds: selectedMemberIds.toList(),
      ),
    );
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.dispose();
  }

  SystemUiOverlayStyle _overlayStyle(ThemeData theme, bool isDark) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color actionBackground = isDark ? Color(0xFF1B1D22) : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle(theme, isDark),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          forceMaterialTransparency: true,
          titleSpacing: 0,
          leadingWidth: 58,
          systemOverlayStyle: _overlayStyle(theme, isDark),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 18,
                sigmaY: 18,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: appBarColor,
                  border: Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 6, 10),
            child: Tooltip(
              message: 'back'.tr,
              child: Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: actionBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: borderColor,
                    width: 1.0,
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
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(40, 40),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Get.back();
                  },
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 12, right: 12, bottom: 12),
              child: TextButton(
                onPressed: canSubmit ? _submit : null,
                style: TextButton.styleFrom(
                  minimumSize: Size(68, 36),
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  disabledBackgroundColor: colorScheme.primary.withValues(
                    alpha: 0.55,
                  ),
                  disabledForegroundColor: colorScheme.onPrimary.withValues(
                    alpha: 0.75,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  widget.confirmText,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            Container(
              padding: EdgeInsets.all(16),
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
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'folder_name'.tr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    maxLength: 30,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    onSubmitted: (_) => _submit(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'folder_name_example'.tr,
                      prefixIcon: Icon(
                        CupertinoIcons.folder,
                        color: colorScheme.primary,
                        size: 18,
                      ),
                      counterText: '',
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.04)
                          : Colors.black.withValues(alpha: 0.025),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.person_2,
                    color: colorScheme.primary,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'add_members'.trParams({
                      'count': '${selectedMemberIds.length}',
                    }),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
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
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: availableContacts.map((contact) {
                  final bool isSelected =
                  selectedMemberIds.contains(contact.id);
                  return Material(
                    color: Colors.transparent,
                    child: CheckboxListTile(
                      value: isSelected,
                      activeColor: colorScheme.primary,
                      onChanged: (_) => _toggleMember(contact.id),
                      title: Text(contact.name),
                      subtitle: Text(contact.username),
                      secondary: CircleAvatar(
                        backgroundColor:
                        colorScheme.primary.withValues(alpha: 0.11),
                        backgroundImage: contact.avatarUrl.trim().isNotEmpty
                            ? NetworkImage(contact.avatarUrl)
                            : null,
                        child: contact.avatarUrl.trim().isEmpty
                            ? Icon(
                          CupertinoIcons.person_fill,
                          color: colorScheme.primary,
                          size: 18,
                        )
                            : null,
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}