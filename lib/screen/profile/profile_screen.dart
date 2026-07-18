import 'package:appchat/screen/profile/qr_code/profile_qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/settings/settings_controller.dart';
import '../../route/app_route.dart';

// Import your custom settings widgets
import '../widgets/settings/account_screen.dart';
import '../widgets/settings/general_settings_section.dart'; // Adjust path as needed

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  String _firstLetter(String name) {
    String value = name.trim();

    if (value.isEmpty) {
      return '?';
    }

    return value[0].toUpperCase();
  }

  void _openEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  void _copyUsername(
      BuildContext context,
      String username,
      ) {
    String value = username.trim();

    if (value.isEmpty) {
      return;
    }

    Clipboard.setData(
      ClipboardData(text: value),
    );

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Get.rawSnackbar(
      messageText: const Text(
        'Username copied to clipboard',
        style: TextStyle(
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
    SettingsController controller = Get.find<SettingsController>();

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Obx(
          () {
        String name = controller.userName.value.trim();
        String email = controller.userEmail.value.trim();
        String username = controller.userUsername.value.trim();

        return ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            14,
            16,
            14,
            110,
          ),
          children: [
            // 1. Profile Header Card
            Container(
              padding: const EdgeInsets.fromLTRB(
                18,
                24,
                18,
                20,
              ),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: borderColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.18 : 0.05,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 104,
                        height: 104,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.24),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _firstLetter(name),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: 2,
                        child: _BouncyProfileButton(
                          onTap: _openEditProfile,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: colorScheme.onPrimary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name.isEmpty ? 'Your Name' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email.isEmpty ? 'No email address' : email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _ProfileActionButton(
                          icon: Icons.edit_rounded,
                          label: 'Edit',
                          onTap: _openEditProfile,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ProfileActionButton(
                          icon: Icons.alternate_email_rounded,
                          label: 'Username',
                          onTap: () {
                            _copyUsername(
                              context,
                              username,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ProfileActionButton(
                          icon: Icons.qr_code_rounded,
                          label: 'QR Code',
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            Get.to(
                                  () => ProfileQrCodeScreen(
                                name: name,
                                username: username,
                              ),
                              transition: Transition.rightToLeft,
                              duration: const Duration(
                                milliseconds: 280,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // 2. Dynamic Account Settings Section (Imported & Standardized)
            AccountSettingsSection(controller: controller),

            const SizedBox(height: 22),

            // 3. Dynamic General Settings Section (Imported & Standardized)
            GeneralSettingsSection(controller: controller),
          ],
        );
      },
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    return _BouncyProfileButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: 22,
            ),
            const SizedBox(height: 7),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom stateful press animation to keep the main widget stateless
class _BouncyProfileButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncyProfileButton({
    required this.child,
    required this.onTap,
  });

  @override
  State<_BouncyProfileButton> createState() => _BouncyProfileButtonState();
}

class _BouncyProfileButtonState extends State<_BouncyProfileButton> {
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
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}