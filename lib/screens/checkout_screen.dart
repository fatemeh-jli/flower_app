import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final String totalAmount;
  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // برای افکت لودینگ هنگام پرداخت

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), 
      appBar: AppBar(
        title: const Text("تکمیل و پرداخت", 
          style: TextStyle(color: Color(0xFF2D3436), fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // بستن کیبورد با لمس صفحه
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressBar(), // نوار وضعیت مرحله خرید
                const SizedBox(height: 25),
                
                _buildSectionHeader(Icons.person_pin_circle_rounded, "اطلاعات تحویل‌گیرنده"),
                _buildCard([
                  _buildTextField("نام و نام خانوادگی", Icons.person_outline, (v) => v!.length < 3 ? "نام معتبر نیست" : null),
                  _buildTextField("شماره تماس", Icons.phone_android, (v) => v!.length != 11 ? "شماره باید ۱۱ رقم باشد" : null, isNumber: true),
                ]),

                const SizedBox(height: 20),
                _buildSectionHeader(Icons.local_shipping_outlined, "آدرس و مکان تحویل"),
                _buildCard([
                  _buildTextField("استان و شهر", Icons.location_city, (v) => v!.isEmpty ? "اجباری" : null),
                  _buildTextField("آدرس پستی دقیق", Icons.map_outlined, (v) => v!.length < 10 ? "آدرس کوتاه است" : null, maxLines: 2),
                  _buildTextField("کد پستی (اختیاری)", Icons.post_add, (v) => null, isNumber: true),
                ]),

                const SizedBox(height: 25),
                _buildOrderSummaryCard(),
                
                const SizedBox(height: 30),
                _buildAnimatedPayButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- ویجت‌های کمکی برای زیبایی بیشتر ---

  Widget _buildProgressBar() {
    return Row(
      children: [
        _buildStep(true, "سبد خرید"),
        _buildLine(true),
        _buildStep(true, "آدرس"),
        _buildLine(false),
        _buildStep(false, "پرداخت"),
      ],
    );
  }

  Widget _buildStep(bool active, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: active ? Colors.blueAccent : Colors.grey[300],
          child: Icon(active ? Icons.check : Icons.circle, size: 12, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: active ? Colors.blue : Colors.grey)),
      ],
    );
  }

  Widget _buildLine(bool active) => Expanded(child: Divider(color: active ? Colors.blueAccent : Colors.grey[300], thickness: 2));

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF455A64))),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blueGrey.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(String hint, IconData icon, String? Function(String?)? validator, {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: validator,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blueGrey[300], size: 22),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blueAccent, width: 1)),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade800, Colors.blue.shade500]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("جمع کل پرداختی:", style: TextStyle(color: Colors.white, fontSize: 15)),
          Text("${widget.totalAmount} تومان", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildAnimatedPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D3436),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 5,
        ),
        onPressed: _isLoading ? null : _handlePayment,
        child: _isLoading 
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text("اتصال به درگاه بانکی", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _handlePayment() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // شبیه‌سازی اتصال به درگاه
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        _showSuccessSheet();
      });
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 90),
            const SizedBox(height: 15),
            const Text("پرداخت موفقیت‌آمیز بود", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("سفارش شما ثبت شد و به زودی ارسال می‌شود.", textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("بازگشت به فروشگاه"),
            )
          ],
        ),
      ),
    );
  }
}