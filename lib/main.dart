import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// خط مربوط به localizations حذف شد
import 'models/cart_model.dart'; 
import 'screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const DarlaApp(),
    ),
  );
}

class DarlaApp extends StatelessWidget {
  const DarlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Darla Flowers',
      
      // تنظیمات راست‌چین و زبان فارسی کاملاً حذف شد
      
      theme: ThemeData(
        fontFamily: 'Vazir', 
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}