import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ContactSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    Color fieldColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        14,
        12,
        14,
        10,
      ),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(22),
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
        child: Row(
          children: [
            SizedBox(width: 12),
            Icon(
              CupertinoIcons.search,
              size: 18,
              color: colorScheme.primary,
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                cursorColor: colorScheme.primary,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'search_contacts'.tr,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.4),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 11,
                  ),
                ),
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (
                  BuildContext context,
                  TextEditingValue value,
                  Widget? child,
                  ) {
                if (value.text.isEmpty) {
                  return SizedBox(width: 12);
                }

                return Padding(
                  padding: EdgeInsets.only(
                    right: 6,
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(32, 32),
                    onPressed: onClear,
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      size: 18,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.4),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}