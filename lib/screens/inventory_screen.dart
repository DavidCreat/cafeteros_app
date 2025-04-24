import 'package:flutter/material.dart';
import '../widgets/glass_bottom_nav.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.inventory_2, color: Colors.grey.shade700),
                const Spacer(),
                Icon(Icons.notifications_none, color: Colors.grey.shade700),
              ],
            ),
            const SizedBox(height: 32),
            // Title
            const Text('Inventario', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black)),
            const SizedBox(height: 24),
            // Search bar
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar lote',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            // Inventory list
            _InventoryItem(name: 'Castillo - Pergamino seco', qty: '50 kg'),
            _InventoryItem(name: 'Colombia - Pergamino seco', qty: '30 kg'),
            _InventoryItem(name: 'Tabi - Verde', qty: '20 kg'),
          ],
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 1,
        onTap: (idx) {
          // TODO: implementar navegación global
        },
      ),
    );
  }
}

class _InventoryItem extends StatelessWidget {
  final String name;
  final String qty;
  const _InventoryItem({required this.name, required this.qty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.coffee, color: Colors.black87, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(qty, style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const _NavIcon({required this.icon, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, color: selected ? Colors.white : Colors.black, size: 26),
    );
  }
}
