import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../templates/savings_template.dart';

class GoalCard extends StatelessWidget {
  final SavingGoalData goal;
  final Color? progressColor;
  final Color? backgroundColor;

  const GoalCard({
    super.key,
    required this.goal,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal.currentAmount / goal.targetAmount;
    final theme = Theme.of(context);

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(BarakahSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (goal.isRecurring)
                  const Icon(
                    Icons.repeat,
                    size: 16,
                  ),
              ],
            ),
            const SizedBox(height: BarakahSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(BarakahSpacing.xs),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor ?? theme.colorScheme.primary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: BarakahSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PKR ${goal.currentAmount.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'PKR ${goal.targetAmount.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (goal.targetDate != null) ...[
              const SizedBox(height: BarakahSpacing.xs),
              Text(
                'Target: ${_formatDate(goal.targetDate!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
