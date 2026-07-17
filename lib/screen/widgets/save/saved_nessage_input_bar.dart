import 'package:flutter/material.dart';

class MessageInputBar extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final String hintText;

  MessageInputBar({
    super.key,
    required this.textController,
    required this.onSend,
    this.hintText = 'Message',
  });

  void _sendMessage() {
    String message = textController.text.trim();

    if (message.isEmpty) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    onSend();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color surfaceColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color fieldColor = isDark
        ? Colors.white.withValues(
      alpha: 0.07,
    )
        : Color(0xFFF2F4F7);

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return Material(
      color: surfaceColor,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(
            top: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              10,
              8,
              10,
              8,
            ),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 46,
                    ),
                    decoration: BoxDecoration(
                      color: fieldColor,
                      borderRadius:
                      BorderRadius.circular(23),
                      border: Border.all(
                        color: borderColor,
                      ),
                    ),
                    child: TextField(
                      controller: textController,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType:
                      TextInputType.multiline,
                      textInputAction:
                      TextInputAction.newline,
                      textCapitalization:
                      TextCapitalization.sentences,
                      cursorColor:
                      colorScheme.primary,
                      style: theme
                          .textTheme.bodyLarge
                          ?.copyWith(
                        color:
                        colorScheme.onSurface,
                        fontSize: 14.5,
                        height: 1.35,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: theme
                            .textTheme.bodyLarge
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                          fontSize: 14.5,
                        ),
                        border: InputBorder.none,
                        enabledBorder:
                        InputBorder.none,
                        focusedBorder:
                        InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onTapOutside: (
                          PointerDownEvent event,
                          ) {
                        FocusManager.instance
                            .primaryFocus
                            ?.unfocus();
                      },
                    ),
                  ),
                ),

                SizedBox(width: 8),

                Material(
                  color: colorScheme.primary,
                  shape: CircleBorder(),
                  child: Tooltip(
                    message: 'Send',
                    child: InkWell(
                      onTap: _sendMessage,
                      customBorder: CircleBorder(),
                      child: SizedBox(
                        width: 46,
                        height: 46,
                        child: Icon(
                          Icons.send_rounded,
                          color:
                          colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}