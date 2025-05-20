import 'package:flutter/material.dart';
import 'constants.dart';

class BarakahCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double elevation;

  const BarakahCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: backgroundColor ?? BarakahColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(BarakahSpacing.md),
        child: child,
      ),
    );
  }
}

class BarakahAmount extends StatelessWidget {
  final double amount;
  final bool isLarge;
  final bool showSign;

  const BarakahAmount({
    super.key,
    required this.amount,
    this.isLarge = false,
    this.showSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = amount >= 0 ? BarakahColors.success : BarakahColors.error;
    final sign = amount >= 0 ? '+' : '';
    final formattedAmount = 'PKR ${amount.abs().toStringAsFixed(2)}';

    return Text(
      showSign ? '$sign$formattedAmount' : formattedAmount,
      style:
          (isLarge ? BarakahTypography.headline1 : BarakahTypography.subtitle1)
              .copyWith(color: color),
    );
  }
}

class BarakahProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const BarakahProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: color.withValues(alpha: 0.2),
        valueColor: AlwaysStoppedAnimation<Color>(color),
        minHeight: height,
      ),
    );
  }
}
