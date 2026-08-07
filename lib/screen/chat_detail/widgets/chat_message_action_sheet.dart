import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/chat_message_model.dart';

Future<void> showChatMessageActionsSheet({
  required BuildContext context,
  required ChatMessageModel message,
  required VoidCallback onCopied,
  required VoidCallback onReply,
  required VoidCallback onDelete,
}) {
  FocusManager.instance.primaryFocus?.unfocus();

  bool hasText = message.text.trim().isNotEmpty;

  String messagePreview = hasText
      ? (message.text.length > 30
      ? '${message.text.substring(0, 30)}...'
      : message.text)
      : 'message'.tr;

  return showCupertinoModalPopup<void>(
    context: context,
    builder: (sheetContext) {
      return CupertinoActionSheet(
        title: Text(
          messagePreview,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          if (hasText)
            CupertinoActionSheetAction(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: message.text),
                );
                Navigator.pop(sheetContext);
                onCopied();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_on_doc,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text('copy'.tr),
                ],
              ),
            ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              Future<void>.delayed(
                Duration(milliseconds: 100),
                onReply,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.reply,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('reply'.tr),
              ],
            ),
          ),
          if (message.isMe)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(sheetContext);
                Future<void>.delayed(
                  Duration(milliseconds: 100),
                  onDelete,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.trash,
                    size: 20,
                    color: CupertinoColors.destructiveRed,
                  ),
                  SizedBox(width: 8),
                  Text('delete'.tr),
                ],
              ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(sheetContext);
          },
          child: Text('cancel'.tr),
        ),
      );
    },
  );
}

class MessageActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDanger;

  MessageActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color itemColor = isDanger ? colorScheme.error : colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 9,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: itemColor.withValues(
                    alpha: 0.11,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: itemColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDanger
                        ? colorScheme.error
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}