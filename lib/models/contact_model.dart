enum ContactStatus { online, offline, recently }

class ContactModel {
  final String name;
  final ContactStatus status;
  final String? avatarUrl;

  const ContactModel({
    required this.name,
    required this.status,
    this.avatarUrl,
  });

  String get statusLabel {
    switch (status) {
      case ContactStatus.online:
        return 'online';
      case ContactStatus.recently:
        return 'last seen recently';
      case ContactStatus.offline:
        return 'offline';
    }
  }
}