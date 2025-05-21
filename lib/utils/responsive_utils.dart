import 'package:flutter/material.dart';

/// Utilidad para manejar el diseño responsivo en la aplicación
class ResponsiveUtils {
  /// Determina si el dispositivo está en modo portrait
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Determina si el dispositivo está en modo landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Obtiene el ancho de la pantalla
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtiene el alto de la pantalla
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Determina si el dispositivo es un teléfono (ancho < 600)
  static bool isPhone(BuildContext context) {
    return screenWidth(context) < 600;
  }

  /// Determina si el dispositivo es una tablet (ancho >= 600)
  static bool isTablet(BuildContext context) {
    return screenWidth(context) >= 600;
  }

  /// Obtiene el padding seguro para evitar notches y otros elementos del sistema
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Calcula un tamaño adaptativo basado en el ancho de la pantalla
  static double adaptiveSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Base de referencia: 360dp (ancho común en teléfonos)
    return size * (screenWidth / 360);
  }

  /// Calcula un tamaño de fuente adaptativo
  static double adaptiveFontSize(BuildContext context, double fontSize) {
    return adaptiveSize(context, fontSize);
  }

  /// Calcula un padding adaptativo
  static double adaptivePadding(BuildContext context, double padding) {
    return adaptiveSize(context, padding);
  }
}

/// Widget que construye diferentes layouts según la orientación
class OrientationLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext) portrait;
  final Widget Function(BuildContext) landscape;

  const OrientationLayoutBuilder({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? portrait(context)
            : landscape(context);
      },
    );
  }
}

/// Widget que construye diferentes layouts según el tamaño del dispositivo
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext) mobile;
  final Widget Function(BuildContext) tablet;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobile(context);
        } else {
          return tablet(context);
        }
      },
    );
  }
}