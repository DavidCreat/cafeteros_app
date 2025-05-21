import 'package:flutter/material.dart';
import '../app.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  void _toggleTheme(bool isDark) {
    final appState = context.findAncestorStateOfType<InventarioCafeteroAppState>();
    if (appState != null) {
      appState.setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    }
  }




  @override
  Widget build(BuildContext context) {
    final appState = context.findAncestorStateOfType<InventarioCafeteroAppState>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
              icon: Icon(appState?.currentThemeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => _toggleTheme(appState?.currentThemeMode == ThemeMode.light),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header con iconos de perfil y notificaciones
            const _ProfileHeader(),
            const SizedBox(height: 32),
            // Title
            Text('Perfil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Theme.of(context).textTheme.titleLarge?.color)),
            const SizedBox(height: 24),
            // Información del usuario
            const _UserProfile(),
            const SizedBox(height: 32),
            // Información de contacto
            const _ContactInfo(),
            const SizedBox(height: 32),
            // Botón de cierre de sesión
            const _LogoutButton(),
          ],
        ),
      ),
      // La navegación se maneja desde app.dart
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person, color: Colors.grey.shade700),
        const Spacer(),
        Icon(Icons.notifications_none, color: Colors.grey.shade700),
      ],
    );
  }
}

class _UserProfile extends StatelessWidget {
  const _UserProfile();

  @override
  Widget build(BuildContext context) {
    return Center(
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
      )
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCard(icon: Icons.email, label: 'Email', value: 'david.fonseca@cafeteros.com'),
        const SizedBox(height: 14),
        _InfoCard(icon: Icons.phone, label: 'Teléfono', value: '+57 300 000 0000'),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Center(
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
      )
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoCard({required this.icon, required this.label, required this.value});

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
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 28),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
            ],
          ),
        ],
      )
    );
  }
}
