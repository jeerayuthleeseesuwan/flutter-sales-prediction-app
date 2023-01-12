import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prediciton_model/models/mart_constants.dart';

class PredictionController extends ControllerMVC {

  PredictionController();

  var predValue = "";
  TextEditingController item_weight_text = new TextEditingController();
  TextEditingController item_visibility_text = new TextEditingController();
  TextEditingController item_MRP_text = new TextEditingController();
  int item_fat_content = -1;
  int item_category = -1;
  int item_type= -1;
  int outlet_id = -1;
  TextEditingController outlet_years_text = new TextEditingController();
  int outlet_size = -1;
  int outlet_type = -1;
  int location_type = -1;

  dataValidation(BuildContext context){
    if (item_weight_text.text == "" && item_fat_content == -1 && item_visibility_text.text == "" &&
      item_category == -1 && item_type == -1 && item_MRP_text.text == "" && outlet_id == -1 &&
      outlet_years_text.text == "" && outlet_size == -1 && location_type == -1) {
      showAlertDialog("Please fill in all the fields in the form before predicting the sales value.",context);
    } 
    else if (item_weight_text.text == "") 
      showAlertDialog("Please enter item weight.",context);
    else if (item_weight_text.text != null && double.tryParse(item_weight_text.text) == null
      || double.tryParse(item_weight_text.text) < 0) 
      showAlertDialog("Please enter a valid item weight.",context); 
    else if (item_fat_content == null || item_fat_content == -1) 
      showAlertDialog("Please select an item fat content.",context);
    else if (item_visibility_text.text == "") 
      showAlertDialog("Please enter item visibility.",context);
    else if (item_visibility_text.text != null && double.tryParse(item_visibility_text.text) == null) 
      showAlertDialog("Please enter a valid value for item visibility.",context);
    else if (double.tryParse(item_visibility_text.text) > 1 || double.tryParse(item_visibility_text.text) < 0) 
      showAlertDialog("Please enter a value that is between 0 to 1 for item visibility.",context);
    else if (item_category == null || item_category == -1) 
      showAlertDialog("Please select an item type.",context);
    else if (item_type == null || item_type == -1) 
      showAlertDialog("Please select an item category.",context);
    else if (item_MRP_text.text == "") 
      showAlertDialog("Please enter item's maximum retail price.",context);
    else if (item_MRP_text.text != null && double.tryParse(item_MRP_text.text) == null
      || double.tryParse(item_MRP_text.text) < 0) 
      showAlertDialog("Please enter a valid value for maximum retail price.",context);
    else if (outlet_id == null || outlet_id == -1) 
      showAlertDialog("Please select an outlet id.",context);
    else if (outlet_years_text.text == "") 
      showAlertDialog("Please enter the number of years established.",context);
    else if (outlet_years_text.text != null && int.tryParse(outlet_years_text.text) == null
      || int.tryParse(outlet_years_text.text) < 0) 
      showAlertDialog("Please enter a valid value for Number of Years Established. \n(No decimal values are allowed)",context);
    else if (outlet_size == null || outlet_size == -1) 
      showAlertDialog("Please select an outlet size.",context);
    else if (location_type == null || location_type == -1) 
      showAlertDialog("Please select the outlet location.",context);
    else 
      predData(context);
  }

  showAlertDialog(String content, BuildContext context) {

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attention"),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }


  Future<void> predData(BuildContext context) async {
    final interpreter = await Interpreter.fromAsset('converted.tflite');
    var input = [
      [
        z_normalise(double.parse(item_weight_text.text), mean_item_weight, std_item_weight), 
        item_fat_content.toDouble(), 
        z_normalise(double.parse(item_visibility_text.text), mean_item_visibility, std_item_visibility), 
        item_type.toDouble(),	
        z_normalise(double.parse(item_MRP_text.text), mean_item_MRP, std_item_MRP),	
        outlet_size.toDouble(),	
        location_type.toDouble(),	
        z_normalise(double.parse(outlet_years_text.text), mean_outlet_years, std_outlet_years),
        outlet_type == 0 ? 1.0 : 0.0,
        outlet_type == 1 ? 1.0 : 0.0,
        outlet_type == 2 ? 1.0 : 0.0,
        outlet_type == 3 ? 1.0 : 0.0,
        outlet_id == 0 ? 1.0 : 0.0,
        outlet_id == 1 ? 1.0 : 0.0,
        outlet_id == 2 ? 1.0 : 0.0,
        outlet_id == 3 ? 1.0 : 0.0,
        outlet_id == 4 ? 1.0 : 0.0,
        outlet_id == 5 ? 1.0 : 0.0,
        outlet_id == 6 ? 1.0 : 0.0,
        outlet_id == 7 ? 1.0 : 0.0,
        outlet_id == 8 ? 1.0 : 0.0,
        outlet_id == 9 ? 1.0 : 0.0,
        item_category == 0 ? 1.0 : 0.0,
        item_category == 1 ? 1.0 : 0.0,
        item_category == 2 ? 1.0 : 0.0
      ]
    ];

    


    //Get output
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);

    // Get result
    var resultAfterLogTrans = output[0][0];
    var resultBeforeLogTrans = exp(resultAfterLogTrans);

    setState(() {
      // Display result
      predValue = resultBeforeLogTrans.toString(); 
    });

    //Smart justification
    String miniReport = "";
    

    miniReport += interpretPredictedSales(outlet_id, resultBeforeLogTrans);
    miniReport += '\n';

    
    
    miniReport += "You have selected " + item_categories_string[item_category] + "\n";

    miniReport += checkRanking(
      aveSalesForItemCategoryMap, 
      outlet_ids[outlet_id], 
      item_category, 
      "Item Category",
      item_categories_string[item_category],
      ".");

    miniReport += "Next, you have selected " + item_types[item_type] + "\n";

    miniReport += checkRanking(
      aveSalesForItemTypeMap, 
      outlet_ids[outlet_id], 
      item_type, 
      "Item Type",
      item_types[item_type],
      ".");

    miniReport += '\n';

    miniReport += "Next, " + interpretMRP(outlet_id);

    miniReport += '\n';

    miniReport += "You are predicting sales for " +  outlet_ids[outlet_id] + ".\n";
    if (outlet_id == 0 || outlet_id == 4){
      miniReport += "It is important to note that this outlet has relatively low average sales per item.\n";
    }

    miniReport += '\n';


    //Try other values
    miniReport += optimiseWeight(interpreter, resultAfterLogTrans);
    miniReport += '\n';
    miniReport += optimiseMRP(interpreter, resultAfterLogTrans);
    miniReport += '\n';
    miniReport += "Outlet Recommendations\n";
    miniReport += optimiseOutletId(interpreter, resultAfterLogTrans);


    //Show msg box
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: SingleChildScrollView(
            child: Text(
              "The sales prediction for this outlet and item is \$ " + resultBeforeLogTrans.toStringAsFixed(3) + ".\n\n"
              + miniReport,
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }


  double z_normalise(double x, double mean, double std){
    return (x - mean) / std;
  }



  optimiseWeight(Interpreter interpreter, dynamic resultAfterLogTrans){
    var resultToOptimise = resultAfterLogTrans;
    
    double changeInterval = 5;
    double amountChanged = changeInterval;
    for (int i = 0 ; i < 3; i ++){
      var input = [
        [
          z_normalise(double.parse(item_weight_text.text) + amountChanged, mean_item_weight, std_item_weight), 
          item_fat_content.toDouble(), 
          z_normalise(double.parse(item_visibility_text.text), mean_item_visibility, std_item_visibility), 
          item_type.toDouble(),	
          z_normalise(double.parse(item_MRP_text.text), mean_item_MRP, std_item_MRP),	
          outlet_size.toDouble(),	
          location_type.toDouble(),	
          z_normalise(double.parse(outlet_years_text.text), mean_outlet_years, std_outlet_years),
          outlet_type == 0 ? 1.0 : 0.0,
          outlet_type == 1 ? 1.0 : 0.0,
          outlet_type == 2 ? 1.0 : 0.0,
          outlet_type == 3 ? 1.0 : 0.0,
          outlet_id == 0 ? 1.0 : 0.0,
          outlet_id == 1 ? 1.0 : 0.0,
          outlet_id == 2 ? 1.0 : 0.0,
          outlet_id == 3 ? 1.0 : 0.0,
          outlet_id == 4 ? 1.0 : 0.0,
          outlet_id == 5 ? 1.0 : 0.0,
          outlet_id == 6 ? 1.0 : 0.0,
          outlet_id == 7 ? 1.0 : 0.0,
          outlet_id == 8 ? 1.0 : 0.0,
          outlet_id == 9 ? 1.0 : 0.0,
          item_category == 0 ? 1.0 : 0.0,
          item_category == 1 ? 1.0 : 0.0,
          item_category == 2 ? 1.0 : 0.0
        ]
      ];

      


      //Get output
      var output = List.filled(1, 0).reshape([1, 1]);
      interpreter.run(input, output);

      

      // Get result
      var tempResult = output[0][0];

      //if improved
      if (tempResult > resultToOptimise) {

        resultToOptimise = tempResult;

        if (amountChanged > 0) amountChanged += changeInterval;
        else amountChanged -= changeInterval;
      }
      // if decrease in performance 
      else {
        if (i == 0){ // on the first try
          amountChanged *= -1; // switch direction
        }
        else { 
          break;
        }
      }
      
    }

    return ("Recommendation 1:\nIt is recommended to change weight to " 
    + (double.parse(item_weight_text.text) + amountChanged).toString() 
    + " Pound (" + (amountChanged > 0 ? "+" : "") + amountChanged.toString() 
    + "). Sales are predicted to increase to \$ " + exp(resultToOptimise).toStringAsFixed(3) + ".\n\n");
  }


optimiseMRP(Interpreter interpreter, dynamic resultAfterLogTrans){
    var resultToOptimise = resultAfterLogTrans;
    
    double changeInterval = 10;
    double amountChanged = changeInterval;
    for (int i = 0 ; i < 5; i ++){
      var input = [
        [
          z_normalise(double.parse(item_weight_text.text), mean_item_weight, std_item_weight), 
          item_fat_content.toDouble(), 
          z_normalise(double.parse(item_visibility_text.text), mean_item_visibility, std_item_visibility), 
          item_type.toDouble(),	
          z_normalise(double.parse(item_MRP_text.text) + amountChanged, mean_item_MRP, std_item_MRP),	
          outlet_size.toDouble(),	
          location_type.toDouble(),	
          z_normalise(double.parse(outlet_years_text.text), mean_outlet_years, std_outlet_years),
          outlet_type == 0 ? 1.0 : 0.0,
          outlet_type == 1 ? 1.0 : 0.0,
          outlet_type == 2 ? 1.0 : 0.0,
          outlet_type == 3 ? 1.0 : 0.0,
          outlet_id == 0 ? 1.0 : 0.0,
          outlet_id == 1 ? 1.0 : 0.0,
          outlet_id == 2 ? 1.0 : 0.0,
          outlet_id == 3 ? 1.0 : 0.0,
          outlet_id == 4 ? 1.0 : 0.0,
          outlet_id == 5 ? 1.0 : 0.0,
          outlet_id == 6 ? 1.0 : 0.0,
          outlet_id == 7 ? 1.0 : 0.0,
          outlet_id == 8 ? 1.0 : 0.0,
          outlet_id == 9 ? 1.0 : 0.0,
          item_category == 0 ? 1.0 : 0.0,
          item_category == 1 ? 1.0 : 0.0,
          item_category == 2 ? 1.0 : 0.0
        ]
      ];

      


      //Get output
      var output = List.filled(1, 0).reshape([1, 1]);
      interpreter.run(input, output);

      

      // Get result
      var tempResult = output[0][0];

      //if improved
      if (tempResult > resultToOptimise) {

        resultToOptimise = tempResult;

        if (amountChanged > 0) amountChanged += changeInterval;
        else amountChanged -= changeInterval;
      }
      // if decrease in performance 
      else {
        if (i == 0){ // on the first try
          amountChanged *= -1; // switch direction
        }
        else { 
          break;
        }
      }
      
    }

    return ("Recommendation 2:\nIt is recommended to change Maximum Retail Price to " 
    + (double.parse(item_MRP_text.text) + amountChanged).toString() + " (" 
    + (amountChanged > 0 ? "+" : "") +  amountChanged.toString() 
    + "). Sales are predicted to increase to \$ " + exp(resultToOptimise).toStringAsFixed(3) + ".\n\n");
  }



optimiseOutletId(Interpreter interpreter, dynamic resultAfterLogTrans){
    var resultToOptimise = resultAfterLogTrans;
    
    double changeInterval = 1;
    double amountChanged = changeInterval;
    int tempId;
    int tempYears;
    int tempOutletType;
    int tempLocationType;
    int tempOutletSize;
    for (int i = 0 ; i < 10; i ++){
      tempId = outlet_id + amountChanged.toInt();
      tempYears = outletAttributes[outlet_ids[tempId]][3];
      tempOutletType = outletAttributes[outlet_ids[tempId]][0];
      tempLocationType = outletAttributes[outlet_ids[tempId]][1];
      tempOutletSize = outletAttributes[outlet_ids[tempId]][2];
      var input = [
        [
          z_normalise(double.parse(item_weight_text.text), mean_item_weight, std_item_weight), 
          item_fat_content.toDouble(), 
          z_normalise(double.parse(item_visibility_text.text), mean_item_visibility, std_item_visibility), 
          item_type.toDouble(),	
          z_normalise(double.parse(item_MRP_text.text), mean_item_MRP, std_item_MRP),	
          tempOutletSize.toDouble(),	
          tempLocationType.toDouble(),	
          z_normalise(tempYears.toDouble(), mean_outlet_years, std_outlet_years),
          tempOutletType == 0 ? 1.0 : 0.0,
          tempOutletType == 1 ? 1.0 : 0.0,
          tempOutletType == 2 ? 1.0 : 0.0,
          tempOutletType == 3 ? 1.0 : 0.0,
          tempId == 0 ? 1.0 : 0.0,
          tempId == 1 ? 1.0 : 0.0,
          tempId == 2 ? 1.0 : 0.0,
          tempId == 3 ? 1.0 : 0.0,
          tempId == 4 ? 1.0 : 0.0,
          tempId == 5 ? 1.0 : 0.0,
          tempId == 6 ? 1.0 : 0.0,
          tempId == 7 ? 1.0 : 0.0,
          tempId == 8 ? 1.0 : 0.0,
          tempId == 9 ? 1.0 : 0.0,
          item_category == 0 ? 1.0 : 0.0,
          item_category == 1 ? 1.0 : 0.0,
          item_category == 2 ? 1.0 : 0.0
        ]
      ];

      


      //Get output
      var output = List.filled(1, 0).reshape([1, 1]);
      interpreter.run(input, output);

      

      // Get result
      var tempResult = output[0][0];

      //if improved
      if (tempResult > resultToOptimise) {

        resultToOptimise = tempResult;

        if (amountChanged > 0) amountChanged += changeInterval;
        else amountChanged -= changeInterval;

        if (outlet_id.toDouble() + amountChanged < 0 || outlet_id.toDouble() + amountChanged > 9){
          break;
        }
      }
      // if decrease in performance 
      else {
        if (i == 0){ // on the first try
          amountChanged *= -1; // switch direction
        }
        else { 
          if (amountChanged > 0) tempId -= 1;
          else tempId += 1;
          
          break;
        }
      }
      
    }

    if (tempId == outlet_id) return " - ";

    return ("Recommendation 3:\nIt is recommended to change the Outlet from "
    + outlet_ids[outlet_id] + " to " 
    + outlet_ids[tempId].toString() 
    + ". By selling in " + outlet_ids[tempId].toString()  
    + ", sales of this item is predicted to increase to \$ " + exp(resultToOptimise).toStringAsFixed(3) + ".\n\n");
  
    
  }




optimiseOutletSize(Interpreter interpreter, dynamic resultAfterLogTrans){
    var resultToOptimise = resultAfterLogTrans;
    
    double changeInterval = 1;
    double amountChanged = changeInterval;
    for (int i = 0 ; i < 2; i ++){
      var input = [
        [
          z_normalise(double.parse(item_weight_text.text), mean_item_weight, std_item_weight), 
          item_fat_content.toDouble(), 
          z_normalise(double.parse(item_visibility_text.text), mean_item_visibility, std_item_visibility), 
          item_type.toDouble(),	
          z_normalise(double.parse(item_MRP_text.text), mean_item_MRP, std_item_MRP),	
          outlet_size.toDouble() + amountChanged,	
          location_type.toDouble(),	
          z_normalise(double.parse(outlet_years_text.text), mean_outlet_years, std_outlet_years),
          outlet_type == 0 ? 1.0 : 0.0,
          outlet_type == 1 ? 1.0 : 0.0,
          outlet_type == 2 ? 1.0 : 0.0,
          outlet_type == 3 ? 1.0 : 0.0,
          outlet_id == 0 ? 1.0 : 0.0,
          outlet_id == 1 ? 1.0 : 0.0,
          outlet_id == 2 ? 1.0 : 0.0,
          outlet_id == 3 ? 1.0 : 0.0,
          outlet_id == 4 ? 1.0 : 0.0,
          outlet_id == 5 ? 1.0 : 0.0,
          outlet_id == 6 ? 1.0 : 0.0,
          outlet_id == 7 ? 1.0 : 0.0,
          outlet_id == 8 ? 1.0 : 0.0,
          outlet_id == 9 ? 1.0 : 0.0,
          item_category == 0 ? 1.0 : 0.0,
          item_category == 1 ? 1.0 : 0.0,
          item_category == 2 ? 1.0 : 0.0
        ]
      ];

      


      //Get output
      var output = List.filled(1, 0).reshape([1, 1]);
      interpreter.run(input, output);

      

      // Get result
      var tempResult = output[0][0];

      //if improved
      if (tempResult > resultToOptimise) {

        resultToOptimise = tempResult;

        if (amountChanged > 0) amountChanged += changeInterval;
        else amountChanged -= changeInterval;

        if (outlet_size.toDouble() + amountChanged < 0 || outlet_size.toDouble() + amountChanged > 2){
          break;
        }
      }
      // if decrease in performance 
      else {
        if (i == 0){ // on the first try
          amountChanged *= -1; // switch direction
        }
        else { 
          break;
        }
      }
      
    }

    return ("Recommendation 3:\nIt is recommended to change the Outlet Size from "
    + outletSizeCol[outlet_size] + " to " 
    + outletSizeCol[(outlet_size + amountChanged.toInt())].toString() 
    + ". Sales are predicted to increase to \$ " + exp(resultToOptimise).toStringAsFixed(3) 
    + ".\n\n");
  }














  //Smart Justification Feature
  List<String> itemIdCol = [];
  List<double> itemWeightCol = [];
  List<String> itemFatContentCol = [];
  List<double> itemVisibilityCol = [];
  List<String> itemTypeCol = [];
  List<double> itemMRPCol = [];
  List<String> outletIdCol = [];
  List<int> outletEstablishmentYearCol = [];
  List<String> outletSizeCol = [];
  List<String> outletLocationTypeCol = [];
  List<String> outletTypeCol = [];
  List<double> itemOutletSalesCol = [];
  List<String> itemCategoryCol = [];
  List<int> outletYearsCol = [];

  List<String> tempOutletIds = [];

  List<String> itemTypes = [];
  List<String> itemCategories = [];
  List<String> itemFatValues = [];

  Map<String, List<double>> aveSalesForItemCategoryMap = new Map<String, List<double>>();
  Map<String, List<double>> aveSalesForItemTypeMap = new Map<String, List<double>>();
  Map<String, List<double>> aveSalesForItemFatContentMap = new Map<String, List<double>>();
  
  

  setupData() async {
    final data = await  rootBundle.loadString('assets/Cleaned_Retail_Sales_Dataset.csv');
    List<List<dynamic>> csvData = const CsvToListConverter().convert(data);

    
    int index = 0;
    for(int i = 14; i < csvData[0].length; i++){

      if (index == 1) itemIdCol.add(csvData[0][i]);
      if(index == 2) itemWeightCol.add(
        csvData[0][i] is int 
          ? csvData[0][i].toDouble()
          : csvData[0][i]);
      if(index == 3) itemFatContentCol.add(csvData[0][i]);
      if(index == 4) itemVisibilityCol.add(csvData[0][i] is int 
          ? csvData[0][i].toDouble()
          : csvData[0][i]);
      if(index == 5) itemTypeCol.add(csvData[0][i]);
      if(index == 6) itemMRPCol.add(csvData[0][i] is int 
          ? csvData[0][i].toDouble()
          : csvData[0][i]);
      if(index == 7) outletIdCol.add(csvData[0][i]);
      if(index == 8) outletEstablishmentYearCol.add(csvData[0][i] is double 
          ? csvData[0][i].toInt()
          : csvData[0][i]);
      if(index == 9) outletSizeCol.add(csvData[0][i]);
      if(index == 10) outletLocationTypeCol.add(csvData[0][i]);
      if(index == 11) outletTypeCol.add(csvData[0][i]);
      if(index == 12) itemOutletSalesCol.add(csvData[0][i] is int 
          ? csvData[0][i].toDouble()
          : csvData[0][i]);
      if(index == 13) itemCategoryCol.add(csvData[0][i]);
      if(index == 14) outletYearsCol.add(csvData[0][i] is String 
          ? 0 
          : csvData[0][i] is double 
          ? csvData[0][i].toInt()
          : csvData[0][i]);
      
      index += 1;
      if (index > 14){
        index = 1;
      }
    }

    tempOutletIds = outletIdCol.toSet().toList();
    tempOutletIds.sort();

    itemTypes = itemTypeCol.toSet().toList();
    itemTypes.sort();

    itemCategories = itemCategoryCol.toSet().toList();
    itemCategories.sort();

    itemFatValues= itemFatContentCol.toSet().toList();
    itemFatValues.sort();


    print(tempOutletIds);
    print(itemTypes);
    print(itemCategories);
    print(itemFatValues);

    //Total sales by item type
    List<double> salesByItemTypes = [];
    //For average sales by item type
    List<double> itemTypeCounts = [];
    List<double> aveSalesByItemTypes = [];
    //Total sales by item category
    List<double> salesByItemCategory = [];
    //For average sales by item category
    List<double> itemCategoryCounts = [];
    List<double> aveSalesByItemCategory = [];
    //Total sales by item Fat content
    List<double> salesByItemFat = [];
    //For average sales by item category
    List<double> itemFatCounts = [];
    List<double> aveSalesByItemFat= [];

    for(var _outletId in tempOutletIds){
      salesByItemTypes = [];
      itemTypeCounts = []; aveSalesByItemTypes = [];

      salesByItemCategory = [];
      itemCategoryCounts = []; aveSalesByItemCategory = [];

      salesByItemFat = [];
      itemFatCounts = []; aveSalesByItemFat= [];
      for(var _ in itemTypes)  {
        salesByItemTypes.add(0);
        itemTypeCounts.add(0);
        aveSalesByItemTypes.add(0);
        
      }
      for(var _ in itemCategories)  {
        salesByItemCategory.add(0);
        itemCategoryCounts.add(0);
        aveSalesByItemCategory.add(0);
      }
      for(var _ in itemFatValues)  {
        salesByItemFat.add(0);
        itemFatCounts.add(0);
        aveSalesByItemFat.add(0);
      }

      for (int i = 0 ; i < itemTypeCol.length; i ++){
        // item types
        for (int x = 0 ; x < itemTypes.length; x ++){
          if (outletIdCol[i] == _outletId){
            if (itemTypeCol[i] == itemTypes[x]){
              salesByItemTypes[x] += itemOutletSalesCol[i]; // add up the total sales for the item
              itemTypeCounts[x] += 1; // store the frequency 
            }
          }
        }
        //item categories
        for (int x = 0 ; x < itemCategories.length; x ++){
          if (outletIdCol[i] == _outletId){
            if (itemCategoryCol[i] == itemCategories[x]){
              salesByItemCategory[x] += itemOutletSalesCol[i]; // add up the total sales for the item
              itemCategoryCounts[x] += 1; // store the frequency 
            }
          }
        }
        //Item Fat Content
        for (int x = 0 ; x < itemFatValues.length; x ++){
          if (outletIdCol[i] == _outletId){
            if (itemFatContentCol[i] == itemFatValues[x]){
              salesByItemFat[x] += itemOutletSalesCol[i]; // add up the total sales for the item
              itemFatCounts[x] += 1; // store the frequency 
            }
          }
        }
      }


      // calculate average
      for (int i = 0; i < itemTypeCounts.length; i ++){
        aveSalesByItemTypes[i] = salesByItemTypes[i] / itemTypeCounts[i];
      }

      // calculate average
      for (int i = 0; i < itemCategoryCounts.length; i ++){
        aveSalesByItemCategory[i] = salesByItemCategory[i] / itemCategoryCounts[i];
      }

      for (int i = 0; i < itemFatCounts.length; i ++){
        aveSalesByItemFat[i] = salesByItemFat[i] / itemFatCounts[i];
      }

      aveSalesForItemCategoryMap[_outletId] = aveSalesByItemCategory;
      aveSalesForItemTypeMap[_outletId] = aveSalesByItemTypes;
      aveSalesForItemFatContentMap[_outletId] = aveSalesByItemFat;

      
    }

    
  }

  checkRanking(Map<String, List<double>>mapp, String outletName, int index, String colName, String colValue, String otherValue){
    //see if it is the highest
    int passedCount =0;
    for(var item in mapp[outletName]){
      if (mapp[outletName][index] > item) {
        passedCount ++;
      }
    }
    
    String rank = "";
    String extraText = "";
    if (passedCount >= (mapp[outletName].length - 1)){
      rank = "highest";
      extraText = "This may have a positive impact on the predicted sales.";
    } else if (mapp[outletName].length > 5 && passedCount >= (mapp[outletName].length - 2)){
      rank = ("second highest");
      extraText = "This may have a positive impact on the predicted sales.";
    } else if (mapp[outletName].length > 5 && passedCount >= (mapp[outletName].length - 3)){
      rank = ("third highest");
      extraText = "This may have a positive impact on the predicted sales.";
    } else if (passedCount == 0){
      rank = ("lowest");
      extraText = "This may have a negative impact on the predicted sales.";
    } else if (mapp[outletName].length > 5 && passedCount == 1){
      rank = ("second lowest");
      extraText = "This may have a negative impact on the predicted sales.";
    } else if (mapp[outletName].length > 5 && passedCount == 2){
      rank = ("third lowest");
      extraText = "This may have a negative impact on the predicted sales.";
    }

    if (rank == "") return "";

    return ("Based on our analysis, on average, an item from this " + colName + "(" + colValue + ") made the " + rank + " sales compared to the other " + colName + ". " + extraText + "\n\n");
  }

  double overallAveMRP = 140.992782;
  List<double> outletAveMRP = [
    140.77759,
    141.42598,
    139.42111,
    141.67863,
    139.78708,
    139.80179,
    143.12248,
    140.95024,
    142.05738,
    140.29769
  ];
  double maxMRP = 266.888400;
  double minMRP = 31.290000;
  interpretMRP(int outletIndex){
    String text = "";
    
    double price = double.parse(item_MRP_text.text);
    if (price > maxMRP){
      text += "You have entered a price that is higher than max price range. This will have a positive impact on the predicted sales.\n";
    } else if (price < minMRP) {
      text += "You have entered a price that is higher than min price range. This will have a negative impact on the predicted sales.\n";
    } else if (price > outletAveMRP [outletIndex]) {
      text += "You have entered a price that is higher than average. This will have a positive impact on the predicted sales.\n";
    } else if (price < outletAveMRP [outletIndex]) {
      text += "You have entered a price that is lower than than average. This will have a negative impact on the predicted sales.\n";
    }

    return text;
  }

  Map<String, List<int>> outletAttributes = {
    "OUT010" : [0,2,0, 15], //outlet type, location type, size
    "OUT013" : [1,2,2, 26],
    "OUT017" : [1,1,0, 6],
    "OUT018" : [2,2,1, 4],
    "OUT019" : [0,0,0, 28],
    "OUT027" : [3,2,1, 28],
    "OUT035" : [1,1,0, 9],
    "OUT045" : [1,1,0, 11],
    "OUT046" : [1,0,0, 16],
    "OUT049" : [1,0,1, 14],
  };

  double overallAveSales = 2181.288913575032;
  List<double> outletAveSales = [
    339.35166,
    2298.99525,
    2340.67526,
    1995.4987,
    340.32972,
    3694.03856,
    2438.841866,
    2192.38479,
    2277.84427,
    2348.35463
  ];
  interpretPredictedSales(int outletIndex, double predicted){
    String text = "";
    
    if (predicted > outletAveSales [outletIndex]) {
      text += "The predicted sale is higher than average.\n";
    } else if (predicted < outletAveSales [outletIndex]) {
      text += "The predicted sale is lower than average. The average item sales for this outlet is \$ " + outletAveSales [outletIndex].toString() + ".\n";
    }

    return text;
  }

}