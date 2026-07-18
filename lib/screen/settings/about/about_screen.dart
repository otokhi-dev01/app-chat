import 'package:flutter/material.dart';

import '../../widgets/about/about_content.dart';
import 'about_app_bar.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AboutAppBar(),
      body: AboutContent(),
    );
  }
}