import 'package:flutter/material.dart';

class DataStorageNavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  DataStorageNavigationTile({
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            12,
            5,
            12,
          ),
          child: Row(
            children: [
              DataStorageIcon(
                icon: icon,
              ),
              SizedBox(width: 13),
              Expanded(
                child: DataStorageTileText(
                  title: title,
                  subtitle: subtitle,
                ),
              ),
              SizedBox(width: 8),
              if (trailingText != null)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 92,
                  ),
                  child: Text(
                    trailingText!,
                    maxLines: 2,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (trailingText != null)
                SizedBox(width: 3),
              SizedBox(
                width: 28,
                height: 42,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
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

class DataStorageSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  DataStorageSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Material(
      color: value
          ? colorScheme.primary.withValues(
        alpha: 0.05,
      )
          : Colors.transparent,
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            12,
            10,
            12,
          ),
          child: Row(
            children: [
              DataStorageIcon(
                icon: icon,
                active: value,
              ),
              SizedBox(width: 13),
              Expanded(
                child: DataStorageTileText(
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

class DataStorageActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final bool loading;
  final VoidCallback onTap;

  DataStorageActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.loading,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            12,
            10,
            12,
          ),
          child: Row(
            children: [
              DataStorageIcon(
                icon: icon,
              ),
              SizedBox(width: 13),
              Expanded(
                child: DataStorageTileText(
                  title: title,
                  subtitle: subtitle,
                ),
              ),
              SizedBox(width: 8),
              if (loading)
                SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                )
              else if (trailingText != null)
                Text(
                  trailingText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataStorageIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  DataStorageIcon({
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
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: active
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant,
        size: 21,
      ),
    );
  }
}

class DataStorageTileText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;

  DataStorageTileText({
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
        Text(
          title,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: theme.textTheme.bodyLarge?.copyWith(
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