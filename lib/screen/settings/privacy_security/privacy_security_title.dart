import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyNavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  const PrivacyNavigationTile({
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
    bool isDark = theme.brightness == Brightness.dark;

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
        overlayColor: WidgetStateProperty.resolveWith(
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
            crossAxisAlignment: CrossAxisAlignment.center,
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

class _PrivacyNavigationTrailing extends StatelessWidget {
  final String? trailingText;

  const _PrivacyNavigationTrailing({
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
        if (trailingText != null && trailingText!.trim().isNotEmpty)
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        if (trailingText != null && trailingText!.trim().isNotEmpty)
          SizedBox(width: 3),
        SizedBox(
          width: 28,
          height: 42,
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              CupertinoIcons.chevron_right,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
              size: 18,
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

  const PrivacySwitchTile({
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

    bool isDark = theme.brightness == Brightness.dark;

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
        onTap: () {
          onChanged(!value);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith(
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
              CupertinoSwitch(
                value: value,
                activeTrackColor: colorScheme.primary,
                onChanged: onChanged,
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

  const PrivacyActionTile({
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

    bool isDark = theme.brightness == Brightness.dark;

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
        overlayColor: WidgetStateProperty.resolveWith(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(
                    alpha: 0.09,
                  ),
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.error,
                  size: 20,
                ),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
                  alignment: Alignment.centerRight,
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    color: colorScheme.error,
                    size: 18,
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

class PrivacySecurityIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  const PrivacySecurityIcon({
    super.key,
    required this.icon,
    this.active = true, // Defaults to true to match Account Section primary badge style
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color primary = colorScheme.primary;

    Color bgColor = active
        ? primary.withValues(alpha: 0.11)
        : colorScheme.surfaceContainerHighest;

    Color iconColor = active ? primary : colorScheme.onSurfaceVariant;

    return AnimatedContainer(
      duration: Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        size: 20,
        color: iconColor,
      ),
    );
  }
}

class PrivacySecurityTileText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;

  const PrivacySecurityTileText({
    super.key,
    required this.title,
    required this.subtitle,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: active ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
            height: 1.25,
          ) ??
              TextStyle(
                color: active ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              ),
          child: Text(
            title,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
        SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}