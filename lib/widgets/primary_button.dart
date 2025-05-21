import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app.dart';
import '../utils/responsive_utils.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveUtils.isPhone(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Colores por defecto según el tema
    final defaultBackgroundColor = isDarkMode 
        ? AppColors.paleDogwood 
        : AppColors.liver;
    
    final defaultTextColor = isDarkMode 
        ? AppColors.bistre 
        : AppColors.isabelline;
    
    // Tamaños adaptativos
    final defaultHeight = ResponsiveUtils.adaptiveSize(context, isPhone ? 48 : 56);
    final defaultBorderRadius = ResponsiveUtils.adaptiveSize(context, isPhone ? 12 : 16);
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.adaptivePadding(context, isPhone ? 16 : 24),
      vertical: ResponsiveUtils.adaptivePadding(context, isPhone ? 12 : 16),
    );
    
    // Construir el botón
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? defaultHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : () {
          if (onPressed != null) {
            // Proporcionar feedback táctil
            HapticFeedback.mediumImpact();
            onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? defaultBackgroundColor,
          foregroundColor: textColor ?? defaultTextColor,
          padding: padding ?? defaultPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? defaultBorderRadius),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor ?? defaultTextColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: isPhone ? 18 : 22),
                    SizedBox(width: ResponsiveUtils.adaptivePadding(context, 8)),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.adaptiveFontSize(context, isPhone ? 14 : 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const SecondaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.borderColor,
    this.textColor,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveUtils.isPhone(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Colores por defecto según el tema
    final defaultBorderColor = isDarkMode 
        ? AppColors.paleDogwood 
        : AppColors.liver;
    
    final defaultTextColor = isDarkMode 
        ? AppColors.paleDogwood 
        : AppColors.liver;
    
    // Tamaños adaptativos
    final defaultHeight = ResponsiveUtils.adaptiveSize(context, isPhone ? 48 : 56);
    final defaultBorderRadius = ResponsiveUtils.adaptiveSize(context, isPhone ? 12 : 16);
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: ResponsiveUtils.adaptivePadding(context, isPhone ? 16 : 24),
      vertical: ResponsiveUtils.adaptivePadding(context, isPhone ? 12 : 16),
    );
    
    // Construir el botón
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? defaultHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : () {
          if (onPressed != null) {
            // Proporcionar feedback táctil
            HapticFeedback.lightImpact();
            onPressed!();
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? defaultBorderColor,
            width: 1.5,
          ),
          foregroundColor: textColor ?? defaultTextColor,
          padding: padding ?? defaultPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? defaultBorderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor ?? defaultTextColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: isPhone ? 18 : 22),
                    SizedBox(width: ResponsiveUtils.adaptivePadding(context, 8)),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.adaptiveFontSize(context, isPhone ? 14 : 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}