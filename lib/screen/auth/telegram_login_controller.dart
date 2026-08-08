import 'dart:async';

import 'package:appchat/screen/auth/verify_otp/verity_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TelegramLoginController extends GetxController {
  static const int otpLength = 6;

  // Form
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController phoneTextController =
  TextEditingController();

  final TextEditingController countrySearchController =
  TextEditingController();

  // HTTP client
  final GetConnect _connect = GetConnect(
    timeout: const Duration(seconds: 15),
  );

  // Country states
  final RxList<Map<String, String>> allCountries =
      <Map<String, String>>[].obs;

  final RxList<Map<String, String>> filteredCountries =
      <Map<String, String>>[].obs;

  final RxString selectedCountryCode = '+1'.obs;
  final RxString selectedCountryName = 'United States'.obs;

  final RxBool isFetchingCountries = false.obs;

  // Request states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Phone used on OTP screen
  final RxString verificationPhoneNumber = ''.obs;

  // OTP controllers
  final List<TextEditingController> otpControllers =
  List.generate(
    otpLength,
        (_) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes = List.generate(
    otpLength,
        (_) => FocusNode(),
  );

  final RxInt countdown = 60.obs;
  final RxString otpError = ''.obs;

  Timer? _timer;

  String get internationalPhoneNumber {
    final String countryCode = selectedCountryCode.value.trim();

    String localPhone = phoneTextController.text.replaceAll(
      RegExp(r'\D'),
      '',
    );

    // Remove local leading zero when creating international number.
    // Example: 012345678 -> +85512345678
    localPhone = localPhone.replaceFirst(
      RegExp(r'^0+'),
      '',
    );

    return '$countryCode$localPhone';
  }

  String get enteredOtp {
    return otpControllers
        .map((controller) => controller.text.trim())
        .join();
  }

  bool get canResendCode => countdown.value == 0;

  @override
  void onInit() {
    super.onInit();
    fetchCountriesFromApi();
  }

  Future<void> fetchCountriesFromApi() async {
    if (isFetchingCountries.value) return;

    isFetchingCountries.value = true;
    errorMessage.value = '';

    try {
      final Response<dynamic> response = await _connect.get(
        'https://restcountries.com/v3.1/all?fields=name,idd',
      );

      final dynamic body = response.body;

      if (!response.status.isOk || body is! List) {
        _useFallbackCountries();
        return;
      }

      final List<Map<String, String>> countries = [];
      final Set<String> existingCountries = {};

      for (final dynamic item in body) {
        if (item is! Map) continue;

        final dynamic nameData = item['name'];
        final dynamic iddData = item['idd'];

        if (nameData is! Map || iddData is! Map) {
          continue;
        }

        final String name =
            nameData['common']?.toString().trim() ?? '';

        final String dialCode = _extractDialCode(
          iddData,
        );

        if (name.isEmpty || dialCode.isEmpty) {
          continue;
        }

        final String uniqueKey =
            '${name.toLowerCase()}|$dialCode';

        if (!existingCountries.add(uniqueKey)) {
          continue;
        }

        countries.add({
          'name': name,
          'code': dialCode,
        });
      }

      countries.sort(
            (a, b) => (a['name'] ?? '').toLowerCase().compareTo(
          (b['name'] ?? '').toLowerCase(),
        ),
      );

      if (countries.isEmpty) {
        _useFallbackCountries();
        return;
      }

      allCountries.assignAll(countries);
      filteredCountries.assignAll(countries);
    } catch (_) {
      _useFallbackCountries();
    } finally {
      isFetchingCountries.value = false;
    }
  }

  String _extractDialCode(Map<dynamic, dynamic> idd) {
    final String root =
        idd['root']?.toString().trim() ?? '';

    if (root.isEmpty) {
      return '';
    }

    final dynamic suffixData = idd['suffixes'];

    if (suffixData is! List || suffixData.isEmpty) {
      return root;
    }

    /*
     Some countries, such as the United States and Canada, contain
     many area-code suffixes. In that case, use the country root +1
     instead of incorrectly selecting only the first area code.
    */
    if (suffixData.length > 1) {
      return root;
    }

    final String suffix =
        suffixData.first?.toString().trim() ?? '';

    if (suffix.isEmpty) {
      return root;
    }

    return '$root$suffix';
  }

  void _useFallbackCountries() {
    const List<Map<String, String>> fallbackCountries = [
      {
        'name': 'Australia',
        'code': '+61',
      },
      {
        'name': 'Cambodia',
        'code': '+855',
      },
      {
        'name': 'Canada',
        'code': '+1',
      },
      {
        'name': 'France',
        'code': '+33',
      },
      {
        'name': 'Germany',
        'code': '+49',
      },
      {
        'name': 'India',
        'code': '+91',
      },
      {
        'name': 'Japan',
        'code': '+81',
      },
      {
        'name': 'Singapore',
        'code': '+65',
      },
      {
        'name': 'United Kingdom',
        'code': '+44',
      },
      {
        'name': 'United States',
        'code': '+1',
      },
    ];

    allCountries.assignAll(fallbackCountries);
    filteredCountries.assignAll(fallbackCountries);
  }

  void selectCountry(
      String code,
      String name,
      ) {
    selectedCountryCode.value = code.trim();
    selectedCountryName.value = name.trim();

    countrySearchController.clear();
    filterCountries('');
  }

  void filterCountries(String query) {
    final String searchValue = query.trim().toLowerCase();

    if (searchValue.isEmpty) {
      filteredCountries.assignAll(allCountries);
      return;
    }

    final List<Map<String, String>> results =
    allCountries.where((country) {
      final String name =
      (country['name'] ?? '').toLowerCase();

      final String code =
      (country['code'] ?? '').toLowerCase();

      return name.contains(searchValue) ||
          code.contains(searchValue);
    }).toList();

    filteredCountries.assignAll(results);
  }

  Future<void> sendCode() async {
    if (isLoading.value) return;

    final bool isValid =
        phoneFormKey.currentState?.validate() ?? false;

    if (!isValid) return;

    isLoading.value = true;
    errorMessage.value = '';

    bool codeSent = false;

    try {
      final String phoneNumber =
          internationalPhoneNumber;

      /*
       Replace this delay with your real send-OTP API:

       final response = await _connect.post(
         'YOUR_API_URL/send-otp',
         {
           'phone': phoneNumber,
         },
       );

       codeSent = response.status.isOk;
      */

      await Future<void>.delayed(
        const Duration(seconds: 2),
      );

      verificationPhoneNumber.value = phoneNumber;
      codeSent = true;
    } catch (_) {
      errorMessage.value =
      'Unable to send the verification code. Please try again.';
    } finally {
      isLoading.value = false;
    }

    if (!codeSent) return;

    clearOtp();
    startCountdown();

    Get.to(
          () => VerifyOtpScreen(
        destination: verificationPhoneNumber.value,
      ),
    );
  }

  void startCountdown() {
    _timer?.cancel();

    countdown.value = 60;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
        if (countdown.value <= 1) {
          countdown.value = 0;
          timer.cancel();
          return;
        }

        countdown.value--;
      },
    );
  }

  Future<void> resendCode() async {
    if (!canResendCode || isLoading.value) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    otpError.value = '';

    bool codeSent = false;

    try {
      /*
       Replace this delay with your real resend-OTP API:

       final response = await _connect.post(
         'YOUR_API_URL/resend-otp',
         {
           'phone': verificationPhoneNumber.value,
         },
       );

       codeSent = response.status.isOk;
      */

      await Future<void>.delayed(
        const Duration(seconds: 1),
      );

      codeSent = true;
    } catch (_) {
      errorMessage.value =
      'Unable to resend the code. Please try again.';
    } finally {
      isLoading.value = false;
    }

    if (!codeSent) return;

    clearOtp();
    startCountdown();
  }

  void onOtpChanged(
      int index,
      String value,
      ) {
    otpError.value = '';

    if (value.isNotEmpty &&
        index < otpFocusNodes.length - 1) {
      otpFocusNodes[index + 1].requestFocus();
      return;
    }

    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp(String code) async {
    if (isLoading.value) return;

    final String normalizedCode = code.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(normalizedCode)) {
      otpError.value =
      'Please enter the complete 6-digit code';
      return;
    }

    isLoading.value = true;
    otpError.value = '';
    errorMessage.value = '';

    try {
      /*
       Replace this delay with your real verification API:

       final response = await _connect.post(
         'YOUR_API_URL/verify-otp',
         {
           'phone': verificationPhoneNumber.value,
           'otp': normalizedCode,
         },
       );
      */

      await Future<void>.delayed(
        const Duration(seconds: 2),
      );

      // Replace this mock value with your backend response.
      const bool isNewUser = true;

      if (isNewUser) {
        // Example:
        // Get.offNamed(AppRoutes.profileSetup);
      } else {
        // Example:
        // Get.offAllNamed(AppRoutes.home);
      }
    } catch (_) {
      otpError.value =
      'The verification failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyEnteredOtp() {
    return verifyOtp(enteredOtp);
  }

  void clearOtp() {
    otpError.value = '';

    for (final TextEditingController controller
    in otpControllers) {
      controller.clear();
    }

    if (otpFocusNodes.isNotEmpty) {
      otpFocusNodes.first.requestFocus();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();

    phoneTextController.dispose();
    countrySearchController.dispose();

    for (final TextEditingController controller
    in otpControllers) {
      controller.dispose();
    }

    for (final FocusNode focusNode in otpFocusNodes) {
      focusNode.dispose();
    }

    super.onClose();
  }
}