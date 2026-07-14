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
    const List<Color> palette = [
      Color(0xFFE17076),
      Color(0xFFFAA774),
      Color(0xFFA695E7),
      Color(0xFF7BC862),
      Color(0xFF6EC9CB),
      Color(0xFF65AADD),
      Color(0xFFEE7AAE),
    ];

    final int index = name.codeUnitAt(0) % palette.length;
    return palette[index];
  }

  String get _initials {
    final List<String> parts = name.trim().split(' ');

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
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
                color: const Color(0xFF4CD964),
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}