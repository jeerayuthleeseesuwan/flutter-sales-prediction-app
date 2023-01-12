import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:prediciton_model/components/blue_button.dart';
import 'package:prediciton_model/controllers/lockscreen_controller.dart';
import 'package:prediciton_model/views/homepage.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {

  final LockscreenController _con = LockscreenController();

  @override
  void initState() {
    super.initState();
    _con.checkBiometrics(
      deviceNotSupported: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      ),
      onRefresh: () => setState(() {})
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ///[Icon]
            _con.availableBiometrics != null && _con.availableBiometrics.contains(BiometricType.fingerprint) 
              ? Icon( Icons.fingerprint, size: 80, color: Theme.of(context).primaryColor,)
              : _con.availableBiometrics != null && _con.availableBiometrics.contains(BiometricType.face) 
              ? Icon (Icons.face, size: 80, color: Theme.of(context).primaryColor,)
              : SizedBox.shrink(),

            SizedBox(height: 20),

            ///[Lock Icon]
            Icon(Icons.lock_outline, size: 35, color: Theme.of(context).primaryColor,),

            SizedBox(height: 20),

            ///[Button]
            BlueButton(
              width: 230, 
              text: "Unlock", 
              icon: null, 
              onPressed: () => _con.authenticateWithBiometrics(
                onSuccess: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage())),
                onRefresh: () => setState(() {})
              ),
            ),
          ],
        ),
      ),
    );
  }
}