import 'package:flutter/material.dart';
import 'constants.dart';

class BarakahButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isSmall;
  final IconData? icon;

  const BarakahButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: BarakahColors.primary,
            side: const BorderSide(color: BarakahColors.primary),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: BarakahColors.primary,
            foregroundColor: Colors.white,
          );

    final padding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    if (icon != null) {
      return isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon),
              label: Text(label),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon),
              label: Text(label),
            );
    }

    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: style.copyWith(padding: WidgetStatePropertyAll(padding)),
            child: Text(label),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: style.copyWith(padding: WidgetStatePropertyAll(padding)),
            child: Text(label),
          );
  }
}
