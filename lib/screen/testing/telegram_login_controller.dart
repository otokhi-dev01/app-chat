import 'dart:async';
import 'package:appchat/screen/testing/profile_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'otp_verfication_screen.dart';

class TelegramLoginController extends GetxController {
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController countrySearchController = TextEditingController();

  // GetX built-in HTTP client
  final GetConnect _connect = GetConnect();

  // Reactive lists populated dynamically
  final RxList<Map<String, String>> allCountries = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> filteredCountries = <Map<String, String>>[].obs;

  final RxString selectedCountryCode = '+1'.obs;
  final RxString selectedCountryName = 'United States'.obs;
  final RxBool isLoading = false.obs;

  // Loading state for fetching the country database
  final RxBool isFetchingCountries = false.obs;

  // OTP Verification states
  final List<TextEditingController> otpControllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(5, (_) => FocusNode());
  final RxInt countdown = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Automatically trigger the API fetch on initialization
    fetchCountriesFromApi();
  }

  Future<void> fetchCountriesFromApi() async {
    isFetchingCountries.value = true;
    try {
      // Querying only necessary fields (name & international dial codes) to save bandwidth
      final response = await _connect.get(
        'https://restcountries.com/v3.1/all?fields=name,idd',
      );

      if (response.status.isOk && response.body != null) {
        final List<dynamic> data = response.body;
        final List<Map<String, String>> parsedList = [];

        for (var item in data) {
          try {
            final name = item['name']?['common']?.toString() ?? '';
            final Map<dynamic, dynamic>? idd = item['idd'];

            if (name.isNotEmpty && idd != null) {
              final root = idd['root']?.toString() ?? '';
              final suffixes = idd['suffixes'] as List<dynamic>?;

              if (root.isNotEmpty) {
                // Combine the root and first suffix (e.g. root +7, suffix 7 -> +77)
                final suffix = (suffixes != null && suffixes.isNotEmpty)
                    ? suffixes.first.toString()
                    : '';
                final fullDialCode = '$root$suffix';

                parsedList.add({
                  'name': name,
                  'code': fullDialCode,
                });
              }
            }
          } catch (_) {
            // Ignore single malformed parsing items and continue
          }
        }

        // Sort parsed countries alphabetically
        parsedList.sort((a, b) => a['name']!.compareTo(b['name']!));

        allCountries.assignAll(parsedList);
        filteredCountries.assignAll(parsedList);
      } else {
        _useFallbackCountries();
      }
    } catch (_) {
      _useFallbackCountries();
    } finally {
      isFetchingCountries.value = false;
    }
  }

  // Fallback data if the dynamic request fails or user is offline
  void _useFallbackCountries() {
    final fallback = const [
      {'name': 'United States', 'code': '+1'},
      {'name': 'United Kingdom', 'code': '+44'},
      {'name': 'Germany', 'code': '+49'},
      {'name': 'India', 'code': '+91'},
      {'name': 'Cambodia', 'code': '+855'},
      {'name': 'Canada', 'code': '+1'},
      {'name': 'Australia', 'code': '+61'},
      {'name': 'France', 'code': '+33'},
      {'name': 'Singapore', 'code': '+65'},
      {'name': 'Japan', 'code': '+81'},
    ];
    allCountries.assignAll(fallback);
    filteredCountries.assignAll(fallback);
  }

  void selectCountry(String code, String name) {
    selectedCountryCode.value = code;
    selectedCountryName.value = name;
  }

  void filterCountries(String query) {
    if (query.isEmpty) {
      filteredCountries.assignAll(allCountries);
    } else {
      filteredCountries.assignAll(
        allCountries.where((country) {
          final name = country['name']!.toLowerCase();
          final code = country['code']!.toLowerCase();
          return name.contains(query.toLowerCase()) || code.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  Future<void> sendCode() async {
    if (!phoneFormKey.currentState!.validate()) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.to(() => const OtpVerificationScreen());
    startCountdown();
  }

  void startCountdown() {
    countdown.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> resendCode() async {
    if (countdown.value > 0) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    startCountdown();
  }

  Future<void> verifyOtp(String code) async {
    isLoading.value = true;

    // Simulate API Verification call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Mocking backend response. Replace with your actual database/API check.
    final bool isNewUser = true;

    if (isNewUser) {
      // Navigate to Profile Setup. "Get.off" replaces the OTP screen
      // in the stack so the user cannot go back to it.
      Get.off(() => const ProfileSetupScreen());
    } else {
      // Navigate to Home. "Get.offAll" clears the entire route history
      // preventing the user from navigating back to the login flow.
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}