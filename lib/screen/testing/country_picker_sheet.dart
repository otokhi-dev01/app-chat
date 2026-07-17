import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'telegram_login_controller.dart';

class CountryPickerSheet extends StatelessWidget {
  final TelegramLoginController controller;

  const CountryPickerSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    // Dynamic max-height constraint to keep the sheet compact when closed
    // while giving it breathing room when the keyboard opens.
    final double maxSheetHeight = isKeyboardOpen
        ? MediaQuery.of(context).size.height * 0.85
        : MediaQuery.of(context).size.height * 0.55;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxSheetHeight,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
          // Shifts content up dynamically when the keyboard is open
          bottom: keyboardHeight + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Country',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Static Search Box (Remains pinned at the top)
            TextField(
              controller: controller.countrySearchController,
              onChanged: controller.filterCountries,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              cursorColor: colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Search country or code...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Flexible allows the list to dynamically expand and scroll safely
            Flexible(
              child: Obx(() {
                if (controller.isFetchingCountries.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    ),
                  );
                }

                final countries = controller.filteredCountries;

                if (countries.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text(
                        'No countries found',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(), // Enabled native scroll
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        country['name']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        country['code']!,
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        controller.selectCountry(
                          country['code']!,
                          country['name']!,
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}