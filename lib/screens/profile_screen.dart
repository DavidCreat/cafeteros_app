import 'package:flutter/material.dart';
import '../widgets/glass_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                Icon(Icons.person, color: Colors.grey.shade700),
                const Spacer(),
                Icon(Icons.notifications_none, color: Colors.grey.shade700),
              ],
            ),
            const SizedBox(height: 32),
            // Title
            const Text('Perfil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.black)),
            const SizedBox(height: 24),
            // Avatar y nombre
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, color: Colors.black54, size: 54),
                  ),
                  SizedBox(height: 18),
                  Text('David Fonseca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 4),
                  Text('Productor de café', style: TextStyle(color: Colors.grey, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Info cards
            _ProfileInfoCard(icon: Icons.email, label: 'Email', value: 'david.fonseca@cafeteros.com'),
            const SizedBox(height: 14),
            _ProfileInfoCard(icon: Icons.phone, label: 'Teléfono', value: '+57 300 000 0000'),
            const SizedBox(height: 32),
            // Botón logout
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 3,
        onTap: (idx) {
          // TODO: implementar navegación global
        },
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileInfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 8),
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
          Icon(icon, color: Colors.black87, size: 28),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
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
