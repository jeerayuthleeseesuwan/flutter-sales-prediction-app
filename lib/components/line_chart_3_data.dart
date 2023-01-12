import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prediciton_model/controllers/dashboard_controller.dart';

class LineChart3Data {
  final DashboardController _con;

  const LineChart3Data(this._con);

   LineChartData lineData3() {

    double lowest = _con.aveSalesByItemFat.reduce(min);
    int _lowerLimit = 5000;
    while(_lowerLimit > lowest){
      _lowerLimit -= 100;
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < _con.aveSalesByItemFat.length; i ++){
      spots.add(FlSpot((i + 1).toDouble(), _con.aveSalesByItemFat[i]));
    }

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItems: (listOfSpot) {
            return [LineTooltipItem(
              'Sales\n\$' + NumberFormat.currency(symbol: '').format(listOfSpot[0].y),
              TextStyle(color: Colors.white),
            )];
          },
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value){
          if (value % pow(10, _con.numOfZeroForLine3) == 0)
            return true;
          else 
            return false;
        }
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 15,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Colors.black26,
            fontSize: 12,
          ),
          getTitles: (double value) {
            if (value % pow(10, _con.numOfZeroForLine3) == 0){
              
              if (_con.numOfZeroForLine3 >= 6){
                if (value % 1000000 == 0)
                  return (value / 1000000).toString() + " M";
              }
              else if (_con.numOfZeroForLine3 >= 3){
                if (value % 1000 == 0)
                  return (value / 1000).toString() + " K";
              }
              else if (_con.numOfZeroForLine3 >= 1){
                if (value % 10 == 0)
                  return (value).toString();
              }
            }
            return "";
          },
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: _con.aveSalesByItemFat.length.toDouble(),
      minY: _lowerLimit.toDouble(),
      
      lineBarsData: [
        LineChartBarData(
          // all the spots of the line chart.
          spots: spots,
          // curved or straight line.
          isCurved: false,
          isStrokeCapRound: true,
          // Color of the rod.
          colors: const [
            Color(0xff27b6fc),
          ],
          barWidth: 1,
          // Data of dot.
          dotData: FlDotData(
            show: true,
          ),
          // To highlight the data below the line curve.
          belowBarData: BarAreaData(
            show: false,
          ),
        )
      ],
    );
  }
}
