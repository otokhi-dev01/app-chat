import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContactContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final String name;
  final String username;
  final String imageUrl;

  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController phoneController;

  final bool isSaving;
  final Future<void> Function() onSave;

  AddContactContent({
    super.key,
    required this.formKey,
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.nameController,
    required this.usernameController,
    required this.phoneController,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color pageColor =
        theme.scaffoldBackgroundColor;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return ColoredBox(
      color: pageColor,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: LayoutBuilder(
          builder: (
              BuildContext context,
              BoxConstraints constraints,
              ) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior
                  .onDrag,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth - 32,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ContactProfileHeader(
                        name: name,
                        username: username,
                        imageUrl: imageUrl,
                      ),

                      SizedBox(height: 18),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius:
                          BorderRadius.circular(
                            20,
                          ),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  alignment:
                                  Alignment.center,
                                  decoration:
                                  BoxDecoration(
                                    color: colorScheme
                                        .primary
                                        .withValues(
                                      alpha: 0.11,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      11,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons
                                        .contact_page_outlined,
                                    color: colorScheme
                                        .primary,
                                    size: 19,
                                  ),
                                ),

                                SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    'contact_information'
                                        .tr,
                                    style: theme
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                      color: colorScheme
                                          .onSurface,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),

                            _ContactTextField(
                              controller:
                              nameController,
                              label:
                              'contact_name'.tr,
                              hintText:
                              'enter_contact_name'
                                  .tr,
                              icon: Icons
                                  .person_outline_rounded,
                              textInputAction:
                              TextInputAction.next,
                              validator: (
                                  String? value,
                                  ) {
                                if (value == null ||
                                    value
                                        .trim()
                                        .isEmpty) {
                                  return 'contact_name_required'
                                      .tr;
                                }

                                return null;
                              },
                            ),

                            SizedBox(height: 12),

                            _ContactTextField(
                              controller:
                              usernameController,
                              label: 'username'.tr,
                              hintText:
                              'username'.tr,
                              icon: Icons
                                  .alternate_email_rounded,
                              textInputAction:
                              TextInputAction.next,
                            ),

                            SizedBox(height: 12),

                            _ContactTextField(
                              controller:
                              phoneController,
                              label:
                              'phone_number'.tr,
                              hintText:
                              'enter_phone_number'
                                  .tr,
                              icon: Icons
                                  .phone_outlined,
                              keyboardType:
                              TextInputType.phone,
                              textInputAction:
                              TextInputAction.done,
                              onSubmitted: (
                                  String value,
                                  ) {
                                onSave();
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: isSaving
                              ? null
                              : onSave,
                          style:
                          FilledButton.styleFrom(
                            backgroundColor:
                            colorScheme.primary,
                            foregroundColor:
                            colorScheme.onPrimary,
                            disabledBackgroundColor:
                            colorScheme.primary
                                .withValues(
                              alpha: 0.55,
                            ),
                            disabledForegroundColor:
                            colorScheme.onPrimary
                                .withValues(
                              alpha: 0.75,
                            ),
                            elevation: 0,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                16,
                              ),
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: Duration(
                              milliseconds: 180,
                            ),
                            child: isSaving
                                ? SizedBox(
                              key:
                              ValueKey<String>(
                                'saving-contact',
                              ),
                              width: 20,
                              height: 20,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme
                                    .onPrimary,
                              ),
                            )
                                : Row(
                              key:
                              ValueKey<String>(
                                'add-contact',
                              ),
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Icon(
                                  Icons
                                      .person_add_alt_1_rounded,
                                  size: 19,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'add_to_contacts'
                                      .tr,
                                  style:
                                  TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ContactProfileHeader
    extends StatelessWidget {
  final String name;
  final String username;
  final String imageUrl;

  _ContactProfileHeader({
    required this.name,
    required this.username,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color cardColor = isDark
        ? Color(0xFF1B1D22)
        : Colors.white;

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    String cleanName = name.trim();

    String firstLetter = cleanName.isNotEmpty
        ? cleanName[0].toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withValues(
                alpha: isDark ? 0.18 : 0.10,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary
                    .withValues(
                  alpha: 0.16,
                ),
              ),
            ),
            child: imageUrl.trim().isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                  ) {
                return _AvatarLetter(
                  letter: firstLetter,
                );
              },
            )
                : _AvatarLetter(
              letter: firstLetter,
            ),
          ),

          SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  cleanName.isEmpty
                      ? 'new_contact'.tr
                      : cleanName,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme.titleMedium
                      ?.copyWith(
                    color:
                    colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                if (username
                    .trim()
                    .isNotEmpty) ...[
                  SizedBox(height: 4),

                  Text(
                    username.startsWith('@')
                        ? username
                        : '@$username',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: theme
                        .textTheme.bodySmall
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_alt_1_rounded,
              color: colorScheme.primary,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarLetter extends StatelessWidget {
  final String letter;

  _AvatarLetter({
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: Text(
        letter,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ContactTextField
    extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  _ContactTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.textInputAction,
    this.keyboardType,
    this.validator,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme =
        theme.colorScheme;

    bool isDark =
        theme.brightness == Brightness.dark;

    Color fieldColor = isDark
        ? Colors.white.withValues(
      alpha: 0.04,
    )
        : Color(0xFFF6F7F9);

    Color borderColor = isDark
        ? Colors.white.withValues(
      alpha: 0.08,
    )
        : Colors.black.withValues(
      alpha: 0.06,
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      style: theme.textTheme.bodyMedium
          ?.copyWith(
        color: colorScheme.onSurface,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: colorScheme.primary,
          size: 20,
        ),
        filled: true,
        fillColor: fieldColor,
        contentPadding:
        EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        labelStyle: theme
            .textTheme.bodySmall
            ?.copyWith(
          color:
          colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
        hintStyle: theme
            .textTheme.bodySmall
            ?.copyWith(
          color: colorScheme
              .onSurfaceVariant
              .withValues(
            alpha: 0.70,
          ),
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(15),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(15),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}