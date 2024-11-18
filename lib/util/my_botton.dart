import 'package:flutter/material.dart';

class MyBotton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Icon? icon; // İkon parametresi eklendi

  const MyBotton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon, // Opsiyonel ikon parametresi
  });


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!, // Eğer ikon varsa göster
              const SizedBox(width: 10), // İkon ile metin arasında boşluk
            ],
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black, // rengini temaya göre ayarladık
              ),
            ),
          ],
        ),
      ),
    );
  }
}
