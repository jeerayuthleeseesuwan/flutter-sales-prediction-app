import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:prediciton_model/models/mart_constants.dart';

class DashboardController extends ControllerMVC {
  DashboardController();

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


  // Bar chart 1
  List<String> outletIds = [];
  List<double> salesByOutlet = [];
  int touchedIndex = -1;

  List<Color> outTypeColors = OUTLET_TYPE_COLORS;
  List<String> outSizeLbl = OUTLET_SIZE_TYPE;
  List<String> outTierLbl = OUTLET_TIER_TYPE;
  List<String> outYearsLbl = OUTLET_YEARS;

  loadData({@required VoidCallback onRefresh}) async {

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

    // For bar chart 1
    outletIds = outletIdCol.toSet().toList();
    outletIds.sort();

    salesByOutlet = [];
    for(var _ in outletIds)  salesByOutlet.add(0);

    for (int i = 0 ; i < outletIdCol.length; i ++){
      for (int id = 0 ; id < outletIds.length; id ++){
        if (outletIdCol[i] == outletIds[id]){
          salesByOutlet[id] += itemOutletSalesCol[i];
        }
      }
    }
    onRefresh();
  }



  ///Bar Chart 2
  
  List<String> itemTypes = [];
  List<String> itemCategories = [];
  List<String> itemFatValues = [];

  //Total sales by item type
  List<double> salesByItemTypes = [];

  //For average sales by item type
  List<double> itemTypeCounts = [];
  List<double> aveSalesByItemTypes = [];

  //For MRP
  List<double> totalMRPByItemTypes = [];
  List<double> aveMRPByItemTypes = [];

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

  int touchedIndex2 = -1;
  int numOfZero2 = 0;
  List<Color> barColors = BAR_COLORS;
  bool showAverage = false;

  calculateTotalsAndMeans(){
    itemTypes = itemTypeCol.toSet().toList();
    itemTypes.sort();

    itemCategories = itemCategoryCol.toSet().toList();
    itemCategories.sort();

    itemFatValues= itemFatContentCol.toSet().toList();
    itemFatValues.sort();

    salesByItemTypes = [];
    itemTypeCounts = [];
    aveSalesByItemTypes = [];

    totalMRPByItemTypes = [];
    aveMRPByItemTypes = [];

    salesByItemCategory= [];
    itemCategoryCounts= [];
    aveSalesByItemCategory = [];

    salesByItemFat = [];
    itemFatCounts= [];
    aveSalesByItemFat = [];
    
    for(var _ in itemTypes)  {
      salesByItemTypes.add(0);
      itemTypeCounts.add(0);
      aveSalesByItemTypes.add(0);
      totalMRPByItemTypes.add(0);
      aveMRPByItemTypes.add(0);
      
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
        if (touchedIndex == -1 || 
            touchedIndex != -1 && outletIdCol[i] == outletIds[touchedIndex]){
          if (itemTypeCol[i] == itemTypes[x]){
            salesByItemTypes[x] += itemOutletSalesCol[i]; // add up the total sales for the item
            itemTypeCounts[x] += 1; // store the frequency 
            totalMRPByItemTypes[x] += itemMRPCol[i]; // add up the MRP
          }
        }
      }
      //item categories
      for (int x = 0 ; x < itemCategories.length; x ++){
        if (touchedIndex == -1 || 
            touchedIndex != -1 && outletIdCol[i] == outletIds[touchedIndex]){
          if (itemCategoryCol[i] == itemCategories[x]){
            salesByItemCategory[x] += itemOutletSalesCol[i]; // add up the total sales for the item
            itemCategoryCounts[x] += 1; // store the frequency 
          }
        }
      }
      //Item Fat Content
      for (int x = 0 ; x < itemFatValues.length; x ++){
        if (touchedIndex == -1 || 
            touchedIndex != -1 && outletIdCol[i] == outletIds[touchedIndex]){
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
      aveMRPByItemTypes[i] = totalMRPByItemTypes[i] / itemTypeCounts[i];
    }

    // calculate average
    for (int i = 0; i < itemCategoryCounts.length; i ++){
      aveSalesByItemCategory[i] = salesByItemCategory[i] / itemCategoryCounts[i];
    }

    for (int i = 0; i < itemFatCounts.length; i ++){
      aveSalesByItemFat[i] = salesByItemFat[i] / itemFatCounts[i];
    }
    print(aveSalesByItemCategory);
  }


  //For bar chart 3
  int numOfZero3 = 0;

  int numOfZero4 = 0;
  int touchedIndex4 = 0;

  int numOfZero5 = 0;
  int touchedIndex5 = 0;

  int numOfZeroForLine = 0;
  double lowerLimit = 0;

  int numOfZeroForLine2 = 0;
  int numOfZeroForLine3 = 0;
}