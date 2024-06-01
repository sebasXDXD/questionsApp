import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Guarda un access_token
  Future<void> saveAccessToken(String? token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  // Lee el access_token guardado
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Elimina el access_token
  Future<void> deleteAccessToken() async {
    await _storage.delete(key: 'access_token');
  }

  // Guarda el estado de isAdmin como un booleano
  Future<void> saveIsAdmin(bool isAdmin) async {
    await _storage.write(key: 'is_admin', value: isAdmin.toString());
  }

  // Lee el estado de isAdmin guardado y lo convierte a booleano
  Future<bool?> getIsAdmin() async {
    String? isAdminString = await _storage.read(key: 'is_admin');
    return isAdminString == null ? null : isAdminString.toLowerCase() == 'true';
  }

  // Elimina el estado de isAdmin
  Future<void> deleteIsAdmin() async {
    await _storage.delete(key: 'is_admin');
  }
}
