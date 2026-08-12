import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'profile_content_card.dart';

class ProfileMockFileContent extends StatelessWidget {
  ProfileMockFileContent({super.key});

  final files = <_MockFileItem>[
    _MockFileItem('Project proposal.pdf', '3.8 MB', 'Today, 9:42 AM', CupertinoIcons.doc_fill),
    _MockFileItem('UI design assets.zip', '18.2 MB', 'Yesterday', CupertinoIcons.archivebox_fill),
    _MockFileItem('Meeting notes.docx', '842 KB', 'Jul 20', CupertinoIcons.doc_text_fill),
    _MockFileItem('Budget report.xlsx', '1.4 MB', 'Jul 18', CupertinoIcons.table_fill),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < files.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == files.length - 1 ? 0 : 8),
            child: _ProfileFileCard(file: files[i]),
          ),
      ],
    );
  }
}

class _ProfileFileCard extends StatelessWidget {
  final _MockFileItem file;

  const _ProfileFileCard({required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ProfileContentCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
            child: Icon(file.icon, color: colors.primary, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${file.size} • ${file.date}',
                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Icon(CupertinoIcons.arrow_down_to_line, color: colors.primary, size: 18),
        ],
      ),
    );
  }
}

class _MockFileItem {
  final String name;
  final String size;
  final String date;
  final IconData icon;

  _MockFileItem(this.name, this.size, this.date, this.icon);
}
