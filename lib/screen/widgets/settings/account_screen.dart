import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/profile/profile_controller.dart';
import '../../../route/app_route.dart';

class AccountSettingsSection extends StatelessWidget {
  final ProfileController controller;

  const AccountSettingsSection({
    super.key,
    required this.controller,
  });

  void _openProfileDetails() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Get.currentRoute == AppRoutes.editProfile) {
      return;
    }

    Get.toNamed(
      AppRoutes.editProfile,
      preventDuplicates: true,
    );
  }

  void _openDeleteAccount() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (Get.currentRoute == AppRoutes.deleteAccount) {
      return;
    }

    Get.toNamed(
      AppRoutes.deleteAccount,
      preventDuplicates: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    Color cardColor = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 6,
            right: 6,
            bottom: 8,
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.person_crop_circle,
                color: colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'account'.tr,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: dividerColor,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.15 : 0.04,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(
                () {
              return Column(
                children: [
                  _AccountTile(
                    icon: CupertinoIcons.person,
                    label: 'name'.tr,
                    value: controller.userName.value,
                    onTap: _openProfileDetails,
                  ),
                  _AccountDivider(
                    color: dividerColor,
                  ),
                  _AccountTile(
                    icon: CupertinoIcons.phone,
                    label: 'phone'.tr,
                    value: controller.userPhone.value,
                    onTap: _openProfileDetails,
                  ),
                  _AccountDivider(
                    color: dividerColor,
                  ),
                  _AccountTile(
                    icon: CupertinoIcons.mail,
                    label: 'email'.tr,
                    value: controller.userEmail.value,
                    onTap: _openProfileDetails,
                  ),
                  _AccountDivider(
                    color: dividerColor,
                  ),
                  _DeleteAccountTile(
                    onTap: _openDeleteAccount,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _AccountTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color primary = colorScheme.primary;

    String displayValue =
    value.trim().isEmpty ? 'not_set'.tr : value;

    return _BouncyTileEffect(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primary.withValues(
                  alpha: 0.11,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 20,
                color: primary,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    displayValue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: value.trim().isEmpty
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: colorScheme.onSurfaceVariant.withValues(
                alpha: 0.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteAccountTile extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteAccountTile({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color errorColor = colorScheme.error;

    return _BouncyTileEffect(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: errorColor.withValues(
                  alpha: 0.11,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                CupertinoIcons.delete,
                size: 20,
                color: errorColor,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'delete_account'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: errorColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'delete_account_description'.tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: errorColor.withValues(
                alpha: 0.70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountDivider extends StatelessWidget {
  final Color color;

  const _AccountDivider({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 69,
      color: color,
    );
  }
}

class _BouncyTileEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncyTileEffect({
    required this.child,
    required this.onTap,
  });

  @override
  State<_BouncyTileEffect> createState() {
    return _BouncyTileEffectState();
  }
}

class _BouncyTileEffectState
    extends State<_BouncyTileEffect> {
  bool _isPressed = false;

  void _resetPressedState() {
    if (!mounted) {
      return;
    }

    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        _resetPressedState();
        widget.onTap();
      },
      onTapCancel: _resetPressedState,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1,
        duration: const Duration(
          milliseconds: 100,
        ),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}