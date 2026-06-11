import 'dart:convert';

class ProductModel {
  final String name;
  final String description;
  final int price;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
  });
//object to map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

// map dari json ke object
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
    );
  }
//object to json string
  String toJson() => json.encode(toMap());
//json string to object
  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

}