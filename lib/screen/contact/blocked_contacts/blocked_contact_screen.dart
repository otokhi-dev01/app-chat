import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/contact/blocked_contact_controller.dart';
import '../../../models/blocked_contact_model.dart';
import 'blocked_contact_title.dart';
import 'blocked_contacts_empty_view.dart';
import 'blocked_contacts_info_card.dart';

class BlockedContactsScreen extends GetView<BlockedContactController> {
  const BlockedContactsScreen({
    super.key,
  });

  Future<void> _showUnblockDialog(
      BuildContext context,
      BlockedContactModel contact,
      ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showCupertinoDialog<void>(
      context: context,
      builder: (
          BuildContext dialogContext,
          ) {
        return CupertinoAlertDialog(
          title: Text(
            'unblock_contact'.tr,
          ),
          content: Padding(
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: Text(
              'unblock_confirmation'.trParams(
                {
                  'name': contact.name,
                },
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'cancel'.tr,
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(
                  dialogContext,
                );

                bool success = await controller.unblockContact(
                  contact,
                );

                if (!success) {
                  return;
                }

                _showUnblockedSnackBar(
                  contact.name,
                );
              },
              child: Text(
                'unblock'.tr,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUnblockedSnackBar(
      String name,
      ) {
    Get.closeAllSnackbars();

    Get.snackbar(
      'contact_unblocked'.tr,
      'contact_unblocked_message'.trParams(
        {
          'name': name,
        },
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 16,
      icon: Icon(
        CupertinoIcons.checkmark_circle,
      ),
      duration: Duration(
        seconds: 3,
      ),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  SystemUiOverlayStyle _overlayStyle(
      ThemeData theme,
      bool isDark,
      ) {
    if (isDark) {
      return SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );
    }

    return SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(
      alpha: 0.65,
    )
        : Colors.white.withValues(
      alpha: 0.70,
    );

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color actionBackground = isDark ? Color(0xFF1B1D22) : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle(
        theme,
        isDark,
      ),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          forceMaterialTransparency: true,
          titleSpacing: 0,
          leadingWidth: 58,
          systemOverlayStyle: _overlayStyle(
            theme,
            isDark,
          ),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 18,
                sigmaY: 18,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: appBarColor,
                  border: Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              10,
              6,
              10,
            ),
            child: Tooltip(
              message: 'back'.tr,
              child: Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: actionBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: borderColor,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.15 : 0.04,
                      ),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(40, 40),
                  onPressed: Get.back,
                  child: Icon(
                    CupertinoIcons.chevron_left,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            'blocked_contacts'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Obx(
              () {
            List<BlockedContactModel> contacts = controller.blockedContacts;

            return ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                40,
              ),
              children: [
                BlockedContactsInfoCard(),
                SizedBox(height: 20),
                if (contacts.isEmpty)
                  BlockedContactsEmptyView()
                else
                  Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(
                        22,
                      ),
                      border: Border.all(
                        color: borderColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.15 : 0.04,
                          ),
                          blurRadius: 8,
                          offset: Offset(
                            0,
                            2,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(
                        contacts.length,
                            (
                            int index,
                            ) {
                          BlockedContactModel contact = contacts[index];

                          bool showDivider = index < contacts.length - 1;

                          return Column(
                            children: [
                              BlockedContactTile(
                                contact: contact,
                                isUnblocking: controller.isUnblocking(
                                  contact.id,
                                ),
                                onUnblock: () {
                                  _showUnblockDialog(
                                    context,
                                    contact,
                                  );
                                },
                              ),
                              if (showDivider)
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 68,
                                  ),
                                  child: Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: borderColor,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}