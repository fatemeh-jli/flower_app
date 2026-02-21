import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../models/cart_model.dart';

class FlowerDetailScreen extends StatelessWidget {
  final Map<String, dynamic> flower;

  const FlowerDetailScreen({super.key, required this.flower});

Map<String, dynamic> getFlowerExtraInfo(String name) {
  Map<String, Map<String, dynamic>> info = {
    "رز قرمز": {
      "sci": "Rosa hybrida",
      "traits": ["عشق", "جسارت", "صمیمیت"],
      "desc": "تپش سرخ‌رنگِ خاک که بی‌واسطه از عمق قلب سخن می‌گوید و شکوهِ یک تمنای بی‌پایان است."
    },
    "ارکیده": {
      "sci": "Orchidaceae",
      "traits": ["شکوه", "اصالت", "کمال"],
      "desc": "نمادی از ظرافتِ اشرافی که با گلبرگ‌هایش، داستانی از وقار و زیباییِ نایاب را روایت می‌کند."
    },
    "آفتابگردان": {
      "sci": "Helianthus annuus",
      "traits": ["وفاداری", "شادی", "انرژی"],
      "desc": "فرزندِ خورشید بر روی زمین که با هر طلوع، سر به سوی روشنایی برمی‌آورد و بوی زندگی می‌دهد."
    },
    "صدتومانی": {
      "sci": "Paeonia",
      "traits": ["ثروت", "نجابت", "شانس"],
      "desc": "گلی با گلبرگ‌های لایه لایه و انبوه که تجملِ طبیعت را در نهایتِ لطافت به تصویر می‌کشد."
    },
    "لاله": {
      "sci": "Tulipa",
      "traits": ["تجدد", "شور", "بخشش"],
      "desc": "جامِ میِ طبیعت که با سادگیِ خیره‌کننده‌اش، مژده‌دهنده آمدن بهار و جوانه زدنِ امید است."
    },
    "لیلیوم": {
      "sci": "Lilium",
      "traits": ["پاکی", "ایمان", "آرامش"],
      "desc": "سفیر سپیدی و معصومیت که عطری بهشتی در فضا می‌پراکند و نمادِ بزرگیِ روح است."
    },
    "آنتوریوم": {
      "sci": "Anthurium",
      "traits": ["مهمان‌نوازی", "تمایز", "قدرت"],
      "desc": "با ظاهری چرمی و قلبی شکل، ایستادگی و تفاوت را در دنیای گل‌ها معنا می‌کند."
    },
    "گل مریم": {
      "sci": "Polianthes tuberosa",
      "traits": ["نجابت", "افسونگری", "عطر"],
      "desc": "ملکه‌ی شب که با عطر مست‌کننده‌اش، هر فضایی را به خاطره‌ای ماندگار و عاشقانه تبدیل می‌کند."
    },
    "شیپوری": {
      "sci": "Zantedeschia aethiopica",
      "traits": ["شکوه", "پاکی", "تعهد"],
      "desc": "مظهر سادگی مدرن و زیباییِ بی‌آلایش که با خطوطی نرم، نمادِ شروعی دوباره است."
    },
    "گل نرگس": {
      "sci": "Narcissus",
      "traits": ["تولد دوباره", "احترام", "تحسین"],
      "desc": "چشمِ بیدارِ باغ که با عطر نوستالژیک خود، پیام‌آور پایانِ زمستان و آغازِ روشنایی است."
    },
    "ژربرا": {
      "sci": "Gerbera jamesonii",
      "traits": ["صمیمیت", "خلوص", "شوق"],
      "desc": "خورشیدک‌های رنگی که با لبخندی همیشگی، سادگی و مهربانی را به بیننده هدیه می‌دهند."
    },
    "آلسترومریا": {
      "sci": "Alstroemeria",
      "traits": ["دوستی", "فداکاری", "پایداری"],
      "desc": "گلِ پیوند‌های عمیق که با طرح‌های ظریف روی گلبرگ‌هایش، نمادِ دوستی‌های ابدی است."
    },
    "داوودی": {
      "sci": "Chrysanthemum",
      "traits": ["طول عمر", "بهبود", "اشرافیت"],
      "desc": "گلِ خزان که با رنگ‌های گرمش، شکوهِ پاییز را به خانه می‌آورد و نمادِ خوش‌بینی است."
    },
    "میخک": {
      "sci": "Dianthus caryophyllus",
      "traits": ["شیفتگی", "تمایز", "مهر"],
      "desc": "گلی کلاسیک با حاشیه‌های دندانه‌دار که هر رنگش، رازی از دلدادگی و ستایش را فاش می‌کند."
    },
  };

  return info[name] ?? {
    "sci": "Flora",
    "traits": ["زیبایی", "لطافت"],
    "desc": "طبیعت با این گل، تکه‌ای از بهشت را به دستان شما هدیه کرده است."
  };
}
  @override
  Widget build(BuildContext context) {
    final extraInfo = getFlowerExtraInfo(flower['name']!);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // پس‌زمینه دو رنگ
              Row(
                children: [
                  Expanded(flex: 1, child: Container(color: const Color(0xFFB3E5FC))),
                  Expanded(flex: 2, child: Container(color: const Color(0xFFFDF9F6))),
                ],
              ),
              
              SafeArea(
                child: Column(
                  children: [
                    // هدر
                    _buildHeader(context),

                    // محتوای متنی با قابلیت اسکرول برای گوشی‌های کوچک
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          right: 20, 
                          left: size.width * 0.35, // فاصله برای اینکه متن روی عکس نرود
                          top: 20
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              flower['name']!, 
                              style: TextStyle(fontSize: size.width * 0.08, fontWeight: FontWeight.bold, color: const Color(0xFF2F4F4F)),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              "(${extraInfo['sci']})", 
                              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.blueGrey),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              extraInfo['desc'],
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 15, 
                                height: 1.6, 
                                color: const Color(0xFF2F4F4F).withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text("ویژگی‌ها:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Divider(indent: 100),
                            ...(extraInfo['traits'] as List<String>).map((trait) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(trait, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                            )),
                            const SizedBox(height: 100), // فاصله برای اینکه متن پشت تصویر نماند
                          ],
                        ),
                      ),
                    ),

                    // بخش قیمت و دکمه (ثابت در پایین)
                    _buildBottomBar(context, size),
                  ],
                ),
              ),

              // تصویر گل (واکنش‌گرا)
              Positioned(
                left: -size.width * 0.1, // تنظیم موقعیت بر اساس عرض گوشی
                bottom: size.height * 0.15,
                child: Hero(
                  tag: flower['name']!,
                  child: Image.asset(
                    flower['img']!, 
                    height: size.height * 0.45,
                    width: size.width * 0.6,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<CartModel>(
            builder: (context, cart, child) => Badge(
              label: Text("${cart.cartCount}"),
              isLabelVisible: cart.cartCount > 0,
              child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF2F4F4F)),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward_ios, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, Size size) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white.withOpacity(0.9),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Provider.of<CartModel>(context, listen: false).addToCart(flower);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${flower['name']} اضافه شد')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF556B2F),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("افزودن به سبد", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("قیمت واحد", style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text("${flower['price']} T", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}