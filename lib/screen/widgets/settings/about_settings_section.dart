import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/app_feedback.dart';
import 'settings_divider.dart';
import 'settings_navigation_title.dart';
import 'settings_section_title.dart';

class AboutSettingsSection extends StatelessWidget {
  final String appVersion;
  final String buildNumber;

  const AboutSettingsSection({
    super.key,
    required this.appVersion,
    required this.buildNumber,
  });

  Future<void> _openUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      final bool didOpen = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!didOpen) {
        _showOpenLinkError();
      }
    } catch (error, stackTrace) {
      debugPrint('Open URL error: $error');
      debugPrintStack(stackTrace: stackTrace);

      _showOpenLinkError();
    }
  }

  void _showOpenLinkError() {
    AppFeedback.showMessage(
      title: 'unable_to_open_link'.tr,
      message: 'could_not_open_link'.tr,
      icon: Icons.error_outline_rounded,
    );
  }

  Future<void> _copyVersion() async {
    await Clipboard.setData(
      ClipboardData(
        text: '$appVersion ($buildNumber)',
      ),
    );

    await HapticFeedback.selectionClick();

    AppFeedback.showMessage(
      title: 'app_version'.tr,
      message: 'version_copied'.tr,
      icon: Icons.content_copy_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(
          title: 'about'.tr,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: dividerColor,
            ),
          ),
          child: Column(
            children: [
              SettingsNavigationTile(
                icon: Icons.info_outline_rounded,
                title: 'app_version'.tr,
                subtitle: 'tap_to_copy'.tr,
                trailingText: appVersion,
                onTap: _copyVersion,
              ),
              SettingsDivider(
                color: dividerColor,
              ),
              SettingsNavigationTile(
                icon: Icons.description_outlined,
                title: 'terms_of_service'.tr,
                subtitle: 'read_our_terms'.tr,
                onTap: () {
                  _openUrl(
                    'https://example.com/terms',
                  );
                },
              ),
              SettingsDivider(
                color: dividerColor,
              ),
              SettingsNavigationTile(
                icon: Icons.privacy_tip_outlined,
                title: 'privacy_policy'.tr,
                subtitle: 'read_our_policy'.tr,
                onTap: () {
                  _openUrl(
                    'https://example.com/privacy',
                  );
                },
              ),
              SettingsDivider(
                color: dividerColor,
              ),
              SettingsNavigationTile(
                icon: Icons.star_outline_rounded,
                title: 'rate_app'.tr,
                subtitle: 'leave_a_review'.tr,
                onTap: () {
                  _openUrl(
                    'https://example.com/rate',
                  );
                },
              ),
              SettingsDivider(
                color: dividerColor,
              ),
              SettingsNavigationTile(
                icon: Icons.help_outline_rounded,
                title: 'help_support'.tr,
                subtitle: 'contact_support'.tr,
                onTap: () {
                  _openUrl(
                    'mailto:support@example.com',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}