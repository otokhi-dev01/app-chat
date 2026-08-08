import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatEmptyConversation extends StatelessWidget {
  final String name;

  const ChatEmptyConversation({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    // UPDATED: Access current theme and colorScheme for light/dark mode adaptation
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        // UPDATED: Responsive padding matching unit UI empty state standards
        padding: const EdgeInsets.fromLTRB(28, 40, 28, 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // UPDATED: 72x72 circular container with primary color tint (matches unit UI empty states)
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(
                  alpha: 0.11,
                ),
                shape: BoxShape.circle,
              ),
              // UPDATED: Replaced Material icon with Cupertino chat bubble icon
              child: Icon(
                CupertinoIcons.chat_bubble_2,
                color: colorScheme.primary,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            // ADDED: Main empty state title matching unit UI heading typography
            Text(
              'No Messages Yet',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            // UPDATED: Dynamic subtitle styled with onSurfaceVariant color and 1.4 line height
            Text(
              'Start a conversation with $name',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}