import 'package:flutter/material.dart';

// کلاس کمکی برای ساختار آیتم‌ها (اختیاری اما برای نظم بهتره)
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
  // لیست اصلی گل‌ها به صورت Map برای هماهنگی با دیتای صفحات قبلی
  final List<Map<String, dynamic>> _items = [];

  // getter برای دسترسی به لیست آیتم‌ها در صفحات شاپ و هوم
  List<Map<String, dynamic>> get items => _items;

  // متد اصلی برای اضافه کردن گل به سبد (از استودیو دارسی یا هر جای دیگه)
  void addToCart(Map<String, dynamic> flower) {
    // ایجاد یک کپی از اطلاعات برای جلوگیری از تداخل دیتا
    _items.add({
      'name': flower['name'],
      'price': flower['price'],
      'img': flower['img'], // یا 'image' بسته به کلید پروژه‌ات
    });
    
    // حیاتی‌ترین خط برای ثبت و نمایش لحظه‌ای تغییرات
    notifyListeners(); 
  }

  // متد برای حذف یک آیتم خاص از سبد
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // متد برای پاک کردن کل سبد خرید
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // دریافت تعداد کل سفارشات ثبت شده
  int get cartCount => _items.length;

  // محاسبه مجموع قیمت (اگر قیمت‌ها عددی باشن)
  String get totalPrice {
    double total = 0;
    for (var item in _items) {
      // حذف کاراکترهای اضافه مثل T یا تومان برای محاسبه عددی
      String priceStr = item['price'].toString().replaceAll(RegExp(r'[^0-9]'), '');
      total += double.tryParse(priceStr) ?? 0;
    }
    return total.toStringAsFixed(0);
  }
}