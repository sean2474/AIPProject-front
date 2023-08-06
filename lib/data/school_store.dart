import 'package:front/data/settings.dart';
import 'data.dart';

class StoreItem {
  int id;
  String name;
  ItemType itemType;
  String description;
  String imageUrl;
  double price;
  int stock;
  String dateAdded;

  StoreItem({
    required this.id, 
    required this.name, 
    required this.itemType, 
    required this.description, 
    required this.imageUrl, 
    required this.price, 
    required this.stock, 
    required this.dateAdded
  });

  static List<StoreItem> transformData(List<dynamic> data) {
    return data.map((json) => StoreItem.fromJson(json)).toList();
  }

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    if (json['Category'] > 4) {
      json['Category'] = 4;
    }
    return StoreItem(
      id: json['ID'],
      name: json['Product_Name'],
      itemType: json['Category'] == null ? ItemType.na : ItemType.values[json['Category']],
      description: json['Description'] ?? '',
      imageUrl: "${Settings.baseUrl}/data/school-store/image/${json['ID']}",
      price: json['Price'].toDouble(),
      stock: json['Stock'],
      dateAdded: json['Date_Added'],
    );
  }
}