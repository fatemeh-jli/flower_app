import 'package:flutter/material.dart';
import '../data/flower_data.dart';
import '../models/flower.dart';
import '../widgets/flower_item_button.dart';

class BouquetBuilderScreen extends StatefulWidget {
  const BouquetBuilderScreen({super.key});
  @override
  State<BouquetBuilderScreen> createState() => _BouquetBuilderScreenState();
}

class _BouquetBuilderScreenState extends State<BouquetBuilderScreen> {
  final List<Flower> selectedFlowers = [];
  int totalPrice = 0;

  void addFlower(Flower flower) {
    setState(() {
      selectedFlowers.add(flower);
      totalPrice += flower.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FLEURIS STUDIO ')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: selectedFlowers.isEmpty
                  ? const Center(child: Text('هنوز گلی اضافه نکردی '))
                  : Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 15,
                        runSpacing: 15,
                        children: selectedFlowers
                            .map((f) => Text(f.emoji, style: const TextStyle(fontSize: 50)))
                            .toList(),
                      ),
                    ),
            ),
          ),
          _buildFlowerPickerList(),
          _buildPriceFooter(),
        ],
      ),
    );
  }

  Widget _buildFlowerPickerList() {
    return Container(
      height: 160,
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: flowerList.length,
        itemBuilder: (context, index) {
          return FlowerItemButton(
            flower: flowerList[index],
            onAdd: addFlower,
          );
        },
      ),
    );
  }

  Widget _buildPriceFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('قیمت کل:', style: TextStyle(color: Colors.grey)),
              Text('$totalPrice تومان', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE5D1B8),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              if (selectedFlowers.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("اول چندتا گل انتخاب کن!")),
                );
                return;
              }

              // اینجا باید منطق ارسال لیست selectedFlowers به سبد خرید را بنویسی
              // context.read<CartProvider>().addSelection(selectedFlowers, totalPrice);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سفارش شما به سبد خرید اضافه شد! ')),
              );
            },
            child: const Text('ثبت سفارش', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}