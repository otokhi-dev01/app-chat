import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/chat_message_model.dart';

Future<void> showChatMessageActionsSheet({
  required BuildContext context,
  required ChatMessageModel message,
  required VoidCallback onCopied,
  required VoidCallback onReply,
  required VoidCallback onDelete,
}) {
  ThemeData theme = Theme.of(context);

  bool isDark =
      theme.brightness == Brightness.dark;

  Color sheetColor = isDark
      ? Color(0xFF1B1D22)
      : Colors.white;

  Color borderColor = isDark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.black.withValues(alpha: 0.06);

  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor:
    Colors.black.withValues(alpha: 0.35),
    builder: (BuildContext sheetContext) {
      return Container(
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(26),
          ),
          border: Border(
            top: BorderSide(
              color: borderColor,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              12,
              12,
              16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MessageSheetHandle(),

                SizedBox(height: 12),

                if (message.text.trim().isNotEmpty)
                  MessageActionTile(
                    icon: Icons.copy_rounded,
                    title: 'Copy',
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: message.text,
                        ),
                      );

                      Navigator.pop(sheetContext);

                      onCopied();
                    },
                  ),

                MessageActionTile(
                  icon: Icons.reply_rounded,
                  title: 'Reply',
                  onTap: () {
                    Navigator.pop(sheetContext);

                    Future<void>.delayed(
                      Duration(milliseconds: 130),
                      onReply,
                    );
                  },
                ),

                if (message.isMe)
                  MessageActionTile(
                    icon:
                    Icons.delete_outline_rounded,
                    title: 'Delete',
                    isDanger: true,
                    onTap: () {
                      Navigator.pop(sheetContext);

                      Future<void>.delayed(
                        Duration(milliseconds: 130),
                        onDelete,
                      );
                    },
                  ),
              ],
            ),
          ),
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

    Color itemColor = isDanger
        ? colorScheme.error
        : colorScheme.primary;

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
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: itemColor,
                  size: 21,
                ),
              ),

              SizedBox(width: 13),

              Expanded(
                child: Text(
                  title,
                  style: theme
                      .textTheme.bodyLarge
                      ?.copyWith(
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

class _MessageSheetHandle
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant
            .withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}