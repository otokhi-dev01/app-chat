import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings/settings_controller.dart';

/// Standalone logout button with a built-in iOS Cupertino confirmation dialog.
/// Reusable anywhere you have access to SettingsController.
class LogoutButton extends StatelessWidget {
  final SettingsController controller;

  const LogoutButton({
    super.key,
    required this.controller,
  });

  void _confirmLogout(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text('logout'.tr),
          content: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('logout_confirmation'.tr),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.logout();
              },
              child: Text('logout'.tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color redColor = isDark ? Color(0xFFFF453A) : Color(0xFFFF3B30);

    Color backgroundColor = redColor.withValues(
      alpha: isDark ? 0.12 : 0.08,
    );

    Color borderColor = redColor.withValues(
      alpha: isDark ? 0.25 : 0.20,
    );

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: () => _confirmLogout(context),
          borderRadius: BorderRadius.circular(22),
          highlightColor: redColor.withValues(alpha: 0.06),
          splashColor: redColor.withValues(alpha: 0.12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.15 : 0.03,
                  ),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.square_arrow_right,
                  size: 20,
                  color: redColor,
                ),
                SizedBox(width: 8),
                Text(
                  'logout'.tr,
                  style: TextStyle(
                    color: redColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}