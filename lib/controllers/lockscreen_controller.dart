import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class LockscreenController extends ControllerMVC {
  factory LockscreenController() {
    if (_this == null) _this = LockscreenController._();
    return _this;
  }

  static LockscreenController _this;
  LockscreenController._();

  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics;
  List<BiometricType> availableBiometrics;
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;

  checkBiometrics({@required VoidCallback deviceNotSupported, @required VoidCallback onRefresh}) async {
    if (await auth.canCheckBiometrics == false || await auth.isDeviceSupported() == false){
      deviceNotSupported();
    }
    canCheckBiometrics = await auth.canCheckBiometrics;
    availableBiometrics = await auth.getAvailableBiometrics();

    onRefresh();
  }

  Future<void> authenticateWithBiometrics({@required VoidCallback onSuccess, @required VoidCallback onRefresh}) async {
    bool authenticated = false;
    try {
      isAuthenticating = true;
      authorized = 'Authenticating';
      onRefresh();

      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access the application',
      );

      //Success
      if (authenticated) onSuccess();
      isAuthenticating = false;

    } on PlatformException catch (e) {
      
      isAuthenticating = false;
      authorized = 'Error - ${e.message}';
      onRefresh();
      return;
    }

    authorized = authenticated ? 'Authorized' : 'Not Authorized';
    onRefresh();
  }
}