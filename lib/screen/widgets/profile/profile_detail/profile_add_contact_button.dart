import 'package:flutter/material.dart';

class ProfileAddContactButton
    extends StatelessWidget {
  final VoidCallback onTap;

  ProfileAddContactButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(
          Icons.person_add_alt_1_rounded,
          size: 19,
        ),
        label: Text(
          'Add to contacts',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor:
          colorScheme.primary,
          foregroundColor:
          colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}