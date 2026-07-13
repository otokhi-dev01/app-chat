import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final String displayName = name.trim().isEmpty
        ? 'user'.tr
        : name.trim();

    final String displayEmail = email.trim().isEmpty
        ? 'not_set'.tr
        : email.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        24,
        18,
        20,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 112,
                height: 112,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(
                      alpha: 0.22,
                    ),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor:
                  colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 66,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              Positioned(
                right: -2,
                bottom: 3,
                child: Material(
                  color: colorScheme.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onEditProfile,
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Icon(
                        Icons.edit_rounded,
                        size: 18,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            displayEmail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: onEditProfile,
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
            ),
            label: Text(
              'edit_profile'.tr,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 11,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}