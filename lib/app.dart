import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/connectivity_service.dart';
import '../repositories/data_repository.dart';
import 'screens/dashboard_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/lots_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';
import 'widgets/glass_bottom_nav.dart';

// Paleta de colores global para la aplicación
class AppColors {
  // Colores principales
  static const Color isabelline = Color(0xFFF9F5F3); // Color principal/claro
  static const Color seashell = Color(0xFFF0E5E1);
  static const Color champagnePink = Color(0xFFE6D5CE);
  static const Color paleDogwood = Color(0xFFD3B6AB);
  static const Color beaver = Color(0xFFAA8B7E);
  static const Color coffee = Color(0xFF815F51);
  static const Color liver = Color(0xFF644234);
  static const Color bistre3 = Color(0xFF4D3328);
  static const Color bistre2 = Color(0xFF422C22);
  static const Color bistre = Color(0xFF36241C); // Color más oscuro
  
  // Colores para el tema claro
  static const Color lightBackground = isabelline;
  static const Color lightSurface = seashell;
  static const Color lightPrimary = liver;
  static const Color lightSecondary = coffee;
  static const Color lightAccent = beaver;
  static const Color lightText = bistre;
  
  // Colores para el tema oscuro
  static const Color darkBackground = bistre;
  static const Color darkSurface = bistre2;
  static const Color darkPrimary = champagnePink;
  static const Color darkSecondary = paleDogwood;
  static const Color darkAccent = beaver;
  static const Color darkText = isabelline;
}

class InventarioCafeteroApp extends StatefulWidget {
  const InventarioCafeteroApp({super.key});

  @override
  State<InventarioCafeteroApp> createState() => InventarioCafeteroAppState();
}

class InventarioCafeteroAppState extends State<InventarioCafeteroApp> {
  ThemeMode _currentThemeMode = ThemeMode.light;

  ThemeMode get currentThemeMode => _currentThemeMode;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _currentThemeMode = mode;
    });
  }
  int _currentIndex = 0;
  bool _showOnboarding = true;

  final List<Widget> _screens = [
    DashboardScreen(),
    InventoryScreen(),
    LotsScreen(),
    ProfileScreen(),
  ];

  void _finishOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showOnboarding', false);
      
      if (mounted) {
        setState(() {
          _showOnboarding = false;
        });
        // Ya no necesitamos navegar explícitamente porque
        // la propiedad home del MaterialApp se actualizará automáticamente
      }
    } catch (e) {
      debugPrint('Error al finalizar onboarding: $e');
      // Asegurar que el usuario pueda continuar incluso si hay un error
      if (mounted) {
        setState(() {
          _showOnboarding = false;
        });
      }
    }
  }
  
  void navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
void initState() {
  super.initState();
  
  // Inicializar todo de forma asíncrona pero secuencial
  _initializeApp();
  
  // Configurar orientaciones permitidas
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

// Método para inicializar todos los componentes de la app de forma secuencial
Future<void> _initializeApp() async {
  try {
    // Inicializar Hive primero
    await _initializeHive();
    
    // Luego verificar el estado de onboarding
    await _checkOnboardingStatus();
    
    // Finalmente inicializar el servicio de conectividad
    ConnectivityService().initialize();
  } catch (e) {
    debugPrint('Error durante la inicialización de la aplicación: $e');
    // Continuar con la aplicación incluso si hay errores
  }
}

Future<void> _initializeHive() async {
  try {
    await Hive.initFlutter();
    await DataRepository().init();
  } catch (e) {
    // Manejar errores de inicialización para evitar bloqueos
    debugPrint('Error al inicializar Hive o el repositorio de datos: $e');
    // Continuar con la aplicación incluso si hay errores
  }
}

Future<void> _checkOnboardingStatus() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final showOnboarding = prefs.getBool('showOnboarding');
    
    if (mounted) {
      setState(() {
        _showOnboarding = showOnboarding ?? true;
      });
    }
  } catch (e) {
    // En caso de error, mantener el valor predeterminado
    if (mounted) {
      setState(() {
        _showOnboarding = true;
      });
    }
    debugPrint('Error al cargar el estado de onboarding: $e');
  }
}
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Cafetero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.liver,
          primary: AppColors.liver,
          secondary: AppColors.coffee,
          tertiary: AppColors.beaver,
          surface: AppColors.lightBackground,
          surfaceContainerLow: AppColors.lightSurface,
          onPrimary: AppColors.isabelline,
          onSecondary: AppColors.isabelline,
          onSurface: AppColors.lightText,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.seashell,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.bistre3,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          iconTheme: IconThemeData(color: AppColors.bistre3),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.liver,
            foregroundColor: AppColors.isabelline,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: AppColors.seashell,
        ),
        iconTheme: const IconThemeData(color: AppColors.liver),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.bistre),
          bodyMedium: TextStyle(color: AppColors.bistre),
          titleLarge: TextStyle(color: AppColors.bistre, fontWeight: FontWeight.bold),
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.paleDogwood,
          brightness: Brightness.dark,
          primary: AppColors.paleDogwood,
          secondary: AppColors.champagnePink,
          tertiary: AppColors.beaver,
          surface: AppColors.darkBackground,
          surfaceContainerLow: AppColors.darkSurface,
          onPrimary: AppColors.bistre,
          onSecondary: AppColors.bistre,
          onSurface: AppColors.darkText,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.bistre2,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.isabelline,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          iconTheme: IconThemeData(color: AppColors.isabelline),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.paleDogwood,
            foregroundColor: AppColors.bistre,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: AppColors.bistre2,
        ),
        iconTheme: const IconThemeData(color: AppColors.champagnePink),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.seashell),
          bodyMedium: TextStyle(color: AppColors.seashell),
          titleLarge: TextStyle(color: AppColors.isabelline, fontWeight: FontWeight.bold),
        ),
        brightness: Brightness.dark,
      ),
      themeMode: _currentThemeMode,
      // Usar home en lugar de initialRoute para evitar problemas de navegación
      home: _showOnboarding ? OnboardingScreen(onFinish: _finishOnboarding) : Builder(
        builder: (context) {
          // Aplicar configuraciones de sistema para mejorar la experiencia móvil
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Theme.of(context).brightness == Brightness.light 
                ? Brightness.dark 
                : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light 
                ? Brightness.dark 
                : Brightness.light,
          ));
          
          return Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_currentIndex],
            ),
            extendBody: true,
            bottomNavigationBar: GlassBottomNav(
              currentIndex: _currentIndex,
              onTap: navigateToScreen,
            ),
          );
        },
      ),
      routes: {
        // Ya no necesitamos la ruta '/' porque está definida en home
        // Tampoco necesitamos la ruta '/onboarding' por la misma razón
        '/lotes': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final searchQuery = args?['searchQuery'] as String? ?? '';
          return LotsScreen(initialSearchQuery: searchQuery);
        },
      },
    );
  }
}
