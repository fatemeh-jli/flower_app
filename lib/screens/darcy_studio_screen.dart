import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class PlacedFlower {
  final String imagePath;
  Offset position;
  double rotation;
  double scale;
  final int price;

  PlacedFlower({
    required this.imagePath,
    required this.position,
    this.rotation = 0.0,
    this.scale = 1.0,
    required this.price,
  });
}

class DarcyStudioScreen extends StatefulWidget {
  const DarcyStudioScreen({super.key});
  @override
  State<DarcyStudioScreen> createState() => _DarcyStudioScreenState();
}

class _DarcyStudioScreenState extends State<DarcyStudioScreen> {
  List<PlacedFlower> placedFlowers = [];
  String selectedPackage = 'simple';
  String cardContent = "";
  Color selectedCardColor = const Color(0xFFE3F2FD);
  final f = NumberFormat("#,###");

  final Map<String, int> flowerPrices = {
    'peony.png': 150000,
    'lilium.png': 120000,
    'sunflower.png': 85000,
    'red_rose.png': 95000,
    'gypsophila.png': 40000,
    'eucalyptus.png': 35000,
  };

  final Map<String, int> packagePrices = {'simple': 0, 'box': 130000, 'paper': 50000};

  int get totalPrice =>
      placedFlowers.fold(0, (sum, item) => sum + item.price) +
      (packagePrices[selectedPackage] ?? 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildCanvas()),
            _buildActionButtons(),
            _buildFlowerTray(),
            _buildDoneButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("مجموع", style: TextStyle(letterSpacing: 2, fontSize: 10, color: Color(0xFF546E7A))),
              Text("${f.format(totalPrice)} تومان", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, color: Color(0xFF455A64)),
            onPressed: _showInvoice, // دکمه جدید برای دیدن جزئیات قیمت
          ),
          const Text("استودیو دارسی", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return Center(
      child: DragTarget<String>(
        onAcceptWithDetails: (details) {
          setState(() {
            String path = details.data;
            String fileName = path.split('/').last;
            placedFlowers.add(PlacedFlower(
              imagePath: path,
              position: const Offset(100, 100),
              price: flowerPrices[fileName] ?? 50000,
            ));
          });
        },
        builder: (context, _, __) => Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 450,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Stack(
            children: [
              if (placedFlowers.isEmpty)
                const Center(child: Opacity(opacity: 0.1, child: Icon(Icons.eco, size: 80))),
              ...placedFlowers.map((flower) => Positioned(
                    left: flower.position.dx,
                    top: flower.position.dy,
                    child: GestureDetector(
                      onScaleUpdate: (details) {
                        setState(() {
                          if (details.pointerCount == 1) {
                            flower.position += details.focalPointDelta;
                          } else {
                            flower.rotation = details.rotation;
                            flower.scale = details.scale.clamp(0.5, 2.5);
                          }
                        });
                      },
                      child: Transform.rotate(
                        angle: flower.rotation,
                        child: Transform.scale(
                          scale: flower.scale,
                          child: Image.asset(flower.imagePath, width: 150),
                        ),
                      ),
                    ),
                  )),
              if (cardContent.isNotEmpty) _buildCardOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardOverlay() {
    return Positioned(
      bottom: 25,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 180),
        decoration: BoxDecoration(
          color: selectedCardColor,
          borderRadius: BorderRadius.circular(15),
          // اصلاح شده: استفاده از withValues برای جلوگیری از خطای Deprecation
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 3))],
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          cardContent,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF455A64)),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _toolBtn(Icons.edit_note, _showCardEditor),
          const SizedBox(width: 25),
          _toolBtn(Icons.shopping_bag_outlined, _showPackagePicker),
          const SizedBox(width: 25),
          _toolBtn(Icons.undo_rounded, () {
            if (placedFlowers.isNotEmpty) setState(() => placedFlowers.removeLast());
          }),
          const SizedBox(width: 25),
          _toolBtn(Icons.delete_outline, () => setState(() {
                placedFlowers.clear();
                cardContent = "";
              })),
        ],
      ),
    );
  }

  Widget _toolBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
          child: Icon(icon, size: 24, color: const Color(0xFF455A64)),
        ),
      );

  // متد جدید برای نمایش پیش‌فاکتور
  void _showInvoice() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("جزئیات قیمت", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            ...placedFlowers.map((fItem) => ListTile(
              leading: Image.asset(fItem.imagePath, width: 30),
              title: const Text("گل انتخابی"),
              trailing: Text("${f.format(fItem.price)} T"),
            )),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text("بسته‌بندی ($selectedPackage)"),
              trailing: Text("${f.format(packagePrices[selectedPackage] ?? 0)} T"),
            ),
            const Divider(),
            Text("جمع کل: ${f.format(totalPrice)} تومان", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  void _showCardEditor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFE3F2FD),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("براش بنویس", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: "...", border: InputBorder.none),
              onChanged: (v) => setState(() => cardContent = v),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showPackagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFE3F2FD),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          _pkgTile("ساده", 'simple'),
          _pkgTile("کاغذ کادو", 'paper'),
          _pkgTile("باکس", 'box'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _pkgTile(String title, String key) {
    return ListTile(
      title: Text(title, textAlign: TextAlign.center),
      trailing: Text("${f.format(packagePrices[key])} T"),
      onTap: () {
        setState(() => selectedPackage = key);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildFlowerTray() {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: flowerPrices.keys
            .map((img) => Draggable<String>(
                  data: 'assets/images/$img',
                  feedback: Image.asset('assets/images/$img', width: 80, opacity: const AlwaysStoppedAnimation(.5)),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    // اصلاح شده: withValues
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(15)),
                    child: Image.asset('assets/images/$img', width: 55),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDoneButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF263238),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          if (placedFlowers.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("لطفاً ابتدا چند گل اضافه کنید")),
            );
            return;
          }

          final customBouquet = {
            "name": "دسته گل اختصاصی استودیو",
            "price": f.format(totalPrice),
            "img": "assets/images/darcy.jpg", 
            "isCustom": true 
          };

          Provider.of<CartModel>(context, listen: false).addToCart(customBouquet);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("💐 طراحی شما با موفقیت به سبد خرید اضافه شد", textAlign: TextAlign.right),
              backgroundColor: Color(0xFF455A64),
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          setState(() {
            placedFlowers.clear();
            cardContent = "";
          });
        },
        child: const Text("ثبت در سبد خرید", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}