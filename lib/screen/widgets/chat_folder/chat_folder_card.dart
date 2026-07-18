import 'package:flutter/material.dart';

class ChatFolderCard extends StatelessWidget {
  final List<Widget> children;

  ChatFolderCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

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

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class ChatFolderDivider extends StatelessWidget {
  ChatFolderDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    Color dividerColor = isDark
        ? Colors.white.withValues(
      alpha: 0.07,
    )
        : Colors.black.withValues(
      alpha: 0.05,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 69,
      ),
      child: Divider(
        height: 1,
        thickness: 1,
        color: dividerColor,
      ),
    );
  }
}

class ChatFolderSectionTitle
    extends StatelessWidget {
  final String title;

  ChatFolderSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall
            ?.copyWith(
          color:
          theme.colorScheme.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ChatFolderHeaderCard
    extends StatelessWidget {
  final int folderCount;

  ChatFolderHeaderCard({
    super.key,
    required this.folderCount,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withValues(
                alpha: 0.12,
              ),
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.folder_copy_outlined,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  '$folderCount folders',
                  style: theme
                      .textTheme.titleMedium
                      ?.copyWith(
                    color:
                    colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Create folders to quickly find personal chats, groups, work conversations and more.',
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme.bodySmall
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatFolderInformationCard
    extends StatelessWidget {
  ChatFolderInformationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary
            .withValues(
          alpha: 0.07,
        ),
        borderRadius:
        BorderRadius.circular(17),
        border: Border.all(
          color: colorScheme.primary
              .withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Default folders cannot be renamed or removed. Custom folders can be edited at any time.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}