import 'package:flutter/material.dart';

class ContactSearchField
    extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  ContactSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color fieldColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Color(0xFFE7E9ED);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        14,
        12,
        14,
        10,
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.08 : 0.035,
              ),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 14),
            Icon(
              Icons.search_rounded,
              size: 21,
              color: colorScheme.primary,
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction:
                TextInputAction.search,
                keyboardType:
                TextInputType.text,
                cursorColor:
                colorScheme.primary,
                style: theme
                    .textTheme.bodyLarge
                    ?.copyWith(
                  color:
                  colorScheme.onSurface,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Search contacts',
                  hintStyle: theme
                      .textTheme.bodyLarge
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  enabledBorder:
                  InputBorder.none,
                  focusedBorder:
                  InputBorder.none,
                  isDense: true,
                  contentPadding:
                  EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
                onTapOutside: (
                    PointerDownEvent event,
                    ) {
                  FocusManager
                      .instance.primaryFocus
                      ?.unfocus();
                },
              ),
            ),
            ValueListenableBuilder<
                TextEditingValue>(
              valueListenable: controller,
              builder: (
                  BuildContext context,
                  TextEditingValue value,
                  Widget? child,
                  ) {
                if (value.text.isEmpty) {
                  return SizedBox(width: 10);
                }

                return Padding(
                  padding: EdgeInsets.only(
                    right: 6,
                  ),
                  child: Material(
                    color: colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.10),
                    shape: CircleBorder(),
                    child: Tooltip(
                      message: 'Clear search',
                      child: InkWell(
                        onTap: onClear,
                        customBorder:
                        CircleBorder(),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ),
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