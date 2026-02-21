import '../models/flower.dart';

// ۱. لیست پایه (منبع اصلی داده‌ها)
final List<Map<String, dynamic>> allFlowers = [
  {"name": "رز قرمز", "price": 45000, "img": "assets/images/red_roses.jpg", "emoji": "🌹"},
  {"name": "ارکیده", "price": 120000, "img": "assets/images/orchid.jpg", "emoji": "🌸"},
  {"name": "آفتابگردان", "price": 25000, "img": "assets/images/sunfl.jpg", "emoji": "🌻"},
  {"name": "صدتومانی", "price": 85000, "img": "assets/images/sad.jpg", "emoji": "🌺"},
  {"name": "لاله", "price": 35000, "img": "assets/images/lale.jpg", "emoji": "🌷"},
  {"name": "لیلیوم", "price": 60000, "img": "assets/images/lily.jpg", "emoji": "💐"},
  {"name": "آنتوریوم", "price": 55000, "img": "assets/images/antro.jpg", "emoji": "🥀"},
  {"name": "گل مریم", "price": 30000, "img": "assets/images/maryam.jpg", "emoji": "🌼"},
  {"name": "شیپوری", "price": 95000, "img": "assets/images/sheypor.jpg", "emoji": "🌾"},
  {"name": "گل نرگس", "price": 40000, "img": "assets/images/narges.jpg", "emoji": "🌱"},
  {"name": "ژربرا", "price": 28000, "img": "assets/images/zherbra.jpg", "emoji": "🌿"},
  {"name": "آلسترومریا", "price": 32000, "img": "assets/images/alice.jpg", "emoji": "🌵"},
  {"name": "داوودی", "price": 22000, "img": "assets/images/davood.jpg", "emoji": "🍀"},
  {"name": "میخک", "price": 18000, "img": "assets/images/mikhak.jpg", "emoji": "🍃"},
];

// ۲. تولید خودکار لیست مخصوص استودیو از روی لیست بالا
// دقت کنید که فقط یک بار تعریف شده باشد
final List<Flower> flowerList = allFlowers.map((f) => Flower(
  name: f['name'],
  price: f['price'],
  emoji: f['emoji'],
  imagePath: f['img'], 
)).toList();