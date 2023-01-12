import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:prediciton_model/controllers/prediction_controller.dart';
import 'package:prediciton_model/models/mart_constants.dart';

class PredModel extends StatefulWidget {
  @override
  _PredModelState createState() => _PredModelState();
}

class _PredModelState extends StateMVC<PredModel> {

  

  final PredictionController _con = PredictionController();

  @override
  void initState() {
    super.initState();
    _con.predValue = "";

    _con.setupData();
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
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left_outlined),
                      padding: const EdgeInsets.only(right: 0),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Sales Prediction",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                Text(
                  "Please enter the characteristics of the item you wish to predict sales for.",
                  style: TextStyle(color: Colors.black38, fontSize: 12),
                ),

                SizedBox(height: 15),

                Text(
                  "Item",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[300]),
                ),










                SizedBox(height: 12),
                Text(
                  "Weight",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                // Text field 1
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.black26,
                      )
                    ]
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _con.item_weight_text,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 11, bottom: 11, top: 11, right: 11),
                      hintText: "0.00",
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      isDense: true,
                      suffixIcon:Text("Pound   "),
                      suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                ),








                SizedBox(height: 17),
                Text(
                  "Fat Content",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                //Selections
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectionInRow("None", 0, _con.item_fat_content, () => _con.item_fat_content = 0, width: 100),
                    selectionInRow("Low", 1, _con.item_fat_content, () => _con.item_fat_content = 1, width: 100),
                    selectionInRow("Normal", 2, _con.item_fat_content, () => _con.item_fat_content = 2, width: 100),
                  ],
                ),








                SizedBox(height: 17),
                Text(
                  "Item Visibility",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                // Text field 2
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.black26,
                      )
                    ]
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _con.item_visibility_text,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 11, bottom: 11, top: 11, right: 11),
                      hintText: "0.0 ~ 1.0",
                      hintStyle: TextStyle(color: Colors.grey[300]),
                    ),
                  ),
                ),







                SizedBox(height: 17),
                Text(
                  "Item Category",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                //Selections
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectionInRow("Drinks", 0, _con.item_category, () => _con.item_category = 0, width: 90),
                    selectionInRow("Food", 1, _con.item_category, () => _con.item_category = 1, width: 90),
                    selectionInRow("Non-consumable", 2, _con.item_category, () => _con.item_category = 2, width: 140),
                  ],
                ),











                SizedBox(height: 17),
                Text(
                  "Item Type",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                GestureDetector(
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text("Select Item Type:"),
                          content: Container(
                            height: 270,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  item_types.length, 
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: selectionInRow(item_types[index], index, _con.item_type, () => Navigator.pop(context, index), width: 270),
                                  ),
                                
                                )
                              ),
                            ),
                          ),
                        );
                      }
                    );
                    if (result != null){
                      setState(() {
                        _con.item_type = result;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.black26,
                        )
                      ]
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical:  15),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_con.item_type < 0 ? "" : item_types[_con.item_type]),

                        Icon(Icons.arrow_drop_down)
                      ],
                    )
                  ),
                ),










                SizedBox(height: 17),
                Text(
                  "Maximum Retail Price",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                // Text field 2
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.black26,
                      )
                    ]
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _con.item_MRP_text,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 11, bottom: 11, top: 11, right: 11),
                      hintText: "0.00",
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      isDense: true,
                      suffixIcon: Text("\$   "),
                      suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                ),




                Divider(color: Colors.grey, height: 20,),









                SizedBox(height: 12),
                Text(
                  "Outlet",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[300]),
                ),


                SizedBox(height: 17),
                Text(
                  "Outlet Identifier (ID)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                GestureDetector(
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text("Select Outlet ID:"),
                          content: Container(
                            height: 270,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  outlet_ids.length, 
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: selectionInRow(outlet_ids[index], index, _con.outlet_id, () => Navigator.pop(context, index), width: 270),
                                  ),
                                
                                )
                              ),
                            ),
                          ),
                        );
                      }
                    );
                    if (result != null){
                      setState(() {
                        _con.outlet_id = result;
                        _con.outlet_type = _con.outletAttributes[outlet_ids[_con.outlet_id]][0];
                        _con.location_type = _con.outletAttributes[outlet_ids[_con.outlet_id]][1];
                        _con.outlet_size = _con.outletAttributes[outlet_ids[_con.outlet_id]][2];
                        _con.outlet_years_text.text = _con.outletAttributes[outlet_ids[_con.outlet_id]][3].toString();
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.black26,
                        )
                      ]
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical:  15),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_con.outlet_id < 0 ? "" : outlet_ids[_con.outlet_id]),

                        Icon(Icons.arrow_drop_down)
                      ],
                    )
                  ),
                ),
                SizedBox(height: 10),

                Text(
                  "Selecting an outlet will automatically fill in the other attributes below. \n\nOnly change the below values if you are trying to predict for a new outlet.",
                  style: TextStyle(color: Colors.black38, fontSize: 12),
                ),

                SizedBox(height: 5),







                SizedBox(height: 17),
                Text(
                  "Number of Years Established",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                // Text field 2
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.black26,
                      )
                    ]
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _con.outlet_years_text,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 11, bottom: 11, top: 11, right: 11),
                      hintText: "",
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      isDense: true,
                      suffixIcon:Text("year(s)   "),
                      suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                ),

  







                SizedBox(height: 17),
                Text(
                  "Size",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                //Selections
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectionInRow("Small", 0, _con.outlet_size, () => _con.outlet_size = 0, width: 100),
                    selectionInRow("Medium", 1, _con.outlet_size, () => _con.outlet_size = 1, width: 100),
                    selectionInRow("Large", 2, _con.outlet_size, () => _con.outlet_size = 2, width: 100),
                  ],
                ),







                SizedBox(height: 17),
                Text(
                  "Outlet Type",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                GestureDetector(
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text("Select Outlet Type:"),
                          content: Container(
                            height: 270,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  outlet_types.length, 
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: selectionInRow(outlet_types[index], index, _con.outlet_type, () => Navigator.pop(context, index), width: 270),
                                  ),
                                
                                )
                              ),
                            ),
                          ),
                        );
                      }
                    );
                    if (result != null){
                      setState(() {
                        _con.outlet_type = result;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.black26,
                        )
                      ]
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical:  15),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_con.outlet_type < 0 ? "" : outlet_types[_con.outlet_type]),

                        Icon(Icons.arrow_drop_down)
                      ],
                    )
                  ),
                ),







                SizedBox(height: 17),
                Text(
                  "Location (Country Tier)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),

                //Selections
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectionInRow("Tier 1", 0, _con.location_type, () => _con.location_type = 0, width: 100),
                    selectionInRow("Tier 2", 1, _con.location_type, () => _con.location_type = 1, width: 100),
                    selectionInRow("Tier 3", 2, _con.location_type, () => _con.location_type = 2, width: 100),
                  ],
                ),








                SizedBox(height: 25),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Predict Sales ",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Icon(Icons.attach_money_rounded, size: 20),
                      ],
                    ),
                  ),
                  onPressed: () => _con.dataValidation(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),


                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectionInRow(String label, int index, int selection, Function() onClick, {double width = 100}){
    return GestureDetector(
      onTap: () => setState(() {
        onClick();
      }),
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          color: selection == index 
            ? Theme.of(context).primaryColor 
            : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black26,
            )
          ]
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selection == index
                ? Colors.white
                : Colors.black,
            ),
          )
        ),
      ),
    );
  }

  
  
}
