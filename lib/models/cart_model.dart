import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String price;
  final String image;

  CartItem({
    required this.name, 
    required this.price, 
    required this.image
  });
}

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addToCart(Map<String, dynamic> flower) {
    _items.add({
      'name': flower['name'],
      'price': flower['price'],
      'img': flower['img'], 
    });
    
    notifyListeners(); 
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get cartCount => _items.length;

  String get totalPrice {
    double total = 0;
    for (var item in _items) {
      String priceStr = item['price'].toString().replaceAll(RegExp(r'[^0-9]'), '');
      total += double.tryParse(priceStr) ?? 0;
    }
    return total.toStringAsFixed(0);
  }
}