import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/contact_controller.dart';

class ContactAddButton
    extends StatelessWidget {
  final ContactController controller;

  ContactAddButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Positioned(
      right: 16,
      bottom: 110,
      child: Obx(
            () {
          bool isVisible =
              controller.showAddButton.value;

          return IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedSlide(
              duration: Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeOutCubic,
              offset: isVisible
                  ? Offset.zero
                  : Offset(0, 2),
              child: AnimatedOpacity(
                duration: Duration(
                  milliseconds: 180,
                ),
                curve: Curves.easeOutCubic,
                opacity: isVisible ? 1 : 0,
                child: FloatingActionButton(
                  heroTag: 'add_contact_fab',
                  elevation: 5,
                  highlightElevation: 2,
                  backgroundColor:
                  colorScheme.primary,
                  foregroundColor:
                  colorScheme.onPrimary,
                  onPressed:
                  controller.openAddContact,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons
                        .person_add_alt_1_rounded,
                    size: 23,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}