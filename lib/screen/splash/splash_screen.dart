import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../route/app_route.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({
    super.key,
  });

  final Completer<void> _navigationCompleter =
  Completer<void>();

  void _startNavigation() {
    if (_navigationCompleter.isCompleted) {
      return;
    }

    _navigationCompleter.complete();

    Future<void>.delayed(
      Duration(seconds: 3),
          () {
        if (Get.currentRoute == AppRoutes.splash) {
          Get.offAllNamed(
            AppRoutes.login,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        _startNavigation();
      },
    );

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              AppLogo(
                width: 170,
                borderRadius: 90,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'OTOKHI Chat',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Fast. Secure. Simple.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}