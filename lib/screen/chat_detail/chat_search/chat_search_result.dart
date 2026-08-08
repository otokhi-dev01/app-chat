import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/chat_message_model.dart';

class ChatSearchResultTile extends StatelessWidget {
  final ChatMessageModel message;
  final String query;
  final String preview;
  final String dateText;
  final IconData icon;
  final Color cardColor;
  final Color borderColor;
  final bool isDark;
  final VoidCallback onTap;

  const ChatSearchResultTile({
    super.key,
    required this.message,
    required this.query,
    required this.preview,
    required this.dateText,
    required this.icon,
    required this.cardColor,
    required this.borderColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.isMe ? 'You' : 'Received',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      _HighlightedMessageText(
                        text: preview,
                        query: query,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.55,
                  ),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HighlightedMessageText extends StatelessWidget {
  final String text;
  final String query;

  const _HighlightedMessageText({
    required this.text,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int matchIndex = lowerText.indexOf(lowerQuery);

    TextStyle normalStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontSize: 12,
      height: 1.3,
    ) ??
        const TextStyle();

    if (matchIndex < 0 || lowerQuery.isEmpty) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: normalStyle,
      );
    }

    String before = text.substring(0, matchIndex);
    String match = text.substring(
      matchIndex,
      matchIndex + query.length,
    );
    String after = text.substring(
      matchIndex + query.length,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: before,
            style: normalStyle,
          ),
          TextSpan(
            text: match,
            style: normalStyle.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
              backgroundColor: colorScheme.primary.withValues(
                alpha: 0.12,
              ),
            ),
          ),
          TextSpan(
            text: after,
            style: normalStyle,
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}