import 'package:flutter/material.dart';

import '../../../models/contact_model.dart';

class AddGroupContactTile extends StatelessWidget {
  final ContactModel contact;
  final bool selected;
  final VoidCallback onTap;

  AddGroupContactTile({
    super.key,
    required this.contact,
    required this.selected,
    required this.onTap,
  });

  bool get isOnline {
    return contact.status ==
        ContactStatus.online;
  }

  String get statusText {
    switch (contact.status) {
      case ContactStatus.online:
        return 'Online';

      case ContactStatus.recently:
        return 'Recently active';

      case ContactStatus.offline:
        return 'Offline';
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
    ColorScheme colorScheme =
        theme.colorScheme;

    bool hasImage =
        contact.avatarUrl.trim().isNotEmpty;

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.06,
    )
        : Colors.transparent;

    Color statusColor = isOnline
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor:
        Colors.transparent,
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
                    radius: 25,
                    backgroundColor: colorScheme
                        .surfaceContainerHighest,
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
                        color:
                        colorScheme.primary,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 1,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme
                                .scaffoldBackgroundColor,
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme.bodyLarge
                          ?.copyWith(
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
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
                            contact.username
                                .trim()
                                .isNotEmpty
                                ? '${contact.username} · $statusText'
                                : '${contact.phoneNumber} · $statusText',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: theme
                                .textTheme.bodySmall
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                              fontSize: 11,
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
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.primary
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Icon(
                  Icons.check_rounded,
                  size: 16,
                  color:
                  colorScheme.onPrimary,
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