import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<bool> authenticateUser() async {
  try {
    final bool canAuthenticate = await auth.canCheckBiometrics || await auth.isDeviceSupported();
    if (!canAuthenticate) return false;

    final bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Please authenticate to access your profile',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    return didAuthenticate;
  } catch (e) {
    print("Auth error: $e");
    return false;
  }
}
