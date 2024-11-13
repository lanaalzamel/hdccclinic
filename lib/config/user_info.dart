import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../native_service/secure_storage.dart';

class Userinformation {
  static String USER_TOKEN = '';
  static int id = -1;

  static final Securestorage _secureStorage = Securestorage();

  static Future<void> fetchUserIdFromSecureStorage() async {
    try {
      Map<String, String?> data = await _secureStorage.readTokenAndUserId();
      String? userIdString = data['user_id'];

      if (userIdString != null) {
        id = int.parse(userIdString);
      } else {
        throw Exception('User ID not found in secure storage');
      }
    } catch (e) {
      throw Exception('Failed to fetch user ID from secure storage: $e');
    }
  }
}
