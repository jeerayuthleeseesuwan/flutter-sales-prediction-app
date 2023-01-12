import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prediciton_model/controllers/dashboard_controller.dart';

class BarChart1Data {
  final DashboardController _con;
  final VoidCallback refresh;

  const BarChart1Data(this._con, this.refresh);

  BarChartData mainBarData() {
    return BarChartData(
      barGroups: _buildAllBars(),
      barTouchData: _buildBarTouchData(),
      titlesData: _buildAxes(),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value){
          if (value % 1000000 == 0)
            return true;
          else 
            return false;
        }
      ),
    );
  }

  List<BarChartGroupData> _buildAllBars() {

    return List.generate(
      _con.salesByOutlet.length,
      (index) => _buildBar(index, _con.salesByOutlet[index],
          isTouched: index == _con.touchedIndex),
    );
  }

  BarChartGroupData _buildBar(
    int x,
    double y, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: isTouched ? Colors.black : _con.outTypeColors[x],
          borderRadius: BorderRadius.circular(5),
          width: 20,
        ),
      ],
    );
  }

  FlTitlesData _buildAxes() {
    return FlTitlesData(
      // Build X axis.
      bottomTitles: SideTitles(
        rotateAngle: -90,
        showTitles: true,
        textStyle: TextStyle(
          color: Colors.blue[200],
          fontSize: 12,
          letterSpacing: 1.2
        ),
        margin: 38,
        getTitles: (double value) {
          return _con.outletIds[value.toInt()];
        },
      ),
      // Build Y axis.
      leftTitles: SideTitles(
        showTitles: true,
        textStyle: TextStyle(
          color: Colors.black26,
          fontSize: 10,
        ),
        getTitles: (double value) {
          if (value % 1000000 == 0)
            return (value / 1000000).toString() + " M";
          else 
            return "";
        },
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey[600],
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            'Total Sales:\n\$' + NumberFormat.currency(symbol: '').format(rod.y) + '\n\n'
            + 'Size: ' + _con.outSizeLbl[groupIndex] + '\n'
            + 'Location: ' + _con.outTierLbl[groupIndex] + '\n'
            + 'Outlet Years: ' + _con.outYearsLbl[groupIndex],
            TextStyle(color: Colors.white),
          );
        },
      ),
      touchCallback: (barTouchResponse) {
        if (barTouchResponse.spot != null &&
            barTouchResponse.touchInput is! FlPanEnd &&
            barTouchResponse.touchInput is! FlLongPressEnd) {
          _con.touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
        }
        refresh();
      },
    );
  }
}
