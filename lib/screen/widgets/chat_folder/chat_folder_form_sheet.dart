import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class ChatFolderFormSheet extends StatefulWidget {
  final String title;
  final String confirmText;
  final String initialValue;
  final List<String> initialSelectedMemberIds;

  ChatFolderFormSheet({
    super.key,
    required this.title,
    required this.confirmText,
    required this.initialValue,
    this.initialSelectedMemberIds = const [],
  });

  static Future<ChatFolderFormResult?> open({
    required BuildContext context,
    required String title,
    required String confirmText,
    String initialValue = '',
    List<String> initialSelectedMemberIds = const [],
  }) {
    return showModalBottomSheet<ChatFolderFormResult>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: 0.42,
      ),
      builder: (
        BuildContext context,
      ) {
        return ChatFolderFormSheet(
          title: title,
          confirmText: confirmText,
          initialValue: initialValue,
          initialSelectedMemberIds: initialSelectedMemberIds,
        );
      },
    );
  }

  @override
  State<ChatFolderFormSheet> createState() {
    return _ChatFolderFormSheetState();
  }
}

class _ChatFolderFormSheetState extends State<ChatFolderFormSheet> {
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

    textController.addListener(
      _onTextChanged,
    );
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

    Navigator.of(context).pop(
      ChatFolderFormResult(
        name: result,
        selectedMemberIds: selectedMemberIds.toList(),
      ),
    );
  }

  @override
  void dispose() {
    textController.removeListener(
      _onTextChanged,
    );

    textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color sheetColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(
          context,
        ).bottom,
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        padding: EdgeInsets.fromLTRB(
          18,
          10,
          18,
          22,
        ),
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.28,
                  ),
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Material(
                  color: colorScheme.surfaceContainerHighest,
                  shape: CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    customBorder: CircleBorder(),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.close_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            TextField(
              controller: textController,
              autofocus: true,
              maxLength: 30,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  30,
                ),
              ],
              onSubmitted: (
                String value,
              ) {
                _submit();
              },
              decoration: InputDecoration(
                labelText: 'Folder name',
                hintText: 'Example: Work',
                prefixIcon: Icon(
                  Icons.folder_outlined,
                ),
                counterText: '',
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withValues(
                      alpha: 0.35,
                    ),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Add Members (${selectedMemberIds.length})',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: availableContacts.map((contact) {
                    final bool isSelected = selectedMemberIds.contains(contact.id);
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (_) => _toggleMember(contact.id),
                      title: Text(contact.name),
                      subtitle: Text(contact.username),
                      secondary: CircleAvatar(
                        backgroundImage: NetworkImage(contact.avatarUrl),
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 18),
            FilledButton(
              onPressed: canSubmit ? _submit : null,
              style: FilledButton.styleFrom(
                minimumSize: Size(
                  double.infinity,
                  52,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
              ),
              child: Text(
                widget.confirmText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}