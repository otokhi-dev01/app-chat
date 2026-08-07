import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/contact_model.dart';

class AddGroupContactTile extends StatelessWidget {
  final ContactModel contact;
  final bool selected;
  final VoidCallback onTap;

  const AddGroupContactTile({
    super.key,
    required this.contact,
    required this.selected,
    required this.onTap,
  });

  bool get isOnline {
    return contact.status == ContactStatus.online;
  }

  String get statusText {
    switch (contact.status) {
      case ContactStatus.online:
        return 'online'.tr;

      case ContactStatus.recently:
        return 'recently_active'.tr;

      case ContactStatus.offline:
        return 'offline'.tr;
    }
  }

  String get firstLetter {
    String name = contact.name.trim();

    if (name.isEmpty) {
      return '?';
    }

    return name.substring(
      0,
      1,
    ).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    bool hasImage = contact.avatarUrl.trim().isNotEmpty;

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.08,
    )
        : Colors.transparent;

    Color statusColor = isOnline
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    Color badgeBorderColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary.withValues(
                      alpha: 0.12,
                    ),
                    backgroundImage: hasImage
                        ? NetworkImage(
                      contact.avatarUrl,
                    )
                        : null,
                    child: hasImage
                        ? null
                        : Text(
                      firstLetter,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: Color(0xFF32C766),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: badgeBorderColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
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
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontSize: 14.5,
                        fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            contact.username.trim().isNotEmpty
                                ? '${contact.username} · $statusText'
                                : '${contact.phoneNumber} · $statusText',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.primary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Icon(
                  CupertinoIcons.checkmark,
                  size: 13,
                  color: colorScheme.onPrimary,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}