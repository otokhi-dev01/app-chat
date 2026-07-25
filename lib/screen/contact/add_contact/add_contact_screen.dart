import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'add_contact_app_bar.dart';
import 'add_contact_content.dart';

class AddContactScreen extends StatefulWidget {
  final String name;
  final String username;
  final String phoneNumber;
  final String imageUrl;

  AddContactScreen({
    super.key,
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.imageUrl,
  });

  @override
  State<AddContactScreen> createState() {
    return _AddContactScreenState();
  }
}

class _AddContactScreenState
    extends State<AddContactScreen> {
  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.name,
    );

    usernameController = TextEditingController(
      text: widget.username,
    );

    phoneController = TextEditingController(
      text: widget.phoneNumber,
    );

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        _hideBottomSystemBar();
      },
    );
  }

  Future<void> _hideBottomSystemBar() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: <SystemUiOverlay>[
        SystemUiOverlay.top,
      ],
    );
  }

  Future<void> _restoreSystemBars() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();

    _restoreSystemBars();

    super.dispose();
  }

  void _closeScreen() {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    Get.back();
  }

  Future<void> _saveContact() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    bool isValid =
        formKey.currentState?.validate() ??
            false;

    if (!isValid || isSaving) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await Future<void>.delayed(
        Duration(
          milliseconds: 700,
        ),
      );

      if (!mounted) {
        return;
      }

      Get.back(
        result: <String, dynamic>{
          'saved': true,
          'name':
          nameController.text.trim(),
          'username':
          usernameController.text.trim(),
          'phoneNumber':
          phoneController.text.trim(),
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
    Theme.of(context);

    bool isDark =
        theme.brightness ==
            Brightness.dark;

    Color pageColor =
        theme.scaffoldBackgroundColor;

    SystemUiOverlayStyle overlayStyle =
    isDark
        ? SystemUiOverlayStyle.light
        .copyWith(
      statusBarColor:
      Colors.transparent,
      statusBarIconBrightness:
      Brightness.light,
      statusBarBrightness:
      Brightness.dark,
    )
        : SystemUiOverlayStyle.dark
        .copyWith(
      statusBarColor:
      Colors.transparent,
      statusBarIconBrightness:
      Brightness.dark,
      statusBarBrightness:
      Brightness.light,
    );

    return AnnotatedRegion<
        SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBody: true,
        extendBodyBehindAppBar: false,
        backgroundColor: pageColor,
        appBar: AddContactAppBar(
          onBack: _closeScreen,
        ),
        body: ColoredBox(
          color: pageColor,
          child: AddContactContent(
            formKey: formKey,
            name: widget.name,
            username: widget.username,
            imageUrl: widget.imageUrl,
            nameController:
            nameController,
            usernameController:
            usernameController,
            phoneController:
            phoneController,
            isSaving: isSaving,
            onSave: _saveContact,
          ),
        ),
      ),
    );
  }
}