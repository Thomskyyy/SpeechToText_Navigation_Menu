import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final String route;

  const MenuButton({
    super.key,
    required this.text,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Card(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
