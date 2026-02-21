import 'package:flutter/material.dart';
import '../models/flower.dart';

class FlowerCard extends StatelessWidget {
  final Flower flower;

  const FlowerCard({super.key, required this.flower});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // بخش تصویر (فعلاً اموجی تا عکس‌ها را اضافه کنی)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8E1E7).withOpacity(0.4), // تم پاستلی عکس اول
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Center(child: Text(flower.emoji, style: const TextStyle(fontSize: 50))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(flower.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('${flower.price} تومان', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                // دکمه انتخاب مشابه عکس دوم
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5D1B8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('انتخاب گل', style: TextStyle(color: Color(0xFF8B5E3C), fontSize: 10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}