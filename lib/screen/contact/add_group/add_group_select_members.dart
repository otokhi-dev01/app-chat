import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/contact_model.dart';

class AddGroupSelectedMembers extends StatelessWidget {
  final List<ContactModel> members;
  final ValueChanged<ContactModel> onRemoveMember;

  const AddGroupSelectedMembers({
    super.key,
    required this.members,
    required this.onRemoveMember,
  });

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return SizedBox.shrink();
    }

    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color badgeBorderColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 2,
        ),
        itemCount: members.length,
        separatorBuilder: (
            BuildContext context,
            int index,
            ) {
          return SizedBox(width: 10);
        },
        itemBuilder: (
            BuildContext context,
            int index,
            ) {
          ContactModel contact = members[index];

          bool hasImage = contact.avatarUrl.trim().isNotEmpty;

          return SizedBox(
            width: 64,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      backgroundImage:
                      hasImage ? NetworkImage(contact.avatarUrl) : null,
                      child: hasImage
                          ? null
                          : Text(
                        contact.name.trim().isNotEmpty
                            ? contact.name.trim()[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Material(
                        color: colorScheme.error,
                        shape: CircleBorder(),
                        child: InkWell(
                          onTap: () {
                            onRemoveMember(
                              contact,
                            );
                          },
                          customBorder: CircleBorder(),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: badgeBorderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: colorScheme.onError,
                              size: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  contact.name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}