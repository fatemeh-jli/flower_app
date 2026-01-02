import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // هدایت به صفحه اصلی بعد از 3.5 ثانیه
    Timer(const Duration(milliseconds: 3500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // رنگ آبی پاستلی بسیار روشن و خنثی
      backgroundColor: const Color(0xFFF0F7FF), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // نام برند با طراحی مینیمال
            const Text(
              'DARLA',
              style: TextStyle(
                fontSize: 42,
                letterSpacing: 16,
                color: Color(0xFF2F4F4F), // دودی تیره
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 12),
            // شعار فارسی
            const Text(
              'روایتگرِ قلب‌ها',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF556B2F), // سبز زیتونی برند
                letterSpacing: 2,
                fontFamily: 'Vazir', // اگر فونت رو اضافه کردی
              ),
            ),
            const SizedBox(height: 80),
            // لودینگ بسیار ظریف خطی به جای دایره‌ای (شیک‌تر است)
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white.withOpacity(0.5),
                color: const Color(0xFF556B2F).withOpacity(0.3),
                minHeight: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}