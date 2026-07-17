import 'package:flutter/material.dart';

import '../../../models/save_message_model.dart';

class SavedMessageBubble
    extends StatelessWidget {
  final SavedMessageModel message;
  final VoidCallback onLongPress;

  SavedMessageBubble({
    super.key,
    required this.message,
    required this.onLongPress,
  });

  String _formatTime(
      DateTime dateTime,
      ) {
    int hour = dateTime.hour;

    String period =
    hour >= 12 ? 'PM' : 'AM';

    int formattedHour = hour % 12;

    if (formattedHour == 0) {
      formattedHour = 12;
    }

    String minute = dateTime.minute
        .toString()
        .padLeft(2, '0');

    return '$formattedHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    double maximumWidth =
        MediaQuery.sizeOf(context).width *
            0.78;

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: maximumWidth,
          ),
          margin: EdgeInsets.only(
            left: 52,
            top: 4,
            bottom: 4,
          ),
          padding: EdgeInsets.fromLTRB(
            13,
            9,
            10,
            7,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft:
              Radius.circular(18),
              bottomRight:
              Radius.circular(5),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary
                    .withValues(
                  alpha: 0.17,
                ),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment:
            WrapCrossAlignment.end,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                message.text,
                style: theme
                    .textTheme.bodyLarge
                    ?.copyWith(
                  color:
                  colorScheme.onPrimary,
                  fontSize: 14.5,
                  height: 1.35,
                  fontWeight:
                  FontWeight.w400,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  bottom: 1,
                ),
                child: Text(
                  _formatTime(
                    message.dateTime,
                  ),
                  style: theme
                      .textTheme.bodySmall
                      ?.copyWith(
                    color: colorScheme.onPrimary
                        .withValues(
                      alpha: 0.72,
                    ),
                    fontSize: 10.5,
                    height: 1,
                    fontWeight:
                    FontWeight.w500,
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