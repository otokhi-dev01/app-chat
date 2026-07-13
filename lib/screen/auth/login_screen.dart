import 'package:appchat/screen/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;

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
    if (value == null || value.isEmpty) {
      return 'Enter password';
    }

    return null;
  }

  void _togglePasswordVisibility() {
    HapticFeedback.selectionClick();

    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
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
      // Replace this delay with your login API.
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
            content: const Text('Login Successful'),
            backgroundColor:
            Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );

      // Unfocus before removing the login screen.
      FocusManager.instance.primaryFocus?.unfocus();

      await Future<void>.delayed(
        const Duration(milliseconds: 250),
      );

      if (!mounted) {
        return;
      }

      Get.offAllNamed(AppRoutes.home);
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
              'Login failed. Please try again.',
            ),
            backgroundColor:
            Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
    }
  }

  @override
  void dispose() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();

    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(24),
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
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const AppLogo(
                        size: 120,
                        padding: 0,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Welcome Back',
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
                        'Login to continue',
                        style:
                        theme.textTheme.bodyMedium?.copyWith(
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 40),

                      _LoginTextField(
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
                          AutofillHints.username,
                        ],
                        validator: _validateEmail,
                        onFieldSubmitted: (_) {
                          _passwordFocusNode.requestFocus();
                        },
                      ),

                      const SizedBox(height: 20),

                      _LoginTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        fieldBackground: fieldBackground,
                        fieldBorderColor: fieldBorderColor,
                        obscureText: _obscurePassword,
                        textInputAction:
                        TextInputAction.done,
                        autofillHints: const [
                          AutofillHints.password,
                        ],
                        validator: _validatePassword,
                        onFieldSubmitted: (_) {
                          _login();
                        },
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed:
                          _togglePasswordVisibility,
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

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: FilledButton(
                          onPressed:
                          _isLoading ? null : _login,
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
                            child: _isLoading
                                ? Row(
                              key: const ValueKey(
                                'loading',
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
                                  'Logging in...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                                : const Text(
                              'Login',
                              key: ValueKey('login'),
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
                            "Don't have an account?",
                            style: TextStyle(
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                              FocusManager
                                  .instance.primaryFocus
                                  ?.unfocus();

                              Get.to(
                                    () => const RegisterScreen(),
                                transition:
                                Transition.rightToLeft,
                                duration: const Duration(
                                  milliseconds: 280,
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor:
                              colorScheme.primary,
                            ),
                            child: const Text(
                              'Create Account',
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

class _LoginTextField extends StatelessWidget {
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

  const _LoginTextField({
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