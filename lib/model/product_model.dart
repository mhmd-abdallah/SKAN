// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_declarations, prefer_const_constructors_in_immutables
import 'dart:convert';

import 'package:equatable/equatable.dart';

final String tableProducts = 'products';
final String additionalData = 'additionalData';

class ProductFields {
  //Values in the database table
  static final List<String> values = [...showedTableValues, deleted];

  //Values in the data table of the app
  static final List<String> showedTableValues = [
    id,
    name,
    barcode,
    quantity,
  ];

  static final String id = 'ID';
  static final String name = 'Name';
  static final String barcode = 'Barcode';
  static final String quantity = 'Quantity';
  static final String deleted = 'Deleted';
  static final String category = 'Category';
  static final String brand = 'Brand';
}

class Product extends Equatable {
  final int id;
  final String name;
  final String barcode;
  final String quantity;
  // final String? category;
  // final String? brand;
  final bool deleted; // Check if the product is deleted or not
  // final double? regularPrice;
  // final double? purchasePrice;
  // final String? description;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.quantity,
    required this.deleted,
    // this.brand,
    // this.category,
    // this.regularPrice,
    // this.purchasePrice,
    // this.description,
  });

  Product copyWith({
    int? id,
    String? name,
    String? barcode,
    String? quantity,
    String? brand,
    String? category,
    bool? deleted,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      quantity: quantity ?? this.quantity,
      // brand: brand ?? this.brand,
      // category: category ?? this.category,
      deleted: deleted ?? this.deleted,
    );
  }

  //From product to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ProductFields.id: id,
      ProductFields.name: name,
      ProductFields.barcode: barcode,
      ProductFields.quantity: quantity,
      ProductFields.deleted: deleted ? 1 : 0,
    };
  }

  // From map to a product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      barcode: map['barcode'] as String,
      quantity: map['quantity'] as String,
      // category: map['category'] as String,
      // brand: map['brand'] as String,
      deleted: map['deleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  static Product fromJson(Map<String, Object?> json) => Product(
        id: json[ProductFields.id] as int,
        name: json[ProductFields.name] as String,
        barcode: json[ProductFields.barcode].toString(),
        quantity: json[ProductFields.quantity].toString(),
        deleted: json[ProductFields.deleted] == 0 ? false : true,
      );

  @override
  bool get stringify => true;

  @override
  // List<Object> get props => [id, name, barcode, quantity];
  List<Object> get props => [id, name, barcode, quantity, deleted];
}
