import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../models/contact_model.dart';
import '../widgets/contact/contact_search_field.dart';
import '../widgets/contact/contact_section_header.dart';
import '../widgets/contact/contact_title.dart';

class ContactScreen extends StatefulWidget {
  ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController searchController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();

  final List<ContactModel> allContacts = [
    ContactModel(
      name: 'Alex Morgan',
      status: ContactStatus.online,
    ),
    ContactModel(
      name: 'Amanda Lee',
      status: ContactStatus.offline,
    ),
    ContactModel(
      name: 'Brian Cooper',
      status: ContactStatus.recently,
    ),
    ContactModel(
      name: 'Chloe Bennett',
      status: ContactStatus.online,
    ),
    ContactModel(
      name: 'Daniel Kim',
      status: ContactStatus.offline,
    ),
    ContactModel(
      name: 'Emma Watson',
      status: ContactStatus.recently,
    ),
    ContactModel(
      name: 'Ethan Parker',
      status: ContactStatus.online,
    ),
    ContactModel(
      name: 'Fiona Davis',
      status: ContactStatus.offline,
    ),
    ContactModel(
      name: 'George Miller',
      status: ContactStatus.online,
    ),
    ContactModel(
      name: 'Hannah Scott',
      status: ContactStatus.recently,
    ),
  ];

  String query = '';
  bool showFab = true;

  List<ContactModel> get filteredContacts {
    final String searchQuery =
    query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return allContacts;
    }

    return allContacts.where(
          (ContactModel contact) {
        return contact.name
            .toLowerCase()
            .contains(searchQuery);
      },
    ).toList();
  }

  Map<String, List<ContactModel>> get groupedContacts {
    final Map<String, List<ContactModel>> grouped = {};

    for (final ContactModel contact in filteredContacts) {
      final String contactName = contact.name.trim();

      if (contactName.isEmpty) {
        continue;
      }

      final String letter =
      contactName[0].toUpperCase();

      grouped.putIfAbsent(
        letter,
            () => <ContactModel>[],
      );

      grouped[letter]!.add(contact);
    }

    return grouped;
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!scrollController.hasClients || !mounted) {
      return;
    }

    final ScrollDirection direction =
        scrollController.position.userScrollDirection;

    if (direction == ScrollDirection.reverse) {
      // User scrolls down.
      if (showFab) {
        setState(() {
          showFab = false;
        });
      }
    } else if (direction == ScrollDirection.forward) {
      // User scrolls up.
      if (!showFab) {
        setState(() {
          showFab = true;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      query = value;
    });
  }

  void _openAddContact() {
    FocusScope.of(context).unfocus();

    // TODO: Navigate to add-contact screen.
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme =
        theme.colorScheme;

    final Map<String, List<ContactModel>> grouped =
        groupedContacts;

    final List<String> letters =
    grouped.keys.toList()..sort();

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              ContactSearchField(
                controller: searchController,
                onChanged: _onSearchChanged,
              ),
              Expanded(
                child: letters.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        size: 52,
                        color: colorScheme
                            .onSurfaceVariant
                            .withValues(
                          alpha: 0.55,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No contacts found',
                        style: TextStyle(
                          color: colorScheme
                              .onSurfaceVariant,
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 100),
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: letters.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String letter = letters[index];

                    final List<ContactModel> contacts =
                        grouped[letter] ?? <ContactModel>[];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContactSectionHeader(
                          letter: letter,
                        ),
                        ...contacts.map(
                              (ContactModel contact) {
                            return ContactTile(
                              contact: contact,
                              onTap: () {},
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 110,
            child: IgnorePointer(
              ignoring: !showFab,
              child: AnimatedSlide(
                duration: Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                offset: showFab
                    ? Offset.zero
                    : Offset(0, 2),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  opacity: showFab ? 1 : 0,
                  child: FloatingActionButton(
                    heroTag: 'add_contact_fab',
                    backgroundColor:
                    Theme.of(context).colorScheme.primary,
                    foregroundColor:
                    Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      // Navigate to add contact screen.
                    },
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}