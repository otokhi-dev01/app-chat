import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyOptionsSheet extends StatelessWidget {
  final String title;
  final String selectedValue;
  final List<String> options;

  const PrivacyOptionsSheet({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.options,
  });

  static Future<String?> open({
    required BuildContext context,
    required String title,
    required String selectedValue,
    required List<String> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      useSafeArea: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(
        alpha: 0.42,
      ),
      builder: (BuildContext context) {
        return PrivacyOptionsSheet(
          title: title,
          selectedValue: selectedValue,
          options: options,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme _ = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color sheetColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    Color actionBackground = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Color(0xFFF2F4F7);

    return Material(
      color: sheetColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            18,
            12,
            18,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHandle(),
              SizedBox(height: 18),
              _SheetHeader(
                title: title,
                actionBackground: actionBackground,
                borderColor: borderColor,
              ),
              SizedBox(height: 14),
              Flexible(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: options.map(
                          (String option) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: _PrivacyOptionTile(
                            title: option,
                            selected: option == selectedValue,
                            onTap: () {
                              Navigator.of(context).pop(
                                option,
                              );
                            },
                          ),
                        );
                      },
                    ).toList(),
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

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

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
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;
  final Color actionBackground;
  final Color borderColor;

  const _SheetHeader({
    required this.title,
    required this.actionBackground,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 10),
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
            onPressed: () {
              Navigator.of(context).pop();
            },
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

class _PrivacyOptionTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _PrivacyOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  String _translatedOption(String value) {
    switch (value.trim().toLowerCase()) {
      case 'everybody':
        return 'everybody'.tr;
      case 'my contacts':
        return 'my_contacts'.tr;
      case 'nobody':
        return 'nobody'.tr;
      case 'on':
        return 'on'.tr;
      case 'off':
        return 'off'.tr;
      case '1 month':
        return 'one_month'.tr;
      case '3 months':
        return 'three_months'.tr;
      case '6 months':
        return 'six_months'.tr;
      case '1 year':
        return 'one_year'.tr;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.11,
    )
        : Colors.transparent;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: colorScheme.primary.withValues(alpha: 0.12),
        highlightColor: colorScheme.primary.withValues(alpha: 0.06),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 52,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _translatedOption(title),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 10),
              if (selected)
                Icon(
                  CupertinoIcons.checkmark,
                  color: colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}