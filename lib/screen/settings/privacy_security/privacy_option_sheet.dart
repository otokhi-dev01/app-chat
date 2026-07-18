import 'package:flutter/material.dart';

class PrivacyOptionsSheet extends StatelessWidget {
  final String title;
  final String selectedValue;
  final List<String> options;

  PrivacyOptionsSheet({
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
      useSafeArea: true,
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
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color sheetColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        20,
      ),
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
        border: Border(
          top: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetHandle(),
          SizedBox(height: 18),
          _SheetHeader(
            title: title,
          ),
          SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: options.map(
                      (String option) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 7,
                      ),
                      child: _PrivacyOptionTile(
                        title: option,
                        selected:
                        option == selectedValue,
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
    );
  }
}

class _SheetHandle extends StatelessWidget {
  _SheetHandle();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant
            .withValues(
          alpha: 0.28,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;

  _SheetHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

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
        Material(
          color: colorScheme.surfaceContainerHighest,
          shape: CircleBorder(),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            customBorder: CircleBorder(),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.close_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
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

  _PrivacyOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    Color backgroundColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.10,
    )
        : Colors.transparent;

    Color borderColor = selected
        ? colorScheme.primary.withValues(
      alpha: 0.18,
    )
        : Colors.transparent;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        overlayColor: WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return colorScheme.primary.withValues(
                alpha: 0.07,
              );
            }

            return Colors.transparent;
          },
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 52,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 10),
              AnimatedSwitcher(
                duration: Duration(
                  milliseconds: 180,
                ),
                child: selected
                    ? Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey<String>(
                    'selected_$title',
                  ),
                  color: colorScheme.primary,
                  size: 22,
                )
                    : SizedBox(
                  key: ValueKey<String>(
                    'unselected_$title',
                  ),
                  width: 22,
                  height: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}