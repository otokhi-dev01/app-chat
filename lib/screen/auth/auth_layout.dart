import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/settings/settings_controller.dart';
import '../widgets/app_language_dropdown.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final bool showLanguageDropdown;
  final MainAxisAlignment mainAxisAlignment;

  const AuthLayout({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.maxWidth = 520,
    this.showLanguageDropdown = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  Alignment get _contentAlignment {
    switch (mainAxisAlignment) {
      case MainAxisAlignment.start:
        return Alignment.topCenter;

      case MainAxisAlignment.end:
        return Alignment.bottomCenter;

      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    SettingsController settingsController =
    Get.find<SettingsController>();

    return Scaffold(
      backgroundColor:
      theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus
              ?.unfocus();
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (
                BuildContext context,
                BoxConstraints constraints,
                ) {
              double availableHeight =
                  constraints.maxHeight -
                      padding.vertical;

              double languageSpace =
              showLanguageDropdown ? 64 : 0;

              double contentHeight =
                  availableHeight - languageSpace;

              if (contentHeight < 0) {
                contentHeight = 0;
              }

              return SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,
                physics:
                const BouncingScrollPhysics(),
                padding: padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: availableHeight,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxWidth,
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: languageSpace,
                            ),
                            child: ConstrainedBox(
                              constraints:
                              BoxConstraints(
                                minHeight:
                                contentHeight,
                              ),
                              child: Align(
                                alignment:
                                _contentAlignment,
                                child: SizedBox(
                                  width:
                                  double.infinity,
                                  child: child,
                                ),
                              ),
                            ),
                          ),

                          if (showLanguageDropdown)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: SizedBox(
                                width: 130,
                                child:
                                AppLanguageDropdown(
                                  controller:
                                  settingsController,
                                ),
                              ),
                            ),
                        ],
                      ),
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