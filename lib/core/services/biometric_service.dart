import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fingerprint / face unlock for the app, stored per device.
class BiometricService {
  BiometricService._();

  static final BiometricService instance = BiometricService._();

  static const _enabledKey = 'athlorun_biometric_lock';

  final LocalAuthentication _auth = LocalAuthentication();

  /// Whether this device has a biometric enrolled.
  Future<bool> isAvailable() async {
    if (kIsWeb) return false;
    try {
      return await _auth.canCheckBiometrics &&
          (await _auth.getAvailableBiometrics()).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
  }

  /// Shows the system biometric prompt. Throws on platform errors so the
  /// caller can show them; returns false if the user cancels.
  Future<bool> authenticate(String reason) {
    return _auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}
