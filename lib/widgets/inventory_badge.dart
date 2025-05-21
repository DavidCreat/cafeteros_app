import 'package:flutter/material.dart';
import '../app.dart';
import '../utils/responsive_utils.dart';

class InventoryBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const InventoryBadge({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderRadius,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveUtils.isPhone(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Colores por defecto según el tema
    final defaultBackgroundColor = isDarkMode 
        ? AppColors.bistre2.withAlpha(179)
        : AppColors.seashell;
    
    final defaultTextColor = isDarkMode 
        ? AppColors.isabelline 
        : AppColors.bistre;
    
    final defaultIconColor = isDarkMode 
        ? AppColors.paleDogwood 
        : AppColors.liver;
    
    // Tamaños adaptativos
    final defaultBorderRadius = ResponsiveUtils.adaptiveSize(context, isPhone ? 12 : 16);
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.adaptivePadding(context, isPhone ? 10 : 14),
      vertical: ResponsiveUtils.adaptivePadding(context, isPhone ? 6 : 8),
    );
    
    // Construir el widget
    final badge = Container(
      padding: padding ?? defaultPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isPhone ? 16 : 20,
              color: iconColor ?? defaultIconColor,
            ),
            SizedBox(width: ResponsiveUtils.adaptivePadding(context, 6)),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveUtils.adaptiveFontSize(context, isPhone ? 10 : 12),
                  color: (textColor ?? defaultTextColor).withAlpha(179),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveUtils.adaptiveFontSize(context, isPhone ? 14 : 16),
                  fontWeight: FontWeight.bold,
                  color: textColor ?? defaultTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    
    // Si hay un onTap, envolver en un InkWell
    return onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius ?? defaultBorderRadius),
            child: badge,
          )
        : badge;
  }
}