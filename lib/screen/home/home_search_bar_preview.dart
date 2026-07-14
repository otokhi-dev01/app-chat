import 'package:flutter/material.dart';

import '../../controllers/chat_controller.dart';

class HomeSearchBarPreview
    extends StatelessWidget {
  final ChatController controller;

  HomeSearchBarPreview({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color backgroundColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFF2F4F7);

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.09)
        : Color(0xFFE4E7EC);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        4,
        12,
        12,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.openSearchScreen,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 46,
            padding: EdgeInsets.symmetric(
              horizontal: 13,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
              BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withValues(alpha: 0.11),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 19,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search chats',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}