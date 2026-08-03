import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final bool isOnline;
  final double size;

  const ContactAvatar({
    super.key,
    required this.name,
    this.isOnline = false,
    this.size = 48,
  });

  // Telegram-style deterministic color per contact based on name
  Color _colorForName(String name) {
    List<Color> palette = [
      Color(0xFFE17076),
      Color(0xFFFAA774),
      Color(0xFFA695E7),
      Color(0xFF7BC862),
      Color(0xFF6EC9CB),
      Color(0xFF65AADD),
      Color(0xFFEE7AAE),
    ];

    if (name.trim().isEmpty) {
      return palette[0];
    }

    int index = name.codeUnitAt(0) % palette.length;
    return palette[index];
  }

  String get _initials {
    List<String> parts = name.trim().split(' ');

    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;

    Color badgeBorderColor = isDark ? Color(0xFF1B1D22) : Colors.white;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _colorForName(name),
          ),
          child: Text(
            _initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.38,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF32C766),
                border: Border.all(
                  color: badgeBorderColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}