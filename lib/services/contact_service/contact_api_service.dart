import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../models/contact_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';

class ContactApiService extends GetxService {
  final ApiService apiService;
  final AuthApiService authApiService;

  ContactApiService({
    required this.apiService,
    required this.authApiService,
  });

  /// GET /contacts
  Future<List<ContactModel>> getContacts({
    String search = '',
  }) async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.contactList(
        search: search,
      ),
      token: token,
    );

    return _extractList(json);
  }

  /// GET /contacts/user-options?search=...
  Future<List<ContactModel>> getUserOptions({
    required String search,
  }) async {
    final normalizedSearch = search.trim();

    // Laravel requires at least two characters.
    if (normalizedSearch.length < 2) {
      return [];
    }

    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.searchContactUsers(
        search: normalizedSearch,
      ),
      token: token,
    );

    return _extractList(json);
  }

  /// GET /contacts/{contact}
  Future<ContactModel> getContact(
      String contactId,
      ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.contactById(contactId),
      token: token,
    );

    return ContactModel.fromJson(
      _extractMap(json),
    );
  }

  /// POST /contacts
  Future<ContactModel> createContact({
    required String contactUserId,
    String? name,
    bool isFavorite = false,
    bool isBlocked = false,
  }) async {
    final token = await authApiService.requireToken();

    final body = <String, dynamic>{
      'contactUserId': contactUserId,
      'isFavorite': isFavorite,
      'isBlocked': isBlocked,
    };

    if (name != null && name.trim().isNotEmpty) {
      body['name'] = name.trim();
    }

    final json = await apiService.post(
      ApiConstants.contacts,
      body: body,
      token: token,
    );

    return ContactModel.fromJson(
      _extractMap(json),
    );
  }

  /// PATCH /contacts/{contact}
  Future<ContactModel> updateContact({
    required String contactId,
    String? name,
    bool? isFavorite,
    bool? isBlocked,
  }) async {
    final token = await authApiService.requireToken();

    final body = <String, dynamic>{};

    if (name != null) {
      body['name'] = name.trim();
    }

    if (isFavorite != null) {
      body['isFavorite'] = isFavorite;
    }

    if (isBlocked != null) {
      body['isBlocked'] = isBlocked;
    }

    if (body.isEmpty) {
      throw ArgumentError(
        'At least one contact field is required.',
      );
    }

    final json = await apiService.patch(
      ApiConstants.contactById(contactId),
      body: body,
      token: token,
    );

    return ContactModel.fromJson(
      _extractMap(json),
    );
  }

  /// DELETE /contacts/{contact}
  Future<String> deleteContact(
      String contactId,
      ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.delete(
      ApiConstants.contactById(contactId),
      token: token,
    );

    return json['message']?.toString() ??
        'Contact deleted successfully.';
  }

  List<ContactModel> _extractList(
      Map<String, dynamic> json,
      ) {
    final data = json['data'];

    if (data is! List) {
      throw const FormatException(
        'The server returned an invalid contact list.',
      );
    }

    return data
        .whereType<Map>()
        .map(
          (item) => ContactModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  Map<String, dynamic> _extractMap(
      Map<String, dynamic> json,
      ) {
    final data = json['data'] ?? json;

    if (data is! Map) {
      throw const FormatException(
        'The server returned invalid contact data.',
      );
    }

    return Map<String, dynamic>.from(data);
  }
}