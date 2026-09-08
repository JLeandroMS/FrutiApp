import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _recordarUsuarioKey = 'recordarUsuario';
  static const String _usuarioRecordadoKey = 'usuarioRecordado';

  Future<void> guardarPreferencia({
    required bool recordarUsuario,
    required String usuario,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_recordarUsuarioKey, recordarUsuario);

    if (recordarUsuario) {
      await prefs.setString(_usuarioRecordadoKey, usuario);
    } else {
      await prefs.remove(_usuarioRecordadoKey);
    }
  }

  Future<bool> obtenerRecordarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_recordarUsuarioKey) ?? false;
  }

  Future<String?> obtenerUsuarioRecordado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usuarioRecordadoKey);
  }

  Future<void> limpiarUsuarioRecordado() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_recordarUsuarioKey, false);
    await prefs.remove(_usuarioRecordadoKey);
  }
}
