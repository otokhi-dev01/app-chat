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

    // Validate the form first; abort if invalid
    final bool isValid = controller.formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text('delete_account_question'.tr),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color appBarColor = isDark
        ? const Color(0xFF1B1D22).withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.70);

    final Color actionBackground =
        isDark ? const Color(0xFF1B1D22) : Colors.white;

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final SystemUiOverlayStyle overlayStyle = isDark
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
      preferredSize: const Size.fromHeight(60),
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
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: appBarColor,
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          child: Tooltip(
            message: 'back'.tr,
            child: Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: actionBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.15 : 0.04,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 40),
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF1B1D22) : Colors.white;
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            physics: const BouncingScrollPhysics(),
            children: [
              // ── Warning Banner ────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                      offset: const Offset(0, 2),
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
                    const SizedBox(height: 16),
                    Text(
                      'permanently_delete_account'.tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
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

              const SizedBox(height: 24),

              // ── Password Fields ───────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.15 : 0.04,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.lock_fill,
                            size: 16,
                            color: colors.error,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'confirm_your_identity'.tr,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Password Field
                    Obx(() => _PasswordField(
                          controller: controller.passwordController,
                          label: 'password'.tr,
                          obscure: controller.obscurePassword.value,
                          onToggle: controller.togglePasswordVisibility,
                          validator: controller.validatePassword,
                          isDark: isDark,
                          borderColor: borderColor,
                          cardColor: cardColor,
                          theme: theme,
                          colors: colors,
                          textInputAction: TextInputAction.next,
                        )),

                    const SizedBox(height: 12),

                    // Confirm Password Field
                    Obx(() => _PasswordField(
                          controller: controller.confirmPasswordController,
                          label: 'confirm_password'.tr,
                          obscure: controller.obscureConfirmPassword.value,
                          onToggle: controller.toggleConfirmPasswordVisibility,
                          validator: controller.validateConfirmPassword,
                          isDark: isDark,
                          borderColor: borderColor,
                          cardColor: cardColor,
                          theme: theme,
                          colors: colors,
                          textInputAction: TextInputAction.done,
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Delete Button ─────────────────────────────────────────────
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
                        : const Icon(CupertinoIcons.trash, size: 20),
                    label: Text(
                      controller.isDeleting.value
                          ? 'deleting_account'.tr
                          : 'delete_account'.tr,
                      style: const TextStyle(
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

// ── Private password field widget ─────────────────────────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;
  final bool isDark;
  final Color borderColor;
  final Color cardColor;
  final ThemeData theme;
  final ColorScheme colors;
  final TextInputAction textInputAction;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
    required this.validator,
    required this.isDark,
    required this.borderColor,
    required this.cardColor,
    required this.theme,
    required this.colors,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      textInputAction: textInputAction,
      keyboardType: TextInputType.visiblePassword,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colors.onSurfaceVariant,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          CupertinoIcons.lock,
          size: 20,
          color: colors.error.withValues(alpha: 0.75),
        ),
        suffixIcon: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size(40, 40),
          onPressed: onToggle,
          child: Icon(
            obscure
                ? CupertinoIcons.eye_slash
                : CupertinoIcons.eye,
            size: 20,
            color: colors.onSurfaceVariant,
          ),
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.02),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colors.error.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
      ),
    );
  }
}