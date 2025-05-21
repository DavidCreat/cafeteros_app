import 'package:flutter/material.dart';
import '../widgets/onboarding_page.dart';

import '../app.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Bienvenido a Inventario Cafetero',
      'subtitle': 'Gestiona tus lotes y tu inventario de café de manera simple, moderna y eficiente.',
      'image': 'assets/onboarding1.svg',
    },
    {
      'title': 'Registra y controla',
      'subtitle': 'Agrega lotes, consulta tu inventario y lleva el control de tu producción cafetera.',
      'image': 'assets/onboarding2.svg',
    },
    {
      'title': 'Sincroniza y protege tus datos',
      'subtitle': 'Tus datos siempre estarán seguros y disponibles, incluso sin conexión.',
      'image': 'assets/onboarding3.svg',
    },
  ];

  void _nextPage() {
    if (_pageIndex < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (idx) => setState(() => _pageIndex = idx),
              itemBuilder: (context, idx) {
                final page = _pages[idx];
                return OnboardingPage(
                  title: page['title']!,
                  description: page['subtitle']!,
                  icon: Icons.image,
                  onNext: _nextPage,
                  isLast: idx == _pages.length - 1,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_pageIndex == _pages.length - 1 ? 'Comenzar' : 'Siguiente'),
            ),
          ),
        ],
      ),
    );
  }
}
