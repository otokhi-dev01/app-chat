import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat_model.dart';

class VisitedUser {
  final String id;
  final String name;
  final String image;
  final String type;
  final String message;
  final bool isOnline;

  VisitedUser({
    required this.id,
    required this.name,
    required this.image,
    this.type = 'personal',
    this.message = '',
    this.isOnline = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'type': type,
    'message': message,
    'isOnline': isOnline,
  };

  factory VisitedUser.fromJson(Map<String, dynamic> json) => VisitedUser(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    image: json['image']?.toString() ?? '',
    type: json['type']?.toString() ?? 'personal',
    message: json['message']?.toString() ?? '',
    isOnline: json['isOnline'] == true || json['isOnline'] == 'true',
  );

  factory VisitedUser.fromChat(ChatModel chat) => VisitedUser(
    id: chat.id,
    name: chat.name,
    image: chat.image,
    type: chat.type,
    message: chat.message,
    isOnline: chat.isOnline,
  );
}

class SearchHistoryService {
  static const String _key = 'search_history';
  static const String _visitedUsersKey = 'visited_users_history';
  static const int _maxItems = 10;
  static const int _maxVisitedUsers = 15;

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<List<String>> getHistory() async {
    final List<String>? stored = await _preferences.getStringList(_key);
    if (stored == null) {
      return <String>[];
    }
    return List<String>.from(stored);
  }

  Future<void> addSearch(String value) async {
    final String query = value.trim();

    if (query.isEmpty) {
      return;
    }

    final List<String> history = await getHistory();

    history.removeWhere(
      (String item) => item.trim().toLowerCase() == query.toLowerCase(),
    );

    history.insert(0, query);

    if (history.length > _maxItems) {
      history.removeRange(_maxItems, history.length);
    }

    await _preferences.setStringList(_key, history);
  }

  Future<void> removeSearch(String value) async {
    final String query = value.trim();
    final List<String> history = await getHistory();

    history.removeWhere(
      (String item) => item.trim().toLowerCase() == query.toLowerCase(),
    );

    await _preferences.setStringList(_key, history);
  }

  Future<void> clearHistory() async {
    await _preferences.remove(_key);
  }

  Future<List<VisitedUser>> getVisitedUsers() async {
    final List<String>? stored = await _preferences.getStringList(_visitedUsersKey);
    if (stored == null) {
      return <VisitedUser>[];
    }
    final List<VisitedUser> list = <VisitedUser>[];
    for (final String s in stored) {
      try {
        final dynamic decoded = jsonDecode(s);
        if (decoded is Map<String, dynamic>) {
          list.add(VisitedUser.fromJson(decoded));
        }
      } catch (_) {}
    }
    return list;
  }

  Future<void> addVisitedUser(VisitedUser user) async {
    if (user.id.isEmpty && user.name.isEmpty) {
      return;
    }

    final List<VisitedUser> users = await getVisitedUsers();

    users.removeWhere(
      (VisitedUser u) =>
          (user.id.isNotEmpty && u.id == user.id) ||
          (user.id.isEmpty && u.name.trim().toLowerCase() == user.name.trim().toLowerCase()),
    );

    users.insert(0, user);

    if (users.length > _maxVisitedUsers) {
      users.removeRange(_maxVisitedUsers, users.length);
    }

    final List<String> encoded = users.map((VisitedUser u) => jsonEncode(u.toJson())).toList();
    await _preferences.setStringList(_visitedUsersKey, encoded);
  }

  Future<void> removeVisitedUser(String id) async {
    final List<VisitedUser> users = await getVisitedUsers();

    users.removeWhere((VisitedUser u) => u.id == id);

    final List<String> encoded = users.map((VisitedUser u) => jsonEncode(u.toJson())).toList();
    await _preferences.setStringList(_visitedUsersKey, encoded);
  }

  Future<void> clearVisitedUsers() async {
    await _preferences.remove(_visitedUsersKey);
  }
}