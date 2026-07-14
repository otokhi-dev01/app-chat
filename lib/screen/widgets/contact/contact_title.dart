import 'package:flutter/material.dart';
import '../../../models/contact_model.dart';
import 'contact_avatar.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;

  const ContactTile({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isOnline = contact.status == ContactStatus.online;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: theme.colorScheme.primary.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ContactAvatar(name: contact.name, isOnline: isOnline),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.statusLabel,
                    style: TextStyle(
                      fontSize: 13,
                      color: isOnline
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}