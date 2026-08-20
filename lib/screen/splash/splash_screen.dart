import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../route/app_route.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _glowOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;
  late final Animation<double> _loaderOpacity;

  final Completer<void> _navigationCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Logo: scale up from 0.6 → 1.0 with a slight overshoot feel
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    // Glow pulses in after logo appears
    _glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeInOut),
      ),
    );

    // Text slides up from slightly below
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
      ),
    );

    // Loader fades in last
    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.72, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Navigate after delay
    WidgetsBinding.instance.addPostFrameCallback((_) => _startNavigation());
  }

  void _startNavigation() {
    if (_navigationCompleter.isCompleted) return;
    _navigationCompleter.complete();

    Future<void>.delayed(const Duration(seconds: 3), () {
      if (Get.currentRoute == AppRoutes.splash) {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = AppTheme.primaryColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primary,
              Color.lerp(primary, Colors.black, 0.45)!,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo ──────────────────────────────────────────
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _glowOpacity.value < 1.0
                              ? 1.0
                              : 1.0, // glow handled inside AppLogo
                          child: AppLogo(
                            width: 130,
                            showGlow: _glowOpacity.value > 0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 36),

                // ── App name ──────────────────────────────────────
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _textSlide,
                      child: Opacity(
                        opacity: _textOpacity.value,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'Pii Chat',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fast. Secure. Simple.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 70),

                // ── Loading indicator ─────────────────────────────
                AnimatedBuilder(
                  animation: _loaderOpacity,
                  builder: (context, child) => Opacity(
                    opacity: _loaderOpacity.value,
                    child: child,
                  ),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.85),
                      ),
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