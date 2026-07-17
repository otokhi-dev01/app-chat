import 'package:flutter/material.dart';

class SavedMessagesEmptyState
    extends StatelessWidget {
  SavedMessagesEmptyState({
    super.key,
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

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(28),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 340,
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            30,
            24,
            28,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
            BorderRadius.circular(26),
            border: Border.all(
              color: borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.18 : 0.06,
                ),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(
                    alpha: 0.11,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary
                        .withValues(
                      alpha: 0.14,
                    ),
                  ),
                ),
                child: Icon(
                  Icons
                      .bookmark_border_rounded,
                  color: colorScheme.primary,
                  size: 37,
                ),
              ),

              SizedBox(height: 20),

              Text(
                'No saved messages',
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.titleMedium
                    ?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Send yourself a note or forward important messages here.',
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.bodyMedium
                    ?.copyWith(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}