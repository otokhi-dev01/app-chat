import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../models/contact_model.dart';
import '../api_service.dart';
import '../auth_service /auth_api_service.dart';

class PhoneContactApiService extends GetxService {
  final ApiService apiService;
  final AuthApiService authApiService;

  PhoneContactApiService({
    required this.apiService,
    required this.authApiService,
  });

  /// GET /phone-contacts
  Future<List<ContactModel>> getPhoneContacts() async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.phoneContacts,
      token: token,
    );

    return _extractList(json);
  }

  /// GET /phone-contacts/{phoneContact}
  Future<ContactModel> getPhoneContact(
    String contactId,
  ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.get(
      ApiConstants.phoneContactById(contactId),
      token: token,
    );

    return _mapPhoneContactToContactModel(_extractMap(json));
  }

  /// POST /phone-contacts
  Future<ContactModel> createPhoneContact({
    required String firstName,
    String? lastName,
    required String phoneNumber,
  }) async {
    final token = await authApiService.requireToken();

    final body = <String, dynamic>{
      'first_name': firstName.trim(),
      'phone_number': phoneNumber.trim(),
    };

    if (lastName != null && lastName.trim().isNotEmpty) {
      body['last_name'] = lastName.trim();
    }

    final json = await apiService.post(
      ApiConstants.phoneContacts,
      body: body,
      token: token,
    );

    return _mapPhoneContactToContactModel(_extractMap(json));
  }

  /// PATCH /phone-contacts/{phoneContact}
  Future<ContactModel> updatePhoneContact({
    required String contactId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    final token = await authApiService.requireToken();

    final body = <String, dynamic>{};

    if (firstName != null && firstName.trim().isNotEmpty) {
      body['first_name'] = firstName.trim();
    }
    if (lastName != null) {
      // Allow clearing last name
      body['last_name'] = lastName.trim();
    }
    if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
      body['phone_number'] = phoneNumber.trim();
    }

    if (body.isEmpty) {
      throw ArgumentError('At least one phone contact field is required.');
    }

    final json = await apiService.patch(
      ApiConstants.phoneContactById(contactId),
      body: body,
      token: token,
    );

    return _mapPhoneContactToContactModel(_extractMap(json));
  }

  /// DELETE /phone-contacts/{phoneContact}
  Future<String> deletePhoneContact(
    String contactId,
  ) async {
    final token = await authApiService.requireToken();

    final json = await apiService.delete(
      ApiConstants.phoneContactById(contactId),
      token: token,
    );

    return json['message']?.toString() ?? 'Contact deleted successfully.';
  }

  List<ContactModel> _extractList(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];

    if (data is! List) {
      throw const FormatException(
        'The server returned an invalid phone contact list.',
      );
    }

    return data
        .whereType<Map>()
        .map((item) => _mapPhoneContactToContactModel(Map<String, dynamic>.from(item)))
        .toList();
  }

  Map<String, dynamic> _extractMap(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] ?? json;

    if (data is! Map) {
      throw const FormatException(
        'The server returned invalid phone contact data.',
      );
    }

    return Map<String, dynamic>.from(data);
  }

  /// Maps a raw backend phone contact JSON to a unified `ContactModel`.
  ContactModel _mapPhoneContactToContactModel(Map<String, dynamic> item) {
    String id = item['id']?.toString() ?? '';
    String firstName = item['first_name']?.toString() ?? '';
    String lastName = item['last_name']?.toString() ?? '';
    String phoneNumber = item['phone_number']?.toString() ?? '';
    String ownerUserId = item['user_id']?.toString() ?? '';

    String fullName = '$firstName $lastName'.trim();

    return ContactModel(
      id: 'phone_$id', // Prefix ID to avoid collision with app contacts
      ownerUserId: ownerUserId,
      contactUserId: '', // Empty means it's a raw phone contact, not an app user
      name: fullName,
      username: '',
      phoneNumber: phoneNumber,
      avatarUrl: '', // Phone contacts don't have avatars in this schema
      status: ContactStatus.offline, // Or default
      isFavorite: false,
      isBlocked: false,
    );
  }
}
