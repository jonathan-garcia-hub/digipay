import 'package:local_auth/local_auth.dart';

class LocalAuthUtil {

  final _auth = LocalAuthentication();

  /// Verifica si el dispositivo soporta biometria
  Future<bool> deviceSupportBiometric() async {
    return await _auth.isDeviceSupported();
  }

  /// Verifica si el dispositivo tiene configurado información biométrica
  Future<bool> canCheckBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  /// Obtiene la lista de opciones biometricas para usar (Facial, dactilar, iris)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  /// Valida si el dispositivo soporta la biometría y si la tiene configurada en el dispositivo
  Future<bool> isBiometricSupported() async {

    final availableBiometrics = await getAvailableBiometrics();

    return await deviceSupportBiometric() &&
        await canCheckBiometrics() &&
        availableBiometrics.isNotEmpty;
  }

  /// Autenticación, valida le información biométrica con la configurada del dispositivo.
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Usa tu información biométrica para iniciar sesión',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

}