import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../controllers/qr_code/qr_design_controller.dart';

Future<void> showQrDesignSheet(
    BuildContext context,
    ) async {
  FocusManager.instance.primaryFocus?.unfocus();

  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(
      alpha: 0.42,
    ),
    builder: (
        BuildContext sheetContext,
        ) {
      return _QrDesignSheet();
    },
  );
}

class _QrDesignSheet extends StatelessWidget {
  _QrDesignSheet();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    bool isDark = theme.brightness == Brightness.dark;

    Color sheetColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color cardColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    QrDesignController controller = Get.find<QrDesignController>();

    return Material(
      color: sheetColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHandle(),
              SizedBox(height: 16),
              _SheetHeader(
                onClose: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 18),
              _DesignSection(
                title: 'qr_style'.tr,
                icon: CupertinoIcons.square_grid_2x2,
                cardColor: cardColor,
                borderColor: borderColor,
                child: Obx(
                      () {
                    return Row(
                      children: [
                        Expanded(
                          child: _StyleOption(
                            label: 'sharp'.tr,
                            icon: CupertinoIcons.square,
                            selected: controller.moduleShape.value ==
                                QrDataModuleShape.square,
                            onTap: () {
                              controller.setModuleShape(
                                QrDataModuleShape.square,
                              );

                              controller.setEyeShape(
                                QrEyeShape.square,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _StyleOption(
                            label: 'rounded'.tr,
                            icon: CupertinoIcons.circle,
                            selected: controller.moduleShape.value ==
                                QrDataModuleShape.circle,
                            onTap: () {
                              controller.setModuleShape(
                                QrDataModuleShape.circle,
                              );

                              controller.setEyeShape(
                                QrEyeShape.circle,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 12),
              _DesignSection(
                title: 'qr_color'.tr,
                icon: CupertinoIcons.paintbrush,
                cardColor: cardColor,
                borderColor: borderColor,
                child: Obx(
                      () {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: QrDesignController.colorPresets.map(
                            (
                            Color color,
                            ) {
                          bool selected = controller.qrColor.value.toARGB32() ==
                              color.toARGB32();

                          return _ColorSwatch(
                            color: color,
                            selected: selected,
                            borderColor: borderColor,
                            onTap: () {
                              controller.setColor(
                                color,
                              );
                            },
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
              SizedBox(height: 12),
              _DesignSection(
                title: 'background'.tr,
                icon: CupertinoIcons.drop,
                cardColor: cardColor,
                borderColor: borderColor,
                child: Obx(
                      () {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: QrDesignController.backgroundPresets.map(
                            (
                            Color color,
                            ) {
                          bool selected =
                              controller.qrBackground.value.toARGB32() ==
                                  color.toARGB32();

                          return _ColorSwatch(
                            color: color,
                            selected: selected,
                            borderColor: borderColor,
                            alwaysBordered: true,
                            onTap: () {
                              controller.setBackground(
                                color,
                              );
                            },
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              _ResetButton(
                cardColor: cardColor,
                borderColor: borderColor,
                onTap: controller.reset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  _SheetHandle();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant.withValues(
          alpha: 0.28,
        ),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final VoidCallback onClose;

  _SheetHeader({
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color actionBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFF2F4F7);

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(
              alpha: 0.11,
            ),
            borderRadius: BorderRadius.circular(
              14,
            ),
          ),
          child: Icon(
            CupertinoIcons.qrcode,
            color: colorScheme.primary,
            size: 22,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'customize_qr_code'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'choose_style_and_colors'.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        // Unit Close Button UI
        Container(
          width: 36,
          height: 36,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: actionBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size(36, 36),
            onPressed: onClose,
            child: Icon(
              CupertinoIcons.xmark,
              size: 18,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _DesignSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color cardColor;
  final Color borderColor;
  final Widget child;

  _DesignSection({
    required this.title,
    required this.icon,
    required this.cardColor,
    required this.borderColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(
                    alpha: 0.11,
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 17,
                ),
              ),
              SizedBox(width: 9),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 13),
          child,
        ],
      ),
    );
  }
}

class _StyleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  _StyleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark = theme.brightness == Brightness.dark;

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(
      alpha: isDark ? 0.18 : 0.10,
    )
        : isDark
        ? Colors.white.withValues(
      alpha: 0.04,
    )
        : Colors.black.withValues(
      alpha: 0.025,
    );

    Color optionBorderColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.35,
    )
        : isDark
        ? Colors.white.withValues(
      alpha: 0.07,
    )
        : Colors.black.withValues(
      alpha: 0.05,
    );

    Color contentColor =
    selected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          16,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          height: 72,
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              16,
            ),
            border: Border.all(
              color: optionBorderColor,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: contentColor,
                size: 22,
              ),
              SizedBox(height: 5),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: contentColor,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final bool alwaysBordered;
  final Color borderColor;
  final VoidCallback onTap;

  _ColorSwatch({
    required this.color,
    required this.selected,
    required this.borderColor,
    required this.onTap,
    this.alwaysBordered = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Color outerBorderColor = selected
        ? colorScheme.primary
        : alwaysBordered
        ? borderColor
        : Colors.transparent;

    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: CircleBorder(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: outerBorderColor,
              width: selected ? 2.2 : 1,
            ),
          ),
          child: Container(
            width: selected ? 30 : 32,
            height: selected ? 30 : 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: color.computeLuminance() > 0.92
                    ? Colors.black.withValues(
                  alpha: 0.08,
                )
                    : Colors.transparent,
              ),
            ),
            child: selected
                ? Icon(
              CupertinoIcons.checkmark,
              color: color.computeLuminance() > 0.55
                  ? Colors.black
                  : Colors.white,
              size: 16,
            )
                : null,
          ),
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onTap;

  _ResetButton({
    required this.cardColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color backgroundColor = isDark
        ? colorScheme.error.withValues(
      alpha: 0.09,
    )
        : colorScheme.error.withValues(
      alpha: 0.05,
    );

    Color resetBorderColor = colorScheme.error.withValues(
      alpha: isDark ? 0.22 : 0.16,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          18,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 48,
          padding: EdgeInsets.symmetric(
            horizontal: 13,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              18,
            ),
            border: Border.all(
              color: resetBorderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.arrow_clockwise,
                color: colorScheme.error,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'reset_to_default'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}