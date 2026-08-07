import 'package:flutter/material.dart';

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
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(15, 12, 8, 12),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Camera',
            onPressed: onCamera,
            icon: Icon(
              Icons.camera_alt_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}