import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final bool? enabled;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller, 
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface, // Temaya uygun fillColor
            
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }
}
