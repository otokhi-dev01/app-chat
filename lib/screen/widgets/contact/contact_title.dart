import 'package:flutter/material.dart';

import '../../../models/contact_model.dart';

class ContactTile extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback? onTap;

  ContactTile({
    super.key,
    required this.contact,
    this.onTap,
  });

  String get firstLetter {
    String name = contact.name.trim();

    if (name.isEmpty) {
      return '?';
    }

    return name[0].toUpperCase();
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

  Color _statusColor(
      ColorScheme colorScheme,
      ) {
    switch (contact.status) {
      case ContactStatus.online:
        return Color(0xFF32C766);

      case ContactStatus.recently:
        return colorScheme.primary;

      case ContactStatus.offline:
        return colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color tileColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFE7E9ED);

    Color statusColor =
    _statusColor(colorScheme);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      child: Material(
        color: tileColor,
        borderRadius:
        BorderRadius.circular(17),
        child: InkWell(
          onTap: onTap,
          borderRadius:
          BorderRadius.circular(17),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(17),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.primary
                            .withValues(
                          alpha: 0.13,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary
                              .withValues(
                            alpha: 0.20,
                          ),
                        ),
                      ),
                      child: Text(
                        firstLetter,
                        style: TextStyle(
                          color:
                          colorScheme.primary,
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                    if (contact.status ==
                        ContactStatus.online)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color:
                            Color(0xFF32C766),
                            shape:
                            BoxShape.circle,
                            border: Border.all(
                              color: tileColor,
                              width: 2.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 13),
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
                          color:
                          colorScheme.onSurface,
                          fontWeight:
                          FontWeight.w600,
                          fontSize: 15.5,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration:
                            BoxDecoration(
                              color: statusColor,
                              shape:
                              BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              statusText,
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style: theme
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight:
                                contact.status ==
                                    ContactStatus
                                        .online
                                    ? FontWeight
                                    .w600
                                    : FontWeight
                                    .w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withValues(alpha: 0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons
                        .chevron_right_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}