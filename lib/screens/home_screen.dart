import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../models/cart_model.dart'; // مسیر مدل را چک کن
import 'shop_screen.dart'; 
import 'darcy_studio_screen.dart';
import 'profile_screen.dart'; 
import 'checkout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSliderTimer();
  }

  void _startSliderTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // نمایش سبد خرید به صورت شیت پایین صفحه کاملاً متصل به Provider
  void _showCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        // استفاده از Consumer برای آپدیت لحظه‌ای سبد خرید
        return Consumer<CartModel>(
          builder: (context, cart, child) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  const Text("سبد خرید شما", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2F4F4F))),
                  const Divider(),
                  if (cart.items.isEmpty)
                    const Expanded(
                      child: Center(child: Text("سبد خرید فعلاً خالی است")),
                    )
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
                        child: Text("پرداخت نهایی: ${cart.totalPrice} T", 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF556B2F),
        unselectedItemColor: const Color(0xFFB0BEC5),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.blur_on_rounded), label: 'دارلا'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist_outlined), label: 'فروشگاه'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_mosaic_outlined), label: 'استودیو'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return _buildHomeContent(); 
      case 1: return const ShopScreen(); 
      case 2: return const DarcyStudioScreen(); 
      default: return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
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
                    // آیکون سبد خرید هوشمند با نشانگر تعداد
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
          
          // اسلایدر
          Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) => setState(() => _currentPage = page),
                children: [
                  Image.asset("assets/images/s1.jpg", fit: BoxFit.cover),
                  Image.asset("assets/images/s2.jpg", fit: BoxFit.cover),
                  Image.asset("assets/images/s3.jpg", fit: BoxFit.cover),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // محصولات (Grid)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _buildModernCard("هدیه‌ای اقتصادی", "120000", "assets/images/egh.jpg"),
                _buildModernCard("باکس‌های مجلل", "450000", "assets/images/box.jpg"),
                _buildModernCard("تک شاخه‌های ممتاز", "85000", "assets/images/single.jpg"),
                _buildModernCard("شکوهِ میزبانی", "980000", "assets/images/wedding.jpg"),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildModernCard(String title, String price, String assetPath) {
    return GestureDetector(
      onTap: () {
        // استفاده از Provider برای اضافه کردن به سبد خرید سراسری
        Provider.of<CartModel>(context, listen: false).addToCart({
          "name": title,
          "price": price,
          "img": assetPath
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$title به سبد اضافه شد ✨", style: const TextStyle(fontFamily: 'Vazir')),
            backgroundColor: const Color(0xFF556B2F),
            duration: const Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(assetPath, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                left: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    Text("$price T", style: const TextStyle(fontSize: 11, color: Color(0xFFB3E5FC))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}