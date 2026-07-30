import 'package:flutter/material.dart';

class SettingsDivider extends StatelessWidget {
  final Color color;

  const SettingsDivider({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 69),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
      ),
    );
  }
}