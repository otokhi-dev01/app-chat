import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TerminateAllSessionsButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const TerminateAllSessionsButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color redColor = isDark ? Color(0xFFFF453A) : Color(0xFFFF3B30);

    Color backgroundColor = redColor.withValues(
      alpha: isDark ? 0.12 : 0.08,
    );

    Color borderColor = redColor.withValues(
      alpha: isDark ? 0.25 : 0.20,
    );

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(22),
          highlightColor: redColor.withValues(alpha: 0.06),
          splashColor: redColor.withValues(alpha: 0.12),
          child: Container(
            height: 52,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.15 : 0.03,
                  ),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: redColor,
                    ),
                  )
                else
                  Icon(
                    CupertinoIcons.square_arrow_right,
                    color: redColor,
                    size: 20,
                  ),
                SizedBox(width: 9),
                Flexible(
                  child: Text(
                    isLoading
                        ? 'terminating_sessions'.tr
                        : 'terminate_all_other_sessions'.tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: redColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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

class DevicesSecurityNote extends StatelessWidget {
  const DevicesSecurityNote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    bool isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: isDark ? 0.12 : 0.08,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: isDark ? 0.22 : 0.15,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              CupertinoIcons.info_circle,
              color: colorScheme.primary,
              size: 18,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'unrecognized_session_security_note'.tr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}