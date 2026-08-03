import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/blocked_contact_model.dart';

class BlockedContactTile extends StatelessWidget {
  final BlockedContactModel contact;
  final VoidCallback onUnblock;
  final bool isUnblocking;

  const BlockedContactTile({
    super.key,
    required this.contact,
    required this.onUnblock,
    this.isUnblocking = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool hasImage = contact.avatarUrl.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colorScheme.primary.withValues(
              alpha: 0.11,
            ),
            backgroundImage: hasImage
                ? NetworkImage(
              contact.avatarUrl,
            )
                : null,
            child: hasImage
                ? null
                : Icon(
              CupertinoIcons.person_fill,
              color: colorScheme.primary,
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  contact.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            minimumSize: Size(0, 32),
            color: colorScheme.primary.withValues(
              alpha: 0.11,
            ),
            disabledColor: colorScheme.primary.withValues(
              alpha: 0.06,
            ),
            borderRadius: BorderRadius.circular(14),
            onPressed: isUnblocking ? null : onUnblock,
            child: isUnblocking
                ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.8,
                color: colorScheme.primary,
              ),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.lock_open,
                  size: 14,
                  color: colorScheme.primary,
                ),
                SizedBox(width: 4),
                Text(
                  'unblock'.tr,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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