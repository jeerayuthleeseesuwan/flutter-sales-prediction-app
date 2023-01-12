import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prediciton_model/components/bar_chart_1_data.dart';
import 'package:prediciton_model/components/bar_chart_2_data.dart';
import 'package:prediciton_model/components/bar_chart_4_data.dart';
import 'package:prediciton_model/components/bar_chart_5_data.dart';
import 'package:prediciton_model/components/line_chart_1_data.dart';
import 'package:prediciton_model/components/line_chart_2_data.dart';
import 'package:prediciton_model/components/line_chart_3_data.dart';
import 'package:prediciton_model/components/chart_legend.dart';
import 'package:prediciton_model/controllers/dashboard_controller.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final DashboardController _con = DashboardController();

  @override
  void initState() {
    _con.loadData(onRefresh: () => setState(() {}));
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ///[Back button]
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left_outlined),
                      padding: const EdgeInsets.only(right: 0),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ///[Title]
                    Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[300], ),
                    ),
                  ],
                ),

                Divider(color: Colors.black87, height: 30),

                topKPI(),

                SizedBox(height: 20),

                _con.itemOutletSalesCol.length == 0
                ? CircularProgressIndicator()
                : Stack(
                  children: [
                    ChartLegend(),
                    barchart1(),
                    
                  ]
                ),

                SizedBox(height: 20),

                _con.itemOutletSalesCol.length == 0
                ? SizedBox.shrink() 
                : barchart2(),

                SizedBox(height: 20),

                _con.itemOutletSalesCol.length == 0
                ? SizedBox.shrink() 
                : Stack(
                  children: [
                    barchart4(),
                    lineChartItemCategory(chartHeight: 160, topPadding: 80),
                  ]
                ),

                SizedBox(height: 20),

                _con.itemOutletSalesCol.length == 0
                ? SizedBox.shrink() 
                : Stack(
                  children: [
                    barchart5(),
                    lineChartItemFat(chartHeight: 160, topPadding: 80),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget topKPI(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$ " + (
            _con.salesByOutlet.length == 0
              ? "-"
              : _con.touchedIndex == -1
              ? NumberFormat.currency(symbol: '').format(_con.salesByOutlet.fold<double>(0, (prev, element) => prev + element))
              : NumberFormat.currency(symbol: '').format(_con.salesByOutlet[_con.touchedIndex])
          ),
          style: TextStyle(fontSize: 40),
        ),
        
        SizedBox(height: 5),

        Text(
          "Total Sales",
          style: TextStyle(fontSize: 14, color: Colors.blue[300], letterSpacing: 1.1),
        ),

        SizedBox(height: 20),

        Text(
          _con.touchedIndex == -1
              ? "All"
              : _con.outletIds[_con.touchedIndex],
          style: TextStyle(fontSize: 24, letterSpacing: 1.1),
        ),
        
        SizedBox(height: 5),

        Text(
          "Outlet",
          style: TextStyle(fontSize: 14, color: Colors.blue[300], letterSpacing: 1.1),
        ),
      ]
    );
  }

  
  Widget barchart1(){
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Total Sales',
            style: TextStyle(
                color: const Color(0xff0f4a3c),
                fontSize: 24,),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'vs Outlet Identifier',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                letterSpacing: 1.1),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _con.outletIdCol.length == 0 
              ? Center(child: CircularProgressIndicator())
              : BarChart(
                BarChart1Data(_con, ()=>setState(() {})).mainBarData(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  

  Widget barchart2(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 370,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 280,
                  width: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Total Sales',
                        style: TextStyle(
                            color: const Color(0xff0f4a3c),
                            fontSize: 24,),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'vs Item Type',
                        style: TextStyle(
                            color: Colors.yellow[700],
                            fontSize: 14,
                            letterSpacing: 1.1),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      if (_con.touchedIndex != -1)
                      Text(
                        'in ' + _con.outletIds[_con.touchedIndex],
                        style: TextStyle(
                            color: Colors.blue[200],
                            fontSize: 14,
                            letterSpacing: 1.1),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _con.outletIdCol.length == 0 
                          ? Center(child: CircularProgressIndicator())
                          : BarChart(
                            BarChart2Data(_con, ()=>setState(() {})).mainBarData2(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // X axis
                Padding(
                  padding: const EdgeInsets.only(left: 45, right: 5),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          _con.itemTypes.length, 
                          (index) => Padding(
                            padding: const EdgeInsets.all(3.8),
                            child: Text(
                              _con.itemTypes[index], 
                              style: TextStyle(
                                fontSize: 10, 
                                color: Colors.black26, 
                                letterSpacing: 0,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        )
                      ),
                    )
                  ),
                )
              ],
            ),

            lineChart(chartHeight: 213, topPadding: 85, useLowerLimit: true)
          ],
        ),
      ),
    );
  }



  Widget barchart4(){
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Total Sales',
            style: TextStyle(
                color: const Color(0xff0f4a3c),
                fontSize: 24,),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'vs Item Category',
            style: TextStyle(
                color: Colors.yellow[700],
                fontSize: 14,
                letterSpacing: 1.1),
          ),
          const SizedBox(
            height: 7,
          ),
          if (_con.touchedIndex != -1)
          Text(
            'in ' + _con.outletIds[_con.touchedIndex],
            style: TextStyle(
                color: Colors.blue[200],
                fontSize: 14,
                letterSpacing: 1.1),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _con.outletIdCol.length == 0 
              ? Center(child: CircularProgressIndicator())
              : BarChart(
                BarChart4Data(_con, context, ()=>setState(() {})).mainBarData4(),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget barchart5(){
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Total Sales',
            style: TextStyle(
                color: const Color(0xff0f4a3c),
                fontSize: 24,),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'vs Item Fat Content',
            style: TextStyle(
                color: Colors.yellow[700],
                fontSize: 14,
                letterSpacing: 1.1),
          ),
          const SizedBox(
            height: 7,
          ),
          if (_con.touchedIndex != -1)
          Text(
            'in ' + _con.outletIds[_con.touchedIndex],
            style: TextStyle(
                color: Colors.blue[200],
                fontSize: 14,
                letterSpacing: 1.1),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _con.outletIdCol.length == 0 
              ? Center(child: CircularProgressIndicator())
              : BarChart(
                BarChart5Data(_con, context, ()=>setState(() {})).mainBarData5(),
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget lineChart({double chartHeight = 190, double topPadding = 100, bool useLowerLimit = false}) {
    double highest = _con.aveSalesByItemTypes.reduce(max);
    double lowest = _con.aveSalesByItemTypes.reduce(min);

    _con.numOfZeroForLine = 1;
    while((highest / pow(10, _con.numOfZeroForLine)) > 1){
      _con.numOfZeroForLine += 1;
    }
    _con.numOfZeroForLine -= 1;

    _con.lowerLimit = 5000;
    while(_con.lowerLimit > lowest){
      _con.lowerLimit -= 100;
    }

    return SizedBox(
      width: 380,
      child: Column(
        children: [

          //Show Average
          Container(
            height: topPadding,
            width: 380,
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      _con.showAverage ? Icons.check_box : Icons.check_box_outline_blank, 
                      color: Colors.blue[300], 
                      size: 18,
                    ),
                    onPressed: (){
                      setState(() {
                        _con.showAverage = !_con.showAverage;
                      });
                    }, 
                  ),
                  Text(
                    "Show Average Sales",
                    style: TextStyle(color: Colors.blue[300], fontSize: 12, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ),


          //Line Chart
          if (_con.showAverage)
          Container(
            height: chartHeight,
            width: 380,
            margin: EdgeInsets.only(right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: LineChart(LineChart1Data(_con).lineData1(useLowerLimit)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  

  Widget lineChartItemCategory({double chartHeight = 190, double topPadding = 100}) {
    double highest = _con.aveSalesByItemCategory.reduce(max);

    _con.numOfZeroForLine2 = 1;
    while((highest / pow(10, _con.numOfZeroForLine2)) > 1){
      _con.numOfZeroForLine2 += 1;
    }
    _con.numOfZeroForLine2 -= 1;

    return Column(
      children: [

        //Show Average
        Container(
          height: topPadding,
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    _con.showAverage ? Icons.check_box : Icons.check_box_outline_blank, 
                    color: Colors.blue[300], 
                    size: 18,
                  ),
                  onPressed: (){
                    setState(() {
                      _con.showAverage = !_con.showAverage;
                    });
                  }, 
                ),
                Text(
                  "Show Average Sales",
                  style: TextStyle(color: Colors.blue[300], fontSize: 12, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),


        //Line Chart
        if (_con.showAverage)
        Container(
          height: chartHeight,
          margin: EdgeInsets.only(right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 50.0,),
                  child: LineChart(LineChart2Data(_con).lineData2()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  

  Widget lineChartItemFat({double chartHeight = 190, double topPadding = 100}) {
    double highest = _con.aveSalesByItemFat.reduce(max);

    _con.numOfZeroForLine3 = 1;
    while((highest / pow(10, _con.numOfZeroForLine3)) > 1){
      _con.numOfZeroForLine3 += 1;
    }
    _con.numOfZeroForLine3 -= 1;

    return Column(
      children: [

        //Show Average
        Container(
          height: topPadding,
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    _con.showAverage ? Icons.check_box : Icons.check_box_outline_blank, 
                    color: Colors.blue[300], 
                    size: 18,
                  ),
                  onPressed: (){
                    setState(() {
                      _con.showAverage = !_con.showAverage;
                    });
                  }, 
                ),
                Text(
                  "Show Average Sales",
                  style: TextStyle(color: Colors.blue[300], fontSize: 12, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),


        //Line Chart
        if (_con.showAverage)
        Container(
          height: chartHeight,
          margin: EdgeInsets.only(right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 50.0,),
                  child: LineChart(LineChart3Data(_con).lineData3()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}


