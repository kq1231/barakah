import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../atoms/base_components.dart';
import '../atoms/button.dart';

class BalanceOverviewCard extends StatelessWidget {
  final double totalBalance;
  final double income;
  final double expenses;

  const BalanceOverviewCard({
    super.key,
    required this.totalBalance,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Balance', style: BarakahTypography.caption),
          const SizedBox(height: BarakahSpacing.sm),
          BarakahAmount(
            amount: totalBalance,
            isLarge: true,
            showSign: false,
          ),
          const SizedBox(height: BarakahSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Income', style: BarakahTypography.caption),
                    const SizedBox(height: BarakahSpacing.xs),
                    BarakahAmount(amount: income),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expenses', style: BarakahTypography.caption),
                    const SizedBox(height: BarakahSpacing.xs),
                    BarakahAmount(amount: -expenses),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickActionGrid extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionGrid({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: BarakahSpacing.sm,
      crossAxisSpacing: BarakahSpacing.sm,
      childAspectRatio: 0.8,
      children: actions.map((action) {
        return InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(BarakahSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: action.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(action.icon, color: action.color),
                ),
                const SizedBox(height: BarakahSpacing.sm),
                Text(
                  action.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: BarakahTypography.caption,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
