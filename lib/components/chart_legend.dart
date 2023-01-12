import 'package:flutter/material.dart';

class ChartLegend extends StatelessWidget {

  const ChartLegend({
    Key key
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.circle, 
                  color: Color(0xFFf9de8d), 
                  size: 12,
                ),
                Text(
                  "  Supermarket Type 1",
                  style: TextStyle(color: Colors.black45, fontSize: 10),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.circle, 
                  color: Color(0xFFf29677), 
                  size: 12,
                ),
                Text(
                  " Supermarket Type 2",
                  style: TextStyle(color: Colors.black45, fontSize: 10),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.circle, 
                  color: Color(0xFF6f9fcf), 
                  size: 12,
                ),
                Text(
                  " Supermarket Type 3",
                  style: TextStyle(color: Colors.black45, fontSize: 10),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.circle, 
                  color: Color(0xFF77c1b2), 
                  size: 12,
                ),
                Text(
                  "             Grocery Store",
                  style: TextStyle(color: Colors.black45, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
