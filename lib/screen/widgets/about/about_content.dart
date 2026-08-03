import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'about_header.dart';
import 'about_menu_card.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({
    super.key,
  });

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
        AboutHeader(),

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
              subtitle: '1.0.0',
              showArrow: false,
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.arrow_2_circlepath,
              title: 'check_for_updates'.tr,
              subtitle: 'latest_version_message'.tr,
              onTap: () {},
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.doc_text,
              title: 'terms_of_service'.tr,
              subtitle: 'terms_of_service_description'.tr,
              onTap: () {},
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.shield,
              title: 'privacy_policy'.tr,
              subtitle: 'privacy_policy_description'.tr,
              onTap: () {},
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
              onTap: () {},
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.mail,
              title: 'contact_support'.tr,
              subtitle: 'contact_support_description'.tr,
              onTap: () {},
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: CupertinoIcons.star,
              title: 'rate_application'.tr,
              subtitle: 'rate_application_description'.tr,
              onTap: () {},
            ),
          ],
        ),

        SizedBox(height: 24),

        AboutFooter(),
      ],
    );
  }
}