import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({super.key, required this.icon, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
          color: color,
          borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Icon(
            icon,
            size: 90,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}