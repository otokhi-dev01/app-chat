import 'package:flutter/material.dart';

import '../../../models/chat_folder_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Empty folder view
// ─────────────────────────────────────────────────────────────────────────────

class HomeChatEmptyView extends StatelessWidget {
  final ChatFolderType folderType;

  HomeChatEmptyView({
    super.key,
    required this.folderType,
  });

  String get title {
    switch (folderType) {
      case ChatFolderType.all:
        return 'No chats yet';
      case ChatFolderType.personal:
        return 'No personal chats';
      case ChatFolderType.custom:
        return 'No chats in this folder';
    }
  }

  String get subtitle {
    switch (folderType) {
      case ChatFolderType.all:
        return 'Start a conversation and it will appear here.';
      case ChatFolderType.personal:
        return 'Your personal conversations will appear here.';
      case ChatFolderType.custom:
        return 'Add conversations to this custom folder.';
    }
  }

  IconData get icon {
    switch (folderType) {
      case ChatFolderType.all:
        return Icons.chat_bubble_outline_rounded;
      case ChatFolderType.personal:
        return Icons.person_outline_rounded;
      case ChatFolderType.custom:
        return Icons.folder_open_outlined;
    }
  }

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
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colorScheme.primary, size: 34),
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
              subtitle,
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

// ─────────────────────────────────────────────────────────────────────────────
// Loading view
// ─────────────────────────────────────────────────────────────────────────────

class HomeChatLoadingView extends StatelessWidget {
  HomeChatLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error view
// ─────────────────────────────────────────────────────────────────────────────

class HomeChatErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  HomeChatErrorView({
    super.key,
    required this.message,
    required this.onRetry,
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
            Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 52),
            const SizedBox(height: 14),
            Text(
              'Unable to load chats',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
