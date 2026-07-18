import 'package:flutter/material.dart';

class DeleteChatFolderSheet
    extends StatelessWidget {
  final String folderName;

  DeleteChatFolderSheet({
    super.key,
    required this.folderName,
  });

  static Future<bool?> open({
    required BuildContext context,
    required String folderName,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      backgroundColor:
      Colors.transparent,
      barrierColor:
      Colors.black.withValues(
        alpha: 0.42,
      ),
      builder: (
          BuildContext context,
          ) {
        return DeleteChatFolderSheet(
          folderName: folderName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color sheetColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18,
        10,
        18,
        22,
      ),
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme
                  .onSurfaceVariant
                  .withValues(
                alpha: 0.28,
              ),
              borderRadius:
              BorderRadius.circular(20),
            ),
          ),
          SizedBox(height: 22),
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.error
                  .withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: colorScheme.error,
              size: 30,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Delete Folder?',
            style: theme
                .textTheme.titleLarge
                ?.copyWith(
              color:
              colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Delete “$folderName”? Your chats will remain available in All Chats.',
            textAlign: TextAlign.center,
            style: theme
                .textTheme.bodyMedium
                ?.copyWith(
              color: colorScheme
                  .onSurfaceVariant,
              height: 1.45,
            ),
          ),
          SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false);
                  },
                  style:
                  OutlinedButton.styleFrom(
                    minimumSize: Size(
                      double.infinity,
                      50,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true);
                  },
                  style:
                  FilledButton.styleFrom(
                    minimumSize: Size(
                      double.infinity,
                      50,
                    ),
                    backgroundColor:
                    colorScheme.error,
                    foregroundColor:
                    colorScheme.onError,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                  child: Text(
                    'Delete',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}