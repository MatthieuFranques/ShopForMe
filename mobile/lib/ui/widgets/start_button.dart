import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth * 0.4; // 20% de la largeur du parent
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(size * 0.2),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: Icon(Icons.play_arrow, size: size),
        );
      },
    );
  }
}