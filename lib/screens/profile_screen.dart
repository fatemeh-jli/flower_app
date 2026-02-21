import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // کتابخانه جدید

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // به محض باز شدن صفحه، اطلاعات قبلی را بخوان
  }

  // متد خواندن اطلاعات از حافظه گوشی
  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? "";
      _phoneController.text = prefs.getString('user_phone') ?? "";
    });
  }

  // متد ذخیره اطلاعات در حافظه گوشی
  _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_phone', _phoneController.text);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("اطلاعات با موفقیت ذخیره شد", textAlign: TextAlign.center))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text("پروفایل دارلا", style: TextStyle(color: Color(0xFF2F4F4F))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2F4F4F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView( // برای جلوگیری از خطای کیبورد در گوشی‌های کوچک
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_outline, size: 50, color: Color(0xFF556B2F)),
            ),
            const SizedBox(height: 30),
            _buildTextField("نام و نام خانوادگی", _nameController, Icons.person_outline),
            const SizedBox(height: 15),
            _buildTextField("شماره تماس", _phoneController, Icons.phone_android_outlined, isPhone: true),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF556B2F),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: _saveUserData, // صدا کردن متد ذخیره
              child: const Text("ذخیره در سیستم", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, {bool isPhone = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center, // برای زیباتر شدن و هماهنگی با کارت‌ها
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}