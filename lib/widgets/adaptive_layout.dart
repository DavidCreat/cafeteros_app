import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// Widget que proporciona un layout adaptativo según la orientación y tamaño de pantalla
class AdaptiveLayout extends StatelessWidget {
  final Widget Function(BuildContext, BoxConstraints) builder;
  final EdgeInsetsGeometry? padding;

  const AdaptiveLayout({
    super.key,
    required this.builder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar si estamos en modo portrait o landscape
        final isPortrait = ResponsiveUtils.isPortrait(context);
        final isPhone = ResponsiveUtils.isPhone(context);
        
        // Calcular el padding adaptativo según el tamaño de la pantalla
        final defaultPadding = EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.adaptivePadding(
            context, 
            isPhone ? (isPortrait ? 16 : 24) : (isPortrait ? 24 : 32)
          ),
          vertical: ResponsiveUtils.adaptivePadding(
            context, 
            isPhone ? 16 : 24
          ),
        );
        
        return Padding(
          padding: padding ?? defaultPadding,
          child: builder(context, constraints),
        );
      },
    );
  }
}

/// Widget que proporciona un layout adaptativo con scroll seguro
class AdaptiveScrollView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool primary;
  final ScrollController? controller;
  final Axis scrollDirection;

  const AdaptiveScrollView({
    super.key,
    required this.children,
    this.padding,
    this.physics,
    this.primary = false,
    this.controller,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el padding seguro para evitar notches y otros elementos del sistema
    final safePadding = ResponsiveUtils.safeAreaPadding(context);
    final isPhone = ResponsiveUtils.isPhone(context);
    
    // Calcular el padding adaptativo según el tamaño de la pantalla
    final defaultPadding = EdgeInsets.fromLTRB(
      ResponsiveUtils.adaptivePadding(context, isPhone ? 16 : 24),
      safePadding.top + ResponsiveUtils.adaptivePadding(context, 16),
      ResponsiveUtils.adaptivePadding(context, isPhone ? 16 : 24),
      safePadding.bottom + ResponsiveUtils.adaptivePadding(context, 16),
    );
    
    return ListView(
      padding: padding ?? defaultPadding,
      physics: physics ?? const BouncingScrollPhysics(),
      primary: primary,
      controller: controller,
      scrollDirection: scrollDirection,
      children: children,
    );
  }
}

/// Widget que proporciona un grid adaptativo según el tamaño de la pantalla
class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final double runSpacing;
  final int? phoneColumns;
  final int? tabletColumns;

  const AdaptiveGrid({
    super.key,
    required this.children,
    this.padding,
    this.spacing = 16,
    this.runSpacing = 16,
    this.phoneColumns = 2,
    this.tabletColumns = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isPhone = ResponsiveUtils.isPhone(context);
    final isPortrait = ResponsiveUtils.isPortrait(context);
    
    // Determinar el número de columnas según el dispositivo y orientación
    final columns = isPhone 
        ? (isPortrait ? phoneColumns : (phoneColumns! + 1)) 
        : (isPortrait ? tabletColumns : (tabletColumns! + 1));
    
    // Calcular el padding adaptativo
    final adaptiveSpacing = ResponsiveUtils.adaptivePadding(context, spacing);
    final adaptiveRunSpacing = ResponsiveUtils.adaptivePadding(context, runSpacing);
    
    return Padding(
      padding: padding ?? EdgeInsets.all(adaptiveSpacing),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns!,
          crossAxisSpacing: adaptiveSpacing,
          mainAxisSpacing: adaptiveRunSpacing,
          childAspectRatio: isPortrait ? 1.0 : 1.3,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}