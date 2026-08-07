import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactEmptyState extends StatelessWidget {
  final bool hasSearchQuery;

  const ContactEmptyState({
    super.key,
    this.hasSearchQuery = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.11),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasSearchQuery
                    ? CupertinoIcons.search
                    : CupertinoIcons.person_2,
                color: colorScheme.primary,
                size: 34,
              ),
            ),
            SizedBox(height: 16),
            Text(
              hasSearchQuery ? 'no_results_found'.tr : 'no_contacts_yet'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              hasSearchQuery
                  ? 'no_contacts_match_search'.tr
                  : 'add_contacts_to_start'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}