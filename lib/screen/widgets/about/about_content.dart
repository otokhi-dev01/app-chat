import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about_header.dart';
import 'about_menu_card.dart';

class AboutContent extends StatelessWidget {
  AboutContent({
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
              icon: Icons.info_outline_rounded,
              title: 'version'.tr,
              subtitle: '1.0.0',
              showArrow: false,
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: Icons.system_update_alt_rounded,
              title: 'check_for_updates'.tr,
              subtitle: 'latest_version_message'.tr,
              onTap: () {},
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: Icons.description_outlined,
              title: 'terms_of_service'.tr,
              subtitle: 'terms_of_service_description'.tr,
              onTap: () {},
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: Icons.privacy_tip_outlined,
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
              icon: Icons.help_outline_rounded,
              title: 'help_center'.tr,
              subtitle: 'help_center_description'.tr,
              onTap: () {},
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: Icons.mail_outline_rounded,
              title: 'contact_support'.tr,
              subtitle: 'contact_support_description'.tr,
              onTap: () {},
            ),

            AboutMenuDivider(),

            AboutMenuTile(
              icon: Icons.star_outline_rounded,
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