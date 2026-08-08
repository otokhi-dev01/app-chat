import 'package:flutter/material.dart';

/// UPDATED: Unit UI entrance animation playing a 220ms fade + slide-up effect for newly arrived chat messages
class ChatMessageEntrance extends StatefulWidget {
  final Widget child;

  const ChatMessageEntrance({
    super.key,
    required this.child,
  });

  @override
  State<ChatMessageEntrance> createState() => _ChatMessageEntranceState();
}

class _ChatMessageEntranceState extends State<ChatMessageEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    // UPDATED: Initialize 220ms animation controller for fluid entrance transitions
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    // UPDATED: EaseOut fade curve for smooth opacity ramp-up
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // UPDATED: 12% vertical slide-up transition driven by easeOutCubic curve
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // ADDED: Triggers forward animation after initial frame render prevents layout jumps
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED: Composites FadeTransition and SlideTransition for unit UI message entrance
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}