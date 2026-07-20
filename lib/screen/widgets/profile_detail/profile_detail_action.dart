import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback? onMessage;
  final VoidCallback? onCall;
  final VoidCallback? onMore;

  ProfileActions({
    super.key,
    this.onMessage,
    this.onCall,
    this.onMore,
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
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ProfileActionButton(
              icon: Icons
                  .chat_bubble_outline_rounded,
              label: 'Message',
              onTap: onMessage,
            ),
          ),
          Expanded(
            child: ProfileActionButton(
              icon: Icons.call_outlined,
              label: 'Call',
              onTap: onCall,
            ),
          ),
          Expanded(
            child: ProfileActionButton(
              icon: Icons.more_horiz_rounded,
              label: 'More',
              onTap: onMore,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileActionButton
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isEnabled = onTap != null;

    Color foregroundColor = isEnabled
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant
        .withValues(
      alpha: 0.55,
    );

    Color backgroundColor = isEnabled
        ? colorScheme.primary.withValues(
      alpha: 0.11,
    )
        : colorScheme.onSurface.withValues(
      alpha: 0.05,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          16,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                ),
                child: Icon(
                  icon,
                  color: foregroundColor,
                  size: 23,
                ),
              ),
              SizedBox(height: 7),
              Text(
                label,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: theme
                    .textTheme.bodySmall
                    ?.copyWith(
                  color: foregroundColor,
                  fontSize: 11.5,
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