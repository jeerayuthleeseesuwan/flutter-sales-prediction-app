import 'package:flutter/material.dart';
import 'package:prediciton_model/components/blue_button.dart';
import 'package:prediciton_model/views/dashboard.dart';
import 'package:prediciton_model/views/predModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ///[Icon]
            Icon(Icons.eco_outlined, size: 70, color: Theme.of(context).primaryColor,),

            SizedBox(height: 20),

            BlueButton(
              width: 240, 
              text: "Dashboard", 
              icon: Icons.equalizer_rounded, 
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              )
            ),

            SizedBox(height: 20),

            BlueButton(
              width: 240, 
              text: "Sales Prediction", 
              icon: Icons.equalizer_rounded, 
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PredModel()),
              )
            ),
          ],
        ),
      ),
    );
  }
}