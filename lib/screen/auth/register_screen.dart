import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widgets/app_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your name';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Enter your email';
    }

    if (!GetUtils.isEmail(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';

    if (password.isEmpty) {
      return 'Enter a password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _togglePassword() {
    HapticFeedback.selectionClick();

    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPassword() {
    HapticFeedback.selectionClick();

    setState(() {
      _obscureConfirmPassword =
      !_obscureConfirmPassword;
    });
  }

  Future<void> _register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isLoading) {
      return;
    }

    final bool isValid =
        _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your registration API.
      await Future<void>.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) {
        return;
      }

      TextInput.finishAutofillContext();

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(
              'Account created successfully!',
            ),
            backgroundColor:
            Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );

      await Future<void>.delayed(
        const Duration(milliseconds: 350),
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(
              'Registration failed. Please try again.',
            ),
            backgroundColor:
            Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
    }
  }

  void _backToLogin() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color fieldBackground = isDark
        ? const Color(0xFF1B1D22)
        : Colors.white;

    final Color fieldBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.10);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Create Account',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              24,
              20,
              24,
              30,
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: 1,
              ),
              duration: const Duration(
                milliseconds: 550,
              ),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      20 * (1 - value),
                    ),
                    child: child,
                  ),
                );
              },
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const AppLogo(
                        size: 120,
                        padding: 0,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: theme
                            .textTheme.headlineMedium
                            ?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Create your account',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 35),

                      _RegisterTextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        label: 'Full Name',
                        icon: Icons.person_outline_rounded,
                        fieldBackground: fieldBackground,
                        fieldBorderColor: fieldBorderColor,
                        keyboardType: TextInputType.name,
                        textInputAction:
                        TextInputAction.next,
                        autofillHints: const [
                          AutofillHints.name,
                        ],
                        validator: _validateName,
                        onFieldSubmitted: (_) {
                          _emailFocusNode.requestFocus();
                        },
                      ),

                      const SizedBox(height: 20),

                      _RegisterTextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        fieldBackground: fieldBackground,
                        fieldBorderColor: fieldBorderColor,
                        keyboardType:
                        TextInputType.emailAddress,
                        textInputAction:
                        TextInputAction.next,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                        validator: _validateEmail,
                        onFieldSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                      ),

                      const SizedBox(height: 20),

                      _RegisterTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        fieldBackground: fieldBackground,
                        fieldBorderColor: fieldBorderColor,
                        obscureText: _obscurePassword,
                        textInputAction:
                        TextInputAction.next,
                        autofillHints: const [
                          AutofillHints.newPassword,
                        ],
                        validator: _validatePassword,
                        onFieldSubmitted: (_) {
                          _confirmPasswordFocusNode
                              .requestFocus();
                        },
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: _togglePassword,
                          icon: AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 180,
                            ),
                            transitionBuilder:
                                (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons
                                  .visibility_off_outlined,
                              key: ValueKey<bool>(
                                _obscurePassword,
                              ),
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _RegisterTextField(
                        controller:
                        _confirmPasswordController,
                        focusNode:
                        _confirmPasswordFocusNode,
                        label: 'Confirm Password',
                        icon: Icons.lock_reset_rounded,
                        fieldBackground: fieldBackground,
                        fieldBorderColor: fieldBorderColor,
                        obscureText:
                        _obscureConfirmPassword,
                        textInputAction:
                        TextInputAction.done,
                        autofillHints: const [
                          AutofillHints.newPassword,
                        ],
                        validator:
                        _validateConfirmPassword,
                        onFieldSubmitted: (_) {
                          _register();
                        },
                        suffixIcon: IconButton(
                          tooltip: _obscureConfirmPassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed:
                          _toggleConfirmPassword,
                          icon: AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 180,
                            ),
                            transitionBuilder:
                                (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons
                                  .visibility_off_outlined,
                              key: ValueKey<bool>(
                                _obscureConfirmPassword,
                              ),
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: FilledButton(
                          onPressed:
                          _isLoading ? null : _register,
                          style: FilledButton.styleFrom(
                            backgroundColor:
                            colorScheme.primary,
                            foregroundColor:
                            colorScheme.onPrimary,
                            disabledBackgroundColor:
                            colorScheme.primary
                                .withValues(alpha: 0.48),
                            disabledForegroundColor:
                            colorScheme.onPrimary
                                .withValues(alpha: 0.75),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 220,
                            ),
                            switchInCurve:
                            Curves.easeOutCubic,
                            switchOutCurve:
                            Curves.easeInCubic,
                            child: _isLoading
                                ? Row(
                              key: const ValueKey(
                                'register-loading',
                              ),
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                SizedBox(
                                  width: 21,
                                  height: 21,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: colorScheme
                                        .onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Creating account...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                                : const Text(
                              'Create Account',
                              key: ValueKey(
                                'create-account',
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment:
                        WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : _backToLogin,
                            style: TextButton.styleFrom(
                              foregroundColor:
                              colorScheme.primary,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final IconData icon;
  final Color fieldBackground;
  final Color fieldBorderColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final bool obscureText;

  const _RegisterTextField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.icon,
    required this.fieldBackground,
    required this.fieldBorderColor,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    OutlineInputBorder inputBorder({
      required Color color,
      double width = 1,
    }) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      autocorrect: !obscureText,
      enableSuggestions: !obscureText,
      cursorColor: colorScheme.primary,
      style: TextStyle(
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: fieldBackground,
        prefixIcon: Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
        ),
        suffixIcon: suffixIcon,
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        border: inputBorder(
          color: fieldBorderColor,
        ),
        enabledBorder: inputBorder(
          color: fieldBorderColor,
        ),
        focusedBorder: inputBorder(
          color: colorScheme.primary,
          width: 2,
        ),
        errorBorder: inputBorder(
          color: colorScheme.error,
        ),
        focusedErrorBorder: inputBorder(
          color: colorScheme.error,
          width: 2,
        ),
      ),
    );
  }
}