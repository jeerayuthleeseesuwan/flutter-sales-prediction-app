import 'dart:ui';
const List<Color> OUTLET_TYPE_COLORS = const [
  Color(0xFF77c1b2),
  Color(0xFFf9de8d),
  Color(0xFFf9de8d),
  Color(0xFFf29677),
  Color(0xFF77c1b2),
  Color(0xFF6f9fcf),
  Color(0xFFf9de8d),
  Color(0xFFf9de8d),
  Color(0xFFf9de8d),
  Color(0xFFf9de8d),
];

const List<String> OUTLET_SIZE_TYPE = const[
  "S",
  "L",
  "S",
  "M",
  "S",
  "M",
  "S",
  "S",
  "S",
  "M",
];

const List<String> OUTLET_TIER_TYPE = const[
  "Tier 3",
  "Tier 3",
  "Tier 2",
  "Tier 3",
  "Tier 1",
  "Tier 3",
  "Tier 2",
  "Tier 2",
  "Tier 1",
  "Tier 1",
];
const List<String> OUTLET_YEARS = const[
  "15",
  "26",
  "6",
  "4",
  "28",
  "28",
  "9",
  "11",
  "16",
  "14",
];

const List<Color> BAR_COLORS = const[
  Color(0xFF77c1b2), 
  Color(0xFFf29677), 
  Color(0xFF6f9fcf), 
  Color(0xFFf9de8d), 
  Color(0xFFe7c9c9), 
  Color(0xFFf094a8), 
  Color(0xFFcfd274),
  Color(0xFFc6aed0), 
  Color(0xFFc09d77),  
  
  Color(0xFFad9188), 
  Color(0xFFe9dac4), 
  Color(0xFFb8a793), 
  Color(0xFF94ae88), 
  Color(0xFFbabebf), 
  Color(0xFF7e8291),
  Color(0xFF626367), 
  Color(0xFF2f3843),
  Color(0xFFD24174), 
  Color(0xFFEC897D), 
  Color(0xFFB25f37), 
  Color(0xFFfaa75a), 
  Color(0xFFefde5b), 
  Color(0xFF98d1a9), 
  Color(0xFF0fa97a), 
  Color(0xFF8fb1cc), 
  Color(0xFF0879b9), 
  Color(0xFF8b6cab), 
  Color(0xFF2f3843), 
  Color(0xFF8a8e91), 
  Color(0xFFd9ae83), 
  Color(0xFFe9dac4), 
  Color(0xFFe9dac4), 
  Color(0xFFe9dac4), 
  Color(0xFFe9dac4), 
];


const List<String> item_categories_string = ["Drinks", "Food", "Non-Consumable Items"];
const List<String> item_types = ["Baking Goods", "Breads", "Breakfast", "Canned", "Diary", 
"Frozen Foods", "Fruits and Vegetables", "Hard Drinks", "Health and Hygiene", "Household", 
"Meat", "Others", "Seafood", "Snack Foods", "Soft Drinks", "Starchy Foods"];
const List<String> outlet_ids = ["OUT010", "OUT013", "OUT017", "OUT018", "OUT019", "OUT027", "OUT035", "OUT045", "OUT046", "OUT049"];
const List<String> outlet_types = ["Grocery Store", "Supermarket Type 1", "Supermarket Type 2", "Supermarket Type 3"];

// for normalisation
const double std_item_weight = 4.226124; 
const double mean_item_weight = 12.857645; 
const double std_item_visibility = 0.051598;
const double mean_item_visibility = 0.066132;
const double std_item_MRP = 62.275067;
const double mean_item_MRP = 140.992782;
const double std_outlet_years = 8.371760;
const double mean_outlet_years = 15.168133;