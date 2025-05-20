import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../atoms/base_components.dart';

class TransactionListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final double amount;

  const TransactionListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BarakahSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(BarakahSpacing.sm),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: BarakahSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: BarakahTypography.subtitle1),
                Text(
                  subtitle,
                  style: BarakahTypography.caption,
                ),
              ],
            ),
          ),
          BarakahAmount(amount: amount),
        ],
      ),
    );
  }
}

class BudgetProgressCard extends StatelessWidget {
  final String category;
  final double spent;
  final double total;
  final Color color;

  const BudgetProgressCard({
    super.key,
    required this.category,
    required this.spent,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: BarakahTypography.subtitle1),
              Text(
                'PKR ${spent.toInt()} / ${total.toInt()}',
                style: BarakahTypography.caption,
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.sm),
          BarakahProgressBar(
            value: spent / total,
            color: color,
          ),
        ],
      ),
    );
  }
}
