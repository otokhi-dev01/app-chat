import 'package:flutter/material.dart';

class ProfileInfoSection
    extends StatelessWidget {
  final String phoneNumber;
  final String username;
  final String bio;

  ProfileInfoSection({
    super.key,
    required this.phoneNumber,
    required this.username,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white
        .withValues(alpha: 0.08)
        : Colors.black
        .withValues(alpha: 0.06);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withValues(alpha: 0.11),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons
                        .person_outline_rounded,
                    color: colorScheme.primary,
                    size: 18,
                  ),
                ),

                SizedBox(width: 10),

                Text(
                  'Profile information',
                  style: theme
                      .textTheme.titleSmall
                      ?.copyWith(
                    color:
                    colorScheme.onSurface,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: borderColor,
          ),

          ProfileInfoTile(
            icon: Icons.phone_iphone_rounded,
            title: phoneNumber,
            subtitle: 'Mobile',
          ),

          _ProfileDivider(
            color: borderColor,
          ),

          ProfileInfoTile(
            icon:
            Icons.alternate_email_rounded,
            title: username,
            subtitle: 'Username',
          ),

          _ProfileDivider(
            color: borderColor,
          ),

          ProfileInfoTile(
            icon: Icons.info_outline_rounded,
            title: bio,
            subtitle: 'Bio',
            showArrow: false,
          ),
        ],
      ),
    );
  }
}

class ProfileInfoTile
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showArrow;
  final VoidCallback? onTap;

  ProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    String displayTitle =
    title.trim().isEmpty
        ? 'Not available'
        : title;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            13,
            14,
            13,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withValues(alpha: 0.10),
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 21,
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle,
                      maxLines:
                      subtitle == 'Bio' ? 3 : 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme.bodyMedium
                          ?.copyWith(
                        color:
                        colorScheme.onSurface,
                        fontSize: 15,
                        height: 1.3,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              if (showArrow) ...[
                SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme
                      .onSurfaceVariant,
                  size: 22,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileDivider
    extends StatelessWidget {
  final Color color;

  _ProfileDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 70,
      ),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
      ),
    );
  }
}