import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/responsive_utils.dart';

/// Tarjeta adaptativa que se ajusta a diferentes tamaños de pantalla
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final VoidCallback? onTap;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.height,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener valores adaptados al tamaño de la pantalla
    final isPhone = ResponsiveUtils.isPhone(context);
    final defaultPadding = ResponsiveUtils.adaptivePadding(context, isPhone ? 12 : 16);
    final defaultMargin = ResponsiveUtils.adaptivePadding(context, isPhone ? 8 : 12);
    final defaultElevation = isPhone ? 2.0 : 3.0;
    final defaultBorderRadius = BorderRadius.circular(isPhone ? 12 : 16);
    
    // Aplicar animación al tocar la tarjeta
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: height,
        width: width,
        padding: padding ?? EdgeInsets.all(defaultPadding),
        margin: margin ?? EdgeInsets.all(defaultMargin),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).cardColor,
          borderRadius: borderRadius ?? defaultBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: elevation ?? defaultElevation,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Tarjeta adaptativa con efecto de vidrio (glassmorphism)
class AdaptiveGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? overlayColor;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final bool useBlur;

  const AdaptiveGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.overlayColor,
    this.borderRadius,
    this.height,
    this.width,
    this.onTap,
    this.useBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener valores adaptados al tamaño de la pantalla
    final isPhone = ResponsiveUtils.isPhone(context);
    final defaultPadding = ResponsiveUtils.adaptivePadding(context, isPhone ? 12 : 16);
    final defaultMargin = ResponsiveUtils.adaptivePadding(context, isPhone ? 8 : 12);
    final defaultElevation = isPhone ? 2.0 : 3.0;
    final defaultBorderRadius = BorderRadius.circular(isPhone ? 12 : 16);
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultOverlayColor = isDarkMode 
        ? Colors.white.withAlpha(13) 
        : Colors.white.withAlpha(179);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin ?? EdgeInsets.all(defaultMargin),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? defaultBorderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: elevation ?? defaultElevation,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: isDarkMode 
                ? Colors.white.withAlpha(26) 
                : Colors.white.withAlpha(77),
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? defaultBorderRadius,
          child: BackdropFilter(
            filter: useBlur && !isPhone 
                ? ImageFilter.blur(sigmaX: 10, sigmaY: 10) 
                : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              padding: padding ?? EdgeInsets.all(defaultPadding),
              color: overlayColor ?? defaultOverlayColor,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta adaptativa con efecto de elevación y sombra suave
class AdaptiveElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final bool animate;

  const AdaptiveElevatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.height,
    this.width,
    this.onTap,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener valores adaptados al tamaño de la pantalla
    final isPhone = ResponsiveUtils.isPhone(context);
    final defaultPadding = ResponsiveUtils.adaptivePadding(context, isPhone ? 12 : 16);
    final defaultMargin = ResponsiveUtils.adaptivePadding(context, isPhone ? 8 : 12);
    final defaultElevation = isPhone ? 3.0 : 5.0;
    final defaultBorderRadius = BorderRadius.circular(isPhone ? 16 : 20);
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDarkMode 
        ? Theme.of(context).cardColor.withAlpha(230) 
        : Theme.of(context).cardColor;
    
    final container = Container(
      height: height,
      width: width,
      padding: padding ?? EdgeInsets.all(defaultPadding),
      margin: margin ?? EdgeInsets.all(defaultMargin),
      decoration: BoxDecoration(
        color: color ?? defaultColor,
        borderRadius: borderRadius ?? defaultBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: (elevation ?? defaultElevation) * 2,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withAlpha(isDarkMode ? 13 : 77),
            blurRadius: (elevation ?? defaultElevation) / 2,
            offset: const Offset(0, -1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
    
    if (!animate || onTap == null) {
      return container;
    }
    
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: container,
      ),
    );
  }
}