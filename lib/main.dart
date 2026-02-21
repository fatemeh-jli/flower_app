import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      
      //  راست‌چین   ندارم
      
      theme: ThemeData(
        fontFamily: 'Vazir', 
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}