import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'profile_content_card.dart';

class ProfileMockLinkContent extends StatelessWidget {
  ProfileMockLinkContent({super.key});

  final links = <_MockLinkItem>[
    _MockLinkItem('Flutter documentation', 'docs.flutter.dev', 'Build beautiful multiplatform apps.', CupertinoIcons.link),
    _MockLinkItem('Project design', 'figma.com/piitsiitchat', 'Latest PiitsiitChat UI design.', CupertinoIcons.square_pencil),
    _MockLinkItem('Project repository', 'github.com/piitsiitchat', 'Source code and project updates.', CupertinoIcons.text_quote),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < links.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == links.length - 1 ? 0 : 8),
            child: _ProfileLinkCard(link: links[i]),
          ),
      ],
    );
  }
}

class _ProfileLinkCard extends StatelessWidget {
  final _MockLinkItem link;

  const _ProfileLinkCard({required this.link});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ProfileContentCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(link.icon, color: colors.primary, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  link.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.primary, fontSize: 10, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  link.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 10),
                ),
              ],
            ),
          ),
          Icon(CupertinoIcons.arrow_up_right, color: colors.onSurfaceVariant, size: 16),
        ],
      ),
    );
  }
}

class _MockLinkItem {
  final String title;
  final String url;
  final String description;
  final IconData icon;

  _MockLinkItem(this.title, this.url, this.description, this.icon);
}