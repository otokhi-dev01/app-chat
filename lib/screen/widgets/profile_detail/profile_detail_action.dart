import 'package:flutter/material.dart';

class ProfileActions
    extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback? onMessage;
  final VoidCallback? onCall;
  final VoidCallback? onFollow;

  ProfileActions({
    super.key,
    required this.isFollowing,
    this.onMessage,
    this.onCall,
    this.onFollow,
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
        ? Colors.white
        .withValues(alpha: 0.08)
        : Colors.black
        .withValues(alpha: 0.06);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ProfileActionButton(
              icon:
              Icons.chat_bubble_outline_rounded,
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
              icon: isFollowing
                  ? Icons.person_remove_outlined
                  : Icons.person_add_alt_1_rounded,
              label: isFollowing
                  ? 'Unfollow'
                  : 'Follow',
              isActive: !isFollowing,
              onTap: onFollow,
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
  final bool isActive;
  final VoidCallback? onTap;

  ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    Color foregroundColor = isActive
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    Color backgroundColor = isActive
        ? colorScheme.primary
        .withValues(alpha: 0.11)
        : colorScheme.onSurface
        .withValues(alpha: 0.07);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 5,
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration:
                Duration(milliseconds: 180),
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                  BorderRadius.circular(16),
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
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}