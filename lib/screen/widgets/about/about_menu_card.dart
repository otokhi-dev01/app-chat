import 'package:flutter/material.dart';

class AboutMenuCard extends StatelessWidget {
  final List<Widget> children;

  AboutMenuCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class AboutMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showArrow;
  final VoidCallback? onTap;

  AboutMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            13,
            12,
            13,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                  BorderRadius.circular(14),
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
                      title,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow) ...[
                SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color:
                  colorScheme.onSurfaceVariant,
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

class AboutMenuDivider extends StatelessWidget {
  AboutMenuDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark =
        theme.brightness == Brightness.dark;

    Color dividerColor = isDark
        ? Colors.white.withValues(
      alpha: 0.07,
    )
        : Colors.black.withValues(
      alpha: 0.05,
    );

    return Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      endIndent: 14,
      color: dividerColor,
    );
  }
}