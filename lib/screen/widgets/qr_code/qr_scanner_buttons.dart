import 'package:flutter/material.dart';

class QrScannerActionButton
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isLoading;
  final VoidCallback onTap;

  QrScannerActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    Color backgroundColor = isActive
        ? colorScheme.primary
        : Colors.white.withValues(
      alpha: 0.08,
    );

    Color foregroundColor = isActive
        ? colorScheme.onPrimary
        : Colors.white;

    Color borderColor = isActive
        ? colorScheme.primary
        : Colors.white.withValues(
      alpha: 0.08,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading
            ? null
            : onTap,
        borderRadius:
        BorderRadius.circular(16),
        splashColor:
        Colors.transparent,
        highlightColor:
        Colors.transparent,
        hoverColor:
        Colors.transparent,
        focusColor:
        Colors.transparent,
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
            BorderRadius.circular(
              16,
            ),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 19,
                  height: 19,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foregroundColor,
                  ),
                )
              else
                Icon(
                  icon,
                  color: foregroundColor,
                  size: 20,
                ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
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

class QrScannerCircleButton
    extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  QrScannerCircleButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.black.withValues(
          alpha: 0.34,
        ),
        shape: CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: CircleBorder(),
          splashColor:
          Colors.transparent,
          highlightColor:
          Colors.transparent,
          hoverColor:
          Colors.transparent,
          focusColor:
          Colors.transparent,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}