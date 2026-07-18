import 'package:flutter/material.dart';

class PrivacyNavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  PrivacyNavigationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pressedColor = isDark
        ? Colors.white.withValues(
      alpha: 0.05,
    )
        : Colors.black.withValues(
      alpha: 0.035,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor:
        WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return pressedColor;
            }

            return Colors.transparent;
          },
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            12,
            5,
            12,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              PrivacySecurityIcon(
                icon: icon,
              ),
              SizedBox(width: 13),
              Expanded(
                child: PrivacySecurityTileText(
                  title: title,
                  subtitle: subtitle,
                ),
              ),
              SizedBox(width: 8),
              _PrivacyNavigationTrailing(
                trailingText: trailingText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyNavigationTrailing
    extends StatelessWidget {
  final String? trailingText;

  _PrivacyNavigationTrailing({
    required this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (trailingText != null &&
            trailingText!.trim().isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 88,
            ),
            child: Text(
              trailingText!,
              maxLines: 2,
              softWrap: true,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall
                  ?.copyWith(
                color: colorScheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        if (trailingText != null &&
            trailingText!.trim().isNotEmpty)
          SizedBox(width: 3),
        SizedBox(
          width: 28,
          height: 42,
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.chevron_right_rounded,
              color:
              colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

class PrivacySwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  PrivacySwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pressedColor = isDark
        ? Colors.white.withValues(
      alpha: 0.05,
    )
        : Colors.black.withValues(
      alpha: 0.035,
    );

    Color backgroundColor = value
        ? colorScheme.primary.withValues(
      alpha: 0.05,
    )
        : Colors.transparent;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor:
        WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return pressedColor;
            }

            return Colors.transparent;
          },
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            12,
            10,
            12,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              PrivacySecurityIcon(
                icon: icon,
                active: value,
              ),
              SizedBox(width: 13),
              Expanded(
                child: PrivacySecurityTileText(
                  title: title,
                  subtitle: subtitle,
                  active: value,
                ),
              ),
              SizedBox(width: 8),
              IgnorePointer(
                child: Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  PrivacyActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pressedColor = isDark
        ? colorScheme.error.withValues(
      alpha: 0.08,
    )
        : colorScheme.error.withValues(
      alpha: 0.05,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor:
        WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return pressedColor;
            }

            return Colors.transparent;
          },
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            12,
            10,
            12,
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
                  color: colorScheme.error
                      .withValues(
                    alpha: 0.09,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.error,
                  size: 21,
                ),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      softWrap: true,
                      overflow:
                      TextOverflow.visible,
                      style: theme
                          .textTheme.bodyLarge
                          ?.copyWith(
                        color:
                        colorScheme.error,
                        fontWeight:
                        FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      softWrap: true,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 28,
                height: 42,
                child: Align(
                  alignment:
                  Alignment.centerRight,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme
                        .onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacySecurityIcon
    extends StatelessWidget {
  final IconData icon;
  final bool active;

  PrivacySecurityIcon({
    super.key,
    required this.icon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active
            ? colorScheme.primary.withValues(
          alpha: 0.16,
        )
            : colorScheme
            .surfaceContainerHighest,
        borderRadius:
        BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: active
            ? colorScheme.primary
            : colorScheme
            .onSurfaceVariant,
        size: 21,
      ),
    );
  }
}

class PrivacySecurityTileText
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;

  PrivacySecurityTileText({
    super.key,
    required this.title,
    required this.subtitle,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: theme.textTheme.bodyLarge
              ?.copyWith(
            color: active
                ? colorScheme.primary
                : colorScheme.onSurface,
            fontWeight: active
                ? FontWeight.w700
                : FontWeight.w600,
            height: 1.25,
          ),
        ),
        SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall
              ?.copyWith(
            color:
            colorScheme.onSurfaceVariant,
            fontSize: 11,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}