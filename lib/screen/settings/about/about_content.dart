import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/app_feedback.dart';
import 'about_header.dart';
import 'about_menu_card.dart';

class AboutContent extends StatelessWidget {
  final String appVersion;
  final String buildNumber;

  const AboutContent({
    super.key,
    required this.appVersion,
    required this.buildNumber,
  });

  String get _versionText {
    if (buildNumber.isNotEmpty) {
      return '$appVersion ($buildNumber)';
    }
    return appVersion;
  }

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
      icon: CupertinoIcons.exclamationmark_circle,
    );
  }


  Future<void> _copyVersion() async {
    await Clipboard.setData(
      ClipboardData(
        text: _versionText,
      ),
    );

    await HapticFeedback.selectionClick();

    AppFeedback.showMessage(
      title: 'app_version'.tr,
      message: 'version_copied'.tr,
      icon: CupertinoIcons.doc_on_doc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        18,
        16,
        32,
      ),
      children: [
        AboutHeader(
          appVersion: appVersion,
        ),

        SizedBox(height: 24),

        AboutSectionTitle(
          title: 'application'.tr,
        ),

        SizedBox(height: 10),

        AboutMenuCard(
          children: [
            AboutMenuTile(
              icon: CupertinoIcons.info,
              title: 'version'.tr,
              subtitle: _versionText,
              showArrow: false,
              onTap: _copyVersion,
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.arrow_2_circlepath,
              title: 'check_for_updates'.tr,
              subtitle: 'latest_version_message'.tr,
              onTap: () {
                _openUrl(
                  'https://apps.apple.com/app/id6794264625',
                );
              },
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.doc_text,
              title: 'terms_of_service'.tr,
              subtitle: 'terms_of_service_description'.tr,
              onTap: () {
                _openUrl(
                  'https://otokhi.com/',
                );
              },
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.shield,
              title: 'privacy_policy'.tr,
              subtitle: 'privacy_policy_description'.tr,
              onTap: () {
                _openUrl(
                  'https://otokhi.com/',
                );
              },
            ),
          ],
        ),

        SizedBox(height: 24),

        AboutSectionTitle(
          title: 'support'.tr,
        ),

        SizedBox(height: 10),

        AboutMenuCard(
          children: [
            AboutMenuTile(
              icon: CupertinoIcons.question_circle,
              title: 'help_center'.tr,
              subtitle: 'help_center_description'.tr,
              onTap: () {
                _openUrl(
                  'https://otokhi.com/',
                );
              },
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.mail,
              title: 'contact_support'.tr,
              subtitle: 'contact_support_description'.tr,
              onTap: () {
                _openUrl(
                  'mailto:kimlifting@gmail.com',
                );
              },
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.star,
              title: 'rate_application'.tr,
              subtitle: 'rate_application_description'.tr,
              onTap: () {
                _openUrl(
                  'https://apps.apple.com/app/id6794264625?action=write-review',
                );
              },
            ),
          ],
        ),

        SizedBox(height: 24),

        AboutFooter(),
      ],
    );
  }
}