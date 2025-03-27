import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double? size; // Taille optionnelle
  final double? borderRadius; // BorderRadius optionnel

  const ActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size, // Paramètre optionnel
    this.borderRadius, // Paramètre optionnel
  });

  @override
  Widget build(BuildContext context) {
    final double finalSize = size ?? 125;
    final double finalBorderRadius =
        borderRadius ?? (size != null ? finalSize / 2 : 15);

    return SizedBox(
      width: finalSize,
      height: finalSize,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(finalBorderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(finalBorderRadius),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
