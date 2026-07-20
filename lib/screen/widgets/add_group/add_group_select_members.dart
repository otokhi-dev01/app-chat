import 'package:flutter/material.dart';

import '../../../../models/contact_model.dart';

class AddGroupSelectedMembers
    extends StatelessWidget {
  final List<ContactModel> members;
  final ValueChanged<ContactModel>
  onRemoveMember;

  AddGroupSelectedMembers({
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
    ColorScheme colorScheme =
        theme.colorScheme;

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
          ContactModel contact =
          members[index];

          bool hasImage =
              contact.avatarUrl
                  .trim()
                  .isNotEmpty;

          return SizedBox(
            width: 64,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor:
                      colorScheme
                          .surfaceContainerHighest,
                      backgroundImage: hasImage
                          ? NetworkImage(
                        contact.avatarUrl,
                      )
                          : null,
                      child: hasImage
                          ? null
                          : Text(
                        contact.name
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                          color:
                          colorScheme
                              .primary,
                          fontWeight:
                          FontWeight
                              .w700,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Material(
                        color:
                        colorScheme.error,
                        shape: CircleBorder(),
                        child: InkWell(
                          onTap: () {
                            onRemoveMember(
                              contact,
                            );
                          },
                          customBorder:
                          CircleBorder(),
                          splashColor:
                          Colors.transparent,
                          highlightColor:
                          Colors.transparent,
                          child: SizedBox(
                            width: 21,
                            height: 21,
                            child: Icon(
                              Icons.close_rounded,
                              color: colorScheme
                                  .onError,
                              size: 14,
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
                  textAlign:
                  TextAlign.center,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme.bodySmall
                      ?.copyWith(
                    color:
                    colorScheme.onSurface,
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w600,
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