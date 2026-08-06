import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/profile/delete_account_controller.dart';

class DeleteAccountView extends GetView<DeleteAccountController> {
  DeleteAccountView({super.key});

  Future<void> _confirmDeletion(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text('delete_account_question'.tr),
          content: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('delete_account_confirmation'.tr),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text('cancel'.tr),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('delete_permanently'.tr),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await controller.deleteAccount();
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color appBarColor = isDark
        ? Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    Color actionBackground = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    SystemUiOverlayStyle overlayStyle = isDark
        ? SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    )
        : SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: theme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
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
        systemOverlayStyle: overlayStyle,
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
          padding: EdgeInsets.fromLTRB(12, 10, 6, 10),
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
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.back();
                },
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
          'delete_account'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colors = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.error.withValues(
                    alpha: isDark ? 0.12 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: colors.error.withValues(
                      alpha: isDark ? 0.22 : 0.15,
                    ),
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
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.error.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.exclamationmark_triangle_fill,
                        size: 32,
                        color: colors.error,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'permanently_delete_account'.tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'delete_account_warning_desc'.tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.error,
                      foregroundColor: colors.onError,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: controller.isDeleting.value
                        ? null
                        : () => _confirmDeletion(context),
                    icon: controller.isDeleting.value
                        ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.onError,
                      ),
                    )
                        : Icon(
                      CupertinoIcons.trash,
                      size: 20,
                    ),
                    label: Text(
                      controller.isDeleting.value
                          ? 'deleting_account'.tr
                          : 'delete_account'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}