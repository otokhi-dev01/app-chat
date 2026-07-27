import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widgets/auth/forgot_password_form.dart';

class ForgotPasswordScreen
    extends StatelessWidget {
  final Future<void> Function(String email)?
  onSubmit;

  const ForgotPasswordScreen({
    super.key,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;
    bool isDark =
        theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor:
        theme.scaffoldBackgroundColor,
        foregroundColor:
        colorScheme.onSurface,
        surfaceTintColor:
        Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle:
        SystemUiOverlayStyle(
          statusBarColor:
          Colors.transparent,
          statusBarIconBrightness:
          isDark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness:
          isDark
              ? Brightness.dark
              : Brightness.light,
        ),
        leading: IconButton(
          tooltip: 'back'.tr,
          onPressed: () {
            FocusManager
                .instance.primaryFocus
                ?.unfocus();

            Navigator.of(context)
                .maybePop();
          },
          icon: Icon(
            Icons
                .arrow_back_ios_new_rounded,
            color:
            colorScheme.onSurface,
            size: 21,
          ),
        ),
      ),
      body: GestureDetector(
        behavior:
        HitTestBehavior.translucent,
        onTap: () {
          FocusManager
              .instance.primaryFocus
              ?.unfocus();
        },
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (
                BuildContext context,
                BoxConstraints constraints,
                ) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,
                physics:
                BouncingScrollPhysics(),
                padding:
                EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                    constraints.maxHeight -
                        48,
                  ),
                  child: IntrinsicHeight(
                    child:
                    ForgotPasswordForm(
                      onSubmit: onSubmit,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}