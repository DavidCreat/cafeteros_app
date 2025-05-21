import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../app.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onNext;
  final bool isLast;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onNext,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveUtils.isPhone(context);
    final isPortrait = ResponsiveUtils.isPortrait(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Colores por defecto según el tema
    final defaultIconColor = isDarkMode 
        ? AppColors.paleDogwood 
        : AppColors.liver;
    
    final defaultBackgroundColor = isDarkMode 
        ? AppColors.bistre 
        : AppColors.isabelline;
    
    // Tamaños adaptativos
    final iconSize = ResponsiveUtils.adaptiveSize(context, isPhone ? 100 : 140);
    final titleSize = ResponsiveUtils.adaptiveFontSize(context, isPhone ? 24 : 32);
    final descriptionSize = ResponsiveUtils.adaptiveFontSize(context, isPhone ? 16 : 18);
    
    // Layout adaptativo según la orientación
    if (isPortrait) {
      return Container(
        color: backgroundColor ?? defaultBackgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.adaptivePadding(context, isPhone ? 24 : 32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? defaultIconColor,
            ),
            SizedBox(height: ResponsiveUtils.adaptivePadding(context, 40)),
            Text(
              title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.isabelline : AppColors.bistre,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.adaptivePadding(context, 16)),
            Text(
              description,
              style: TextStyle(
                fontSize: descriptionSize,
                color: isDarkMode ? AppColors.champagnePink : AppColors.coffee,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      // Layout para modo landscape
      return Container(
        color: backgroundColor ?? defaultBackgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.adaptivePadding(context, 32),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor ?? defaultIconColor,
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.isabelline : AppColors.bistre,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.adaptivePadding(context, 16)),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: descriptionSize,
                      color: isDarkMode ? AppColors.champagnePink : AppColors.coffee,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}