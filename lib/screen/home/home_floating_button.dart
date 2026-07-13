import 'package:flutter/material.dart';

class HomeFloatingButton extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onPressed;

  const HomeFloatingButton({
    super.key,
    required this.selectedIndex,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: selectedIndex == 0
          ? FloatingActionButton(
        key: const ValueKey<String>('chat-fab'),
        backgroundColor: const Color(0xFF229ED9),
        elevation: 4,
        onPressed: onPressed,
        child: const Icon(
          Icons.edit_rounded,
          color: Colors.white,
        ),
      )
          : const SizedBox.shrink(
        key: ValueKey<String>('empty-fab'),
      ),
    );
  }
}