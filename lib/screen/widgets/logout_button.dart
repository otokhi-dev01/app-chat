import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings/settings_controller.dart';

/// Standalone logout button with a built-in confirmation dialog.
/// Reusable anywhere you have access to SettingsController.
class LogoutButton extends StatelessWidget {
  final SettingsController controller;

  const LogoutButton({
    super.key,
    required this.controller,
  });

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('logout'.tr),
          content: Text('logout_confirmation'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.logout();
              },
              child: Text(
                'logout'.tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () => _confirmLogout(context),
        borderRadius: BorderRadius.circular(15),
        highlightColor: Colors.transparent,
        splashColor: Colors.red.withValues(alpha: 0.10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.red.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                size: 18,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                'logout'.tr,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}