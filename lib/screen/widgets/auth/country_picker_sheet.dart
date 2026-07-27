import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/telegram_login_controller.dart';

class CountryPickerSheet extends StatelessWidget {
  final TelegramLoginController controller;

  const CountryPickerSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    MediaQueryData mediaQuery =
    MediaQuery.of(context);

    bool isKeyboardOpen =
        mediaQuery.viewInsets.bottom > 0;

    Color sheetColor =
        colorScheme.surface;

    Color searchColor =
        theme.inputDecorationTheme.fillColor ??
            colorScheme.surfaceContainerHighest;

    Color borderColor =
        colorScheme.outlineVariant;

    double availableHeight =
        mediaQuery.size.height -
            mediaQuery.viewInsets.bottom;

    double sheetHeight = availableHeight *
        (isKeyboardOpen ? 0.82 : 0.60);

    return AnimatedPadding(
      duration: const Duration(
        milliseconds: 220,
      ),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom,
      ),
      child: SizedBox(
        height: sheetHeight,
        child: Material(
          color: sheetColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              16,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(
                        alpha: 0.35,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        99,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select Country',
                        style: theme
                            .textTheme.titleLarge
                            ?.copyWith(
                          color:
                          colorScheme.onSurface,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      tooltip: 'Close',
                      onPressed: () {
                        FocusManager
                            .instance.primaryFocus
                            ?.unfocus();

                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                TextField(
                  controller: controller
                      .countrySearchController,
                  textInputAction:
                  TextInputAction.search,
                  onChanged:
                  controller.filterCountries,
                  cursorColor:
                  colorScheme.primary,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText:
                    'Search country or code...',
                    filled: true,
                    fillColor: searchColor,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colorScheme
                          .onSurfaceVariant,
                      size: 21,
                    ),
                    hintStyle: theme
                        .textTheme.bodyLarge
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(
                        alpha: 0.72,
                      ),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),
                      borderSide: BorderSide(
                        color: borderColor,
                      ),
                    ),
                    focusedBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),
                      borderSide: BorderSide(
                        color:
                        colorScheme.primary,
                        width: 1.6,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Expanded(
                  child: Obx(
                        () {
                      if (controller
                          .isFetchingCountries
                          .value) {
                        return Center(
                          child:
                          CircularProgressIndicator(
                            color:
                            colorScheme.primary,
                            strokeWidth: 2.5,
                          ),
                        );
                      }

                      List<Map<String, String>>
                      countries =
                          controller
                              .filteredCountries;

                      if (countries.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              Icon(
                                Icons
                                    .search_off_rounded,
                                color: colorScheme
                                    .onSurfaceVariant,
                                size: 34,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'No countries found',
                                style: theme
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .onDrag,
                        physics:
                        const BouncingScrollPhysics(),
                        itemCount:
                        countries.length,
                        separatorBuilder:
                            (_, __) {
                          return Divider(
                            height: 1,
                            indent: 12,
                            endIndent: 12,
                            color: borderColor,
                          );
                        },
                        itemBuilder: (
                            BuildContext context,
                            int index,
                            ) {
                          Map<String, String>
                          country =
                          countries[index];

                          String name =
                              country['name'] ?? '';

                          String code =
                              country['code'] ?? '';

                          bool isSelected =
                              controller
                                  .selectedCountryCode
                                  .value ==
                                  code;

                          return ListTile(
                            contentPadding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                            ),
                            selected: isSelected,
                            selectedTileColor:
                            colorScheme.primary
                                .withValues(
                              alpha: 0.12,
                            ),
                            title: Text(
                              name,
                              style: theme
                                  .textTheme.bodyLarge
                                  ?.copyWith(
                                color: isSelected
                                    ? colorScheme
                                    .primary
                                    : colorScheme
                                    .onSurface,
                                fontWeight:
                                isSelected
                                    ? FontWeight
                                    .w700
                                    : FontWeight
                                    .w500,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Text(
                                  code,
                                  style: theme
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: isSelected
                                        ? colorScheme
                                        .primary
                                        : colorScheme
                                        .onSurfaceVariant,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                ),

                                if (isSelected) ...[
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons
                                        .check_circle_rounded,
                                    color: colorScheme
                                        .primary,
                                    size: 19,
                                  ),
                                ],
                              ],
                            ),
                            onTap: () {
                              controller
                                  .selectCountry(
                                code,
                                name,
                              );

                              FocusManager.instance
                                  .primaryFocus
                                  ?.unfocus();

                              Navigator.of(context)
                                  .pop();
                            },
                          );
                        },
                      );
                    },
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