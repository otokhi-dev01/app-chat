import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ADDED: Unit UI empty state illustration widget featuring 72x72 circular primary icon container
class SearchEmptyState extends StatelessWidget {
  final String title;
  final String description;

  const SearchEmptyState({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ADDED: 72x72 circular container with primary color tint
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: colorScheme.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}