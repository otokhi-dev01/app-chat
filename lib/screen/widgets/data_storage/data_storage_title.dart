import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataStorageNavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback onTap;

  const DataStorageNavigationTile({
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
            12,
            9,
            6,
            9,
          ),
          child: Row(
            children: [
              DataStorageIcon(
                icon: icon,
              ),
              SizedBox(width: 11),
              Expanded(
                child: DataStorageTileText(
                  title: title,
                  subtitle: subtitle,
                ),
              ),
              SizedBox(width: 6),
              if (trailingText != null)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 88,
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
                SizedBox(width: 2),
              SizedBox(
                width: 24,
                height: 38,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    CupertinoIcons.chevron_right,
                    color: colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.55,
                    ),
                    size: 16,
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

  const DataStorageSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            12,
            9,
            8,
            9,
          ),
          child: Row(
            children: [
              DataStorageIcon(
                icon: icon,
                active: value,
              ),
              SizedBox(width: 11),
              Expanded(
                child: DataStorageTileText(
                  title: title,
                  subtitle: subtitle,
                  active: value,
                ),
              ),
              SizedBox(width: 6),
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

class DataStorageActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final bool loading;
  final VoidCallback onTap;

  const DataStorageActionTile({
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
            12,
            9,
            8,
            9,
          ),
          child: Row(
            children: [
              DataStorageIcon(
                icon: icon,
                active: true,
              ),
              SizedBox(width: 11),
              Expanded(
                child: DataStorageTileText(
                  title: title,
                  subtitle: subtitle,
                ),
              ),
              SizedBox(width: 6),
              if (loading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: colorScheme.primary,
                  ),
                )
              else if (trailingText != null)
                Text(
                  trailingText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 11,
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

  const DataStorageIcon({
    super.key,
    required this.icon,
    this.active = true,
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
      width: 38, // Compact 38x38 badge icon container
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 18,
        color: iconColor,
      ),
    );
  }
}

class DataStorageTileText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;

  const DataStorageTileText({
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
            fontSize: 13.5, // Sleek compact title size
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
            height: 1.25,
          ) ??
              TextStyle(
                color: active ? colorScheme.primary : colorScheme.onSurface,
                fontSize: 13.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              ),
          child: Text(
            title,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
        SizedBox(height: 2),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 10.5, // Sleek compact subtitle size
            height: 1.30,
          ),
        ),
      ],
    );
  }
}