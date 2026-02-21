import 'package:flutter/material.dart';
import '../models/flower.dart';

class FlowerItemButton extends StatelessWidget {
  final Flower flower;
  final Function(Flower) onAdd;

  const FlowerItemButton({
    super.key,
    required this.flower,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(flower.emoji, style: const TextStyle(fontSize: 40)),
          Text('${flower.price} تومان', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(40, 30),
              backgroundColor: const Color(0xFFE5D1B8),
            ),
            onPressed: () => onAdd(flower),
            child: const Icon(Icons.add, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}