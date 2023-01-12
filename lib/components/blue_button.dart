import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final double width;
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const BlueButton({
    Key key,
    @required this.width,
    @required this.text,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20),

              Text(
                text,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),

              SizedBox(width: 8),

              if(icon != null) 
                Icon(icon, size: 27, color: Colors.white,),
            ],
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
          minimumSize: const Size.fromHeight(50),
        ),
      ),
    );
  }
}
