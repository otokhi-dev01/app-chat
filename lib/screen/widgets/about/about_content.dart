import 'package:flutter/material.dart';

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
          title: 'Application',
        ),
        SizedBox(height: 10),

        AboutMenuCard(
          children: [
            AboutMenuTile(
              icon: Icons.info_outline_rounded,
              title: 'Version',
              subtitle: '1.0.0',
              showArrow: false,
            ),
            AboutMenuDivider(),
            AboutMenuTile(
              icon: Icons.system_update_alt_rounded,
              title: 'Check for updates',
              subtitle: 'You are using the latest version',
              onTap: () {},
            ),
            AboutMenuDivider(),
            AboutMenuTile(
              icon: Icons.description_outlined,
              title: 'Terms of service',
              subtitle: 'Read our terms and conditions',
              onTap: () {},
            ),
            AboutMenuDivider(),
            AboutMenuTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy policy',
              subtitle: 'Learn how your data is protected',
              onTap: () {},
            ),
          ],
        ),

        SizedBox(height: 24),

        AboutSectionTitle(
          title: 'Support',
        ),
        SizedBox(height: 10),

        AboutMenuCard(
          children: [
            AboutMenuTile(
              icon: Icons.help_outline_rounded,
              title: 'Help center',
              subtitle: 'Get help using the application',
              onTap: () {},
            ),
            AboutMenuDivider(),
            AboutMenuTile(
              icon: Icons.mail_outline_rounded,
              title: 'Contact support',
              subtitle: 'Send a message to our support team',
              onTap: () {},
            ),
            AboutMenuDivider(),
            AboutMenuTile(
              icon: Icons.star_outline_rounded,
              title: 'Rate application',
              subtitle: 'Share your experience',
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