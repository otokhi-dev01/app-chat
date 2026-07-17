import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Clipboard and Haptics
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';

class AccountSettingsSection extends StatelessWidget {
  final SettingsController controller;

  const AccountSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 6,
            right: 6,
            bottom: 8,
          ),
          child: Text(
            'account'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1D22) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: dividerColor,
            ),
          ),
          child: Obx(
                () => Column(
              children: [
                _AccountTile(
                  icon: Icons.person_outline_rounded,
                  label: 'name'.tr,
                  value: controller.userName.value,
                ),
                _AccountDivider(color: dividerColor),
                _AccountTile(
                  icon: Icons.phone_outlined,
                  label: 'phone'.tr,
                  value: controller.userPhone.value,
                ),
                _AccountDivider(color: dividerColor),
                _AccountTile(
                  icon: Icons.email_outlined,
                  label: 'email'.tr,
                  value: controller.userEmail.value,
                ),
              ],
            ),
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

  const _AccountTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  void _copyToClipboard(BuildContext context) {
    if (value.trim().isEmpty) return;

    // Copies to clipboard and gives feedback
    Clipboard.setData(ClipboardData(text: value));
    HapticFeedback.mediumImpact();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Smooth floaty GetX snackbar
    Get.rawSnackbar(
      messageText: Text(
        '${label.capitalizeFirst} copied to clipboard',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      backgroundColor: colorScheme.primary,
      borderRadius: 14,
      margin: const EdgeInsets.all(14),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;

    final String displayValue = value.trim().isEmpty ? 'not_set'.tr : value;

    return _BouncyTileEffect(
      onTap: () => _copyToClipboard(context),
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
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                size: 22,
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
            // Subtle, clean indicator that blends seamlessly into the design
            if (value.trim().isNotEmpty) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.copy_rounded,
                size: 16,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
              ),
            ],
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

// 4. Lightweight private stateful gesture handler to keep tiles stateless and reusable
class _BouncyTileEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncyTileEffect({
    required this.child,
    required this.onTap,
  });

  @override
  State<_BouncyTileEffect> createState() => _BouncyTileEffectState();
}

class _BouncyTileEffectState extends State<_BouncyTileEffect> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}