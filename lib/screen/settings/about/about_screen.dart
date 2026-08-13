import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'about_content.dart';
import 'about_app_bar.dart';

class AboutScreen extends StatelessWidget {
  final String? appVersion;
  final String? buildNumber;

  const AboutScreen({
    super.key,
    this.appVersion,
    this.buildNumber,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    String? v = appVersion;
    String? b = buildNumber;

    if (v == null && Get.arguments is Map) {
      v = Get.arguments['appVersion'] as String?;
      b = Get.arguments['buildNumber'] as String?;
    }

    if (v != null && b != null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const AboutAppBar(),
        body: AboutContent(
          appVersion: v,
          buildNumber: b,
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AboutAppBar(),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
          String resolvedVersion = v ?? snapshot.data?.version ?? '';
          String resolvedBuild = b ?? snapshot.data?.buildNumber ?? '';

          return AboutContent(
            appVersion: resolvedVersion,
            buildNumber: resolvedBuild,
          );
        },
      ),
    );
  }
}