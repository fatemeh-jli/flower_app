import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../models/cart_model.dart';
import 'profile_screen.dart';
import 'flower_detail_screen.dart'; 
import 'checkout_screen.dart';
import '../data/flower_data.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Map<String, dynamic>> filteredFlowers = [];
  String searchQuery = "";
  RangeValues priceRange = const RangeValues(0, 1000000); // بازه قیمت را بزرگتر کردم

  @override
  void initState() {
    super.initState();
    filteredFlowers = allFlowers;
  }

  // نمایش سبد خرید یکپارچه متصل به Provider
  void _showCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Consumer<CartModel>(
          builder: (context, cart, child) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  const Text("سبد خرید شما", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2F4F4F))),
                  const Divider(),
                  if (cart.items.isEmpty)
                    const Expanded(child: Center(child: Text("سبد خرید فعلاً خالی است")))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(item['img'], width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            title: Text(item['name']),
                            subtitle: Text("${item['price']} T"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => cart.removeItem(index),
                            ),
                          );
                        },
                      ),
                    ),
                  if (cart.items.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF556B2F),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(totalAmount: cart.totalPrice),
                            ),
                          );
                        },
                        child: Text("تکمیل خرید: ${cart.totalPrice} T", 
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    setState(() {
      filteredFlowers = allFlowers.where((flower) {
        final nameMatches = flower['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
        // تبدیل قیمت به عدد برای فیلتر صحیح
        int price = int.parse(flower['price'].toString().replaceAll(',', ''));
        final priceMatches = price >= priceRange.start && price <= priceRange.end;
        return nameMatches && priceMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        
        // هدر با نشانگر Badge هوشمند
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Color(0xFF2F4F4F)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                  ),
                  // بخش نشانگر تعداد محصولات در سبد خرید
                  Consumer<CartModel>(
                    builder: (context, cart, child) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF2F4F4F)),
                            onPressed: _showCartSheet,
                          ),
                          if (cart.cartCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Text("${cart.cartCount}", 
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                ],
              ),
              const Text('دارلا', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F4F4F))),
            ],
          ),
        ),

        // نوار جستجو
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            children: [
              _buildFilterButton(),
              const SizedBox(width: 10),
              _buildSearchBar(),
            ],
          ),
        ),
        
        Expanded(
          child: filteredFlowers.isEmpty 
          ? const Center(child: Text("گلی با این مشخصات پیدا نشد!", style: TextStyle(color: Colors.grey)))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                childAspectRatio: 0.75,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: filteredFlowers.length,
              itemBuilder: (context, index) => _buildMiniFlowerCard(filteredFlowers[index]),
            ),
        ),
      ],
    );
  }

  Widget _buildMiniFlowerCard(Map<String, dynamic> flower) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlowerDetailScreen(flower: flower)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: flower['name']!,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(flower['img']!, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(flower['name']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text("${flower['price']} T", 
                    style: const TextStyle(fontSize: 12, color: Color(0xFF556B2F), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Expanded(
      child: Container(
        height: 45,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextField(
          textAlign: TextAlign.right,
          onChanged: (value) {
            searchQuery = value;
            _applyFilters();
          },
          decoration: const InputDecoration(
            hintText: 'جستجوی نام گل...',
            prefixIcon: Icon(Icons.search, size: 18),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: _showPriceFilterDialog,
      child: Container(
        height: 45, width: 45,
        decoration: BoxDecoration(color: const Color(0xFF556B2F), borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.tune, color: Colors.white, size: 20),
      ),
    );
  }

  void _showPriceFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("فیلتر قیمت", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              RangeSlider(
                values: priceRange,
                min: 0, max: 1000000,
                divisions: 20,
                activeColor: const Color(0xFF556B2F),
                labels: RangeLabels("${priceRange.start.round()}", "${priceRange.end.round()}"),
                onChanged: (values) {
                  setModalState(() => priceRange = values);
                  _applyFilters();
                },
              ),
              Text("از ${priceRange.start.round()} تا ${priceRange.end.round()} تومان"),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}