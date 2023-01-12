import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prediciton_model/controllers/dashboard_controller.dart';

class BarChart2Data {
  final DashboardController _con;
  final VoidCallback refresh;

  const BarChart2Data(this._con, this.refresh);

  BarChartData mainBarData2() {
    return BarChartData(
      barGroups: _buildAllBars2(),
      barTouchData: _buildBarTouchData2(),
      titlesData: _buildAxes2(),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value){
          if (_con.showAverage) 
            return false;
          if (value % pow(10, _con.numOfZero2) == 0)
            return true;
          else 
            return false;
        }
      ),
    );
  }

  List<BarChartGroupData> _buildAllBars2() {

    _con.calculateTotalsAndMeans();

    _con.numOfZero2 = 1;
    while((_con.salesByItemTypes[6] / pow(10, _con.numOfZero2)) > 1){
      _con.numOfZero2 += 1;
    }
    _con.numOfZero2 -= 1;

    return List.generate(
      _con.salesByItemTypes.length,
      (index) => _buildBar2(index, _con.salesByItemTypes[index],
          isTouched: index == _con.touchedIndex2),
    );
  }

  BarChartGroupData _buildBar2(
    int x,
    double y, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: _con.barColors[x],
          borderRadius: BorderRadius.circular(3),
          width: 17,
        ),
      ],
    );
  }

  FlTitlesData _buildAxes2() {
    return FlTitlesData(
      // Build X axis.
      bottomTitles: SideTitles(
        rotateAngle: -90,
        showTitles: false,
        textStyle: TextStyle(
          color: Colors.black26,
          fontSize: 12,
          letterSpacing: 1.2
        ),
        margin: 88,
        getTitles: (double value) {
          return _con.itemTypes[value.toInt()];
        },
      ),
      // Build Y axis.
      leftTitles: SideTitles(
        margin: 13,
        showTitles: true,
        textStyle: TextStyle(
          color: Colors.black26,
          fontSize: 10,
        ),
        getTitles: (double value) {
          if (_con.showAverage)
            return "";

          if (value % pow(10, _con.numOfZero2) == 0){
            if (_con.numOfZero2 >= 6){
              if (value % 1000000 == 0)
                return (value / 1000000).toString() + " M";
            }
            else if (_con.numOfZero2 >= 3){
              if (value % 1000 == 0)
                return (value / 1000).toString() + " K";
            }
          }
          return "";
        },
      ),
    );
  }

  BarTouchData _buildBarTouchData2() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.grey[600],
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            'Sales\n\$' + NumberFormat.currency(symbol: '').format(rod.y),
            TextStyle(color: Colors.white),
          );
        },
      ),
      touchCallback: (barTouchResponse) {
        if (barTouchResponse.spot != null &&
            barTouchResponse.touchInput is! FlPanEnd &&
            barTouchResponse.touchInput is! FlLongPressEnd) {
          _con.touchedIndex2 = barTouchResponse.spot.touchedBarGroupIndex;
        }
        refresh();
      },
    );
  }
}
