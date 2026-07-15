import 'package:flutter/material.dart';

class ContactEmptyState
    extends StatelessWidget {
  final bool hasSearchQuery;

  ContactEmptyState({
    super.key,
    required this.hasSearchQuery,
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
        : Color(0xFFE7E9ED);

    return ListView(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        90,
        24,
        120,
      ),
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            24,
            28,
            24,
            26,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
            BorderRadius.circular(24),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasSearchQuery
                      ? Icons
                      .person_search_rounded
                      : Icons
                      .people_outline_rounded,
                  size: 42,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(height: 18),
              Text(
                hasSearchQuery
                    ? 'No contacts found'
                    : 'No contacts yet',
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.titleMedium
                    ?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 7),
              Text(
                hasSearchQuery
                    ? 'Try searching with another contact name.'
                    : 'Add your first contact to start a conversation.',
                textAlign: TextAlign.center,
                style: theme
                    .textTheme.bodyMedium
                    ?.copyWith(
                  color:
                  colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}