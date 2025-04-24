import 'package:flutter/material.dart';

class InventoryBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const InventoryBadge({super.key, required this.label, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF8D6E63).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color ?? const Color(0xFF6D4C41), size: 16),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color ?? const Color(0xFF6D4C41),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
