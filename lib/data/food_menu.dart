import 'dart:convert';

class Food {
  String name;
  String ingredients;
  String group;

  Food({
    required this.name, 
    required this.ingredients, 
    required this.group,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      ingredients: json['ingredients'],
      group: json['group'],
    );
  }

  @override
  String toString() { 
    return name;
  }
}

class FoodMenu {
  int id;
  String date;
  Map<String, List<Food>> breakFast;
  Map<String, List<Food>> lunch;
  Map<String, List<Food>> dinner;

  FoodMenu({
    required this.id, 
    required this.date, 
    required this.breakFast, 
    required this.lunch, 
    required this.dinner
  });

  static Map<String, FoodMenu> transformData(List<dynamic> data) {  
    data = data[0]['items'];
    Map<String, FoodMenu> foodMenu = {};
    for (int i = 0; i < data.length; i++) {
      foodMenu[data[i]['date']] = FoodMenu.fromJson(data[i]);
    }
    return foodMenu;
  }

  factory FoodMenu.fromJson(Map<String, dynamic> json) {
    return FoodMenu(
      id: json['id'],
      date: json['date'],
      breakFast: _parseFood(json['breakfast']),
      lunch: _parseFood(json['lunch']),
      dinner: _parseFood(json['dinner']),
    );
  }

  static Map<String, List<Food>> _parseFood(dynamic data) {
    if (data is String) {
      data = jsonDecode(data);
    }
    Map<String, List<Food>> menu = {};
    for (var food in data) {
      menu[food['group']] = [];
    }
    for (var food in data) {
      menu[food['group']]!.add(Food.fromJson(food));
    }
    return menu;
  }

  @override
  String toString() { 
    return 'FoodMenu(id: $id, date: $date, breakFast: $breakFast, lunch: $lunch, dinner: $dinner)';
  }
}
