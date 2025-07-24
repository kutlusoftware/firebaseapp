import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final int id;
  final String name;
  final int price;
  final int count;

  //eğer üründen hiç yoksa yeni ekleniyorsa
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.count,
  });

  // Yeni ürün nesnesi oluşturulur diğer herşey  aynıdır. sadece adet değiştilir.
  Product copy({int? count}) {
    return Product(
      id: id,
      name: name,
      price: price,
      count: count ?? this.count,
    );
  }
}
