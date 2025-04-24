import 'package:flutter/material.dart';
import '../widgets/glass_bottom_nav.dart';

class LotsScreen extends StatelessWidget {
  const LotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text(
              'Lotes registrados',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4E342E)),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
            _LotCard(
              name: 'Castillo',
              date: '2025-04-20',
              state: 'Pergamino seco',
              quantity: '50 kg',
            ),
            _LotCard(
              name: 'Colombia',
              date: '2025-04-18',
              state: 'Pergamino seco',
              quantity: '30 kg',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_box),
              label: const Text('Registrar nuevo lote'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                // TODO: Navegar a pantalla de registro de lote
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 2,
        onTap: (idx) {
          // TODO: implementar navegación global
        },
      ),
    );
  }
}

class _LotCard extends StatelessWidget {
  final String name;
  final String date;
  final String state;
  final String quantity;

  const _LotCard({required this.name, required this.date, required this.state, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4E342E),
          child: const Icon(Icons.local_florist, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Estado: $state\nFecha: $date\nCantidad: $quantity'),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline, color: Color(0xFF6D4C41)),
          onPressed: () {},
        ),
      ),
    );
  }
}
