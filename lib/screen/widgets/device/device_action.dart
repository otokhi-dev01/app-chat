import 'package:flutter/material.dart';

class TerminateAllSessionsButton
    extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  TerminateAllSessionsButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.error.withValues(
        alpha: 0.08,
      ),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: isLoading
            ? null
            : onPressed,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          height: 52,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: colorScheme.error.withValues(
                alpha: 0.25,
              ),
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
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.error,
                  ),
                )
              else
                Icon(
                  Icons.logout_rounded,
                  color: colorScheme.error,
                  size: 20,
                ),
              SizedBox(width: 9),
              Text(
                isLoading
                    ? 'Terminating...'
                    : 'Terminate all other sessions',
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DevicesSecurityNote
    extends StatelessWidget {
  DevicesSecurityNote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: 0.07,
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Terminate any session you do not recognize and change your password.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
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