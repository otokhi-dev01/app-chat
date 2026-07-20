import 'package:flutter/material.dart';

class ChatAttachmentItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback? onTap;
  final double imageSize;
  final Color? imageColor;

  ChatAttachmentItem({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.imageSize = 34,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color itemBackground = isDark
        ? Colors.white.withValues(
      alpha: 0.07,
    )
        : Colors.black.withValues(
      alpha: 0.035,
    );

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.05,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          15,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: itemBackground,
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Image.asset(
                  imagePath,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                  filterQuality:
                  FilterQuality.high,
                  color: imageColor,
                  errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                      ) {
                    return Icon(
                      Icons
                          .image_not_supported_outlined,
                      color: colorScheme
                          .onSurfaceVariant,
                      size: 24,
                    );
                  },
                ),
              ),
              SizedBox(height: 6),
              SizedBox(
                width: 58,
                child: Text(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme.bodySmall
                      ?.copyWith(
                    color:
                    colorScheme.onSurface,
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w600,
                    height: 1.1,
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