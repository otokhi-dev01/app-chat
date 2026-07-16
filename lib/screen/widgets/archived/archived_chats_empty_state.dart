import 'package:flutter/material.dart';

class ArchivedChatsEmptyState
    extends StatelessWidget {
  ArchivedChatsEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

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

    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 380,
          ),
          padding: EdgeInsets.fromLTRB(
            26,
            32,
            26,
            30,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 92,
                height: 92,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary
                        .withValues(
                      alpha: 0.14,
                    ),
                  ),
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withValues(
                      alpha: 0.12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.archive_outlined,
                    color: colorScheme.primary,
                    size: 32,
                  ),
                ),
              ),

              SizedBox(height: 21),

              Text(
                'No archived chats',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge
                    ?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              SizedBox(height: 9),

              Text(
                'Chats you archive will appear here. '
                    'Swipe a conversation from your main chat list '
                    'to move it into the archive.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 22),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swipe_left_alt_rounded,
                      color: colorScheme.primary,
                      size: 21,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Swipe left to archive',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}