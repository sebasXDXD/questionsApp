import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Guarda el access_token y el estado de isAdmin
  Future<void> saveAccessTokenAndIsAdmin(String? token, bool isAdmin) async {
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'isAdmin', value: isAdmin.toString());
  }

  // Lee el access_token y el estado de isAdmin guardado
  Future<Map<String, dynamic>> getAccessTokenAndIsAdmin() async {
    String? token = await _storage.read(key: 'token');
    String? isAdminString = await _storage.read(key: 'isAdmin');
    bool? isAdmin = isAdminString == null ? null : isAdminString.toLowerCase() == 'true';
    return {
      'token': token,
      'isAdmin': isAdmin
    };
  }

  // Elimina el access_token y el estado de isAdmin
  Future<void> deleteAccessTokenAndIsAdmin() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'isAdmin');
  }
}
