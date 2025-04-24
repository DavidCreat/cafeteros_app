import 'package:flutter/material.dart';
import 'app_logo.dart';
import 'primary_button.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;
  final VoidCallback? onNext;
  final bool isLast;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    this.onNext,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(size: 100),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Color(0xFF6D4C41)),
            ),
            const SizedBox(height: 40),
            if (onNext != null)
              PrimaryButton(
                text: isLast ? '¡Empezar!' : 'Siguiente',
                onPressed: onNext!,
                icon: isLast ? Icons.check : Icons.arrow_forward,
              ),
          ],
        ),
      ),
    );
  }
}
