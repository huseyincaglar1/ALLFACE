import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(isDarkMode
              ? 'assets/dark_background.jpg' // Dark mode görseli
              : 'assets/light_background.jpg' // Light mode görseli
          ),
          fit: BoxFit.cover, // Görselin tam ekran kaplamasını sağlıyor
        ),
      ),
      child: child,
    );
  }
}
