import 'package:flutter/material.dart';
import '../app.dart';
import '../utils/responsive_utils.dart';

class AppLogo extends StatelessWidget {
  final double? size;
  final bool showText;
  final bool isVertical;
  final Color? color;

  const AppLogo({
    super.key,
    this.size,
    this.showText = true,
    this.isVertical = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveUtils.isPhone(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Tamaño adaptativo del logo
    final defaultSize = ResponsiveUtils.adaptiveSize(context, isPhone ? 60 : 80);
    final logoSize = size ?? defaultSize;
    
    // Color adaptativo según el tema
    final logoColor = color ?? (isDarkMode ? AppColors.paleDogwood : AppColors.liver);
    
    // Icono del logo (usando un icono de café como placeholder)
    final logoIcon = Icon(
      Icons.coffee,
      size: logoSize,
      color: logoColor,
    );
    
    // Texto del logo
    final logoText = Text(
      'Inventario Cafetero',
      style: TextStyle(
        fontSize: ResponsiveUtils.adaptiveFontSize(context, isPhone ? 18 : 24),
        fontWeight: FontWeight.bold,
        color: logoColor,
      ),
    );
    
    // Si no se muestra texto, solo devolver el icono
    if (!showText) {
      return logoIcon;
    }
    
    // Organizar el logo según la orientación
    return isVertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logoIcon,
              SizedBox(height: ResponsiveUtils.adaptivePadding(context, 8)),
              logoText,
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              logoIcon,
              SizedBox(width: ResponsiveUtils.adaptivePadding(context, 12)),
              logoText,
            ],
          );
  }
}