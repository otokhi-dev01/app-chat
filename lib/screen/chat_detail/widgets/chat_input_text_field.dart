import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// UPDATED: Unit UI chat input text field with multiline auto-expand, camera quick action button, and tap-outside unfocus
class ChatInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onCamera;
  final Color inputColor;
  final Color borderColor;

  const ChatInputTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCamera,
    required this.inputColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    // UPDATED: Retrieve theme and colorScheme for dynamic light/dark theme adaptation
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 44, maxHeight: 130),
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // UPDATED: Multiline auto-expanding TextField (1 to 5 lines)
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: colorScheme.primary,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              // UPDATED: Dismisses soft keyboard when tapping anywhere outside the text field
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(15, 11, 8, 11),
              ),
            ),
          ),

          // UPDATED: Camera quick action button with Cupertino camera icon and tactile press feedback
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 4),
            child: Tooltip(
              message: 'Camera',
              child: CupertinoButton(
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(36, 36),
                onPressed: onCamera,
                // UPDATED: Replaced Material camera icon with Cupertino camera icon
                child: Icon(
                  CupertinoIcons.camera,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}