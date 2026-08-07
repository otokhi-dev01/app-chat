import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/user/user_controller.dart';
import 'profile_add_contact_button.dart';
import 'profile_content_filter.dart';
import 'profile_content_view.dart';
import 'profile_detail_action.dart';
import 'profile_detail_header.dart';
import 'profile_detail_info_section.dart';

class ProfileDetailContent extends StatelessWidget {
  final UserController controller;

  final ProfileContentFilterType selectedFilter;

  final ValueChanged<ProfileContentFilterType> onFilterChanged;

  final VoidCallback onMessage;
  final VoidCallback onCall;
  final VoidCallback onMore;
  final VoidCallback onAddContact;

  const ProfileDetailContent({
    super.key,
    required this.controller,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onMessage,
    required this.onCall,
    required this.onMore,
    required this.onAddContact,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        bool isOnline =
            controller.status.value.trim().toLowerCase() == 'online';

        return SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  14,
                  14,
                  14,
                  24,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ProfileDetailHeader(
                        name: controller.name.value,
                        status: controller.status.value,
                        imageUrl: controller.profileImageUrl.value,
                        isOnline: isOnline,
                      ),
                      SizedBox(height: 14),
                      ProfileActions(
                        onMessage: onMessage,
                        onCall: onCall,
                        onMore: onMore,
                      ),
                      SizedBox(height: 10),
                      ProfileAddContactButton(
                        onTap: onAddContact,
                      ),
                      SizedBox(height: 14),
                      ProfileInfoSection(
                        phoneNumber: controller.phoneNumber.value,
                        username: controller.username.value,
                        bio: controller.bio.value,
                      ),
                      SizedBox(height: 14),
                      ProfileContentFilter(
                        selectedFilter: selectedFilter,
                        onChanged: onFilterChanged,
                      ),
                      SizedBox(height: 10),
                      ProfileContentView(
                        selectedFilter: selectedFilter,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}