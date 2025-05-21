import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/responsive_utils.dart';
import '../app.dart';

class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassBottomNav({super.key, required this.currentIndex, required this.onTap});
  
  // Animación para los íconos cuando están seleccionados
  Widget _buildIcon(BuildContext context, IconData icon, String label, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: isSelected
          ? BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                ? AppColors.liver.withAlpha(25)
                : AppColors.paleDogwood.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usar el tamaño adaptativo para los márgenes
    final adaptiveMargin = ResponsiveUtils.adaptivePadding(context, 16);
    final isPhone = ResponsiveUtils.isPhone(context);
    
    return Container(
      margin: EdgeInsets.all(adaptiveMargin),
      height: isPhone ? 70 : 80, // Altura adaptativa
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.seashell.withAlpha(179)
            : AppColors.bistre2.withAlpha(179),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white.withAlpha(51)
              : Colors.white.withAlpha(26),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: isPhone
              ? ImageFilter.blur(sigmaX: 0, sigmaY: 0) // Desactivar el efecto blur en teléfonos de gama baja para mejor rendimiento
              : ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => onTap(0),
                child: _buildIcon(context, Icons.dashboard, 'Inicio', currentIndex == 0),
              ),
              GestureDetector(
                onTap: () => onTap(1),
                child: _buildIcon(context, Icons.inventory_2, 'Inventario', currentIndex == 1),
              ),
              GestureDetector(
                onTap: () => onTap(2),
                child: _buildIcon(context, Icons.local_florist, 'Lotes', currentIndex == 2),
              ),
              GestureDetector(
                onTap: () => onTap(3),
                child: _buildIcon(context, Icons.person, 'Perfil', currentIndex == 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
