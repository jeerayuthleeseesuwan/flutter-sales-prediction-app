import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prediciton_model/controllers/dashboard_controller.dart';

class BarChart4Data {
  final DashboardController _con;
  final BuildContext context;
  final VoidCallback refresh;

  const BarChart4Data(this._con, this.context, this.refresh);

  BarChartData mainBarData4() {
    return BarChartData(
      barGroups: _buildAllBars4(),
      barTouchData: _buildBarTouchData4(),
      titlesData: _buildAxes4(),
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value){
          if (_con.showAverage) 
            return false;
          if (value % pow(10, _con.numOfZero4) == 0)
            return true;
          else 
            return false;
        }
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
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
    );
  }

  List<BarChartGroupData> _buildAllBars4() {

    _con.numOfZero4 = 1;
    while((_con.salesByItemCategory[1] / pow(10, _con.numOfZero4)) > 1){
      _con.numOfZero4 += 1;
    }
    _con.numOfZero4 -= 1;
    if (_con.numOfZero4 > 6) _con.numOfZero4 = 6;

    return List.generate(
      _con.salesByItemCategory.length,
      (index) => _buildBar4(index, _con.salesByItemCategory[index],
          isTouched: index == _con.touchedIndex4),
    );
  }

  BarChartGroupData _buildBar4(
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
          width: (MediaQuery.of(context).size.width - 170) / 3,
        ),
      ],
    );
  }

  FlTitlesData _buildAxes4() {
    return FlTitlesData(
      // Build X axis.
      bottomTitles: SideTitles(
        showTitles: true,
        textStyle: TextStyle(
          color: Colors.black26,
          fontSize: 12,
          letterSpacing: 1.2
        ),
        getTitles: (double value) {
          return _con.itemCategories[value.toInt()];
          
        },
      ),
      // Build Y axis.
      leftTitles: SideTitles(
        margin: 50,
        showTitles: true,
        textStyle: TextStyle(
          color: Colors.black26,
          fontSize: 10,
        ),
        getTitles: (double value) {
          if (_con.showAverage)
            return "";

          if (value % pow(10, _con.numOfZero4) == 0){
            if (_con.numOfZero4 >= 6){
              if (value % 1000000 == 0)
                return (value / 1000000).toString() + " M";
            }
            else if (_con.numOfZero4 >= 3){
              if (value % 1000 == 0)
                return (value / 1000).toString() + " K";
            }
            else if (_con.numOfZero4 >= 1){
              if (value % 10 == 0)
                return (value).toString();
            }
          }
          return "";
        },
      ),
    );
  }

  BarTouchData _buildBarTouchData4() {
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
          _con.touchedIndex4 = barTouchResponse.spot.touchedBarGroupIndex;
        }
        refresh();
      },
    );
  }
}
