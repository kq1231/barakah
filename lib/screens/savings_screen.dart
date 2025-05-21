import 'package:flutter/material.dart';
import '../design_system/atoms/constants.dart';
import '../design_system/atoms/button.dart';
import '../design_system/atoms/base_components.dart';
import '../design_system/templates/savings_template.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  // Mock data for savings goals
  final List<SavingGoalData> _activeGoals = [
    SavingGoalData(
      name: 'New Car',
      targetAmount: 500000.0,
      currentAmount: 150000.0,
      targetDate: DateTime(2025, 12, 31),
    ),
    SavingGoalData(
      name: 'House Down Payment',
      targetAmount: 2000000.0,
      currentAmount: 500000.0,
      targetDate: DateTime(2027, 1, 15),
    ),
    SavingGoalData(
      name: 'Emergency Fund',
      targetAmount: 300000.0,
      currentAmount: 200000.0,
      targetDate: DateTime(2025, 8, 30),
    ),
  ];

  final List<SavingGoalData> _completedGoals = [
    SavingGoalData(
      name: 'Laptop',
      targetAmount: 150000.0,
      currentAmount: 150000.0,
      targetDate: DateTime(2025, 3, 15),
    ),
    SavingGoalData(
      name: 'Vacation',
      targetAmount: 200000.0,
      currentAmount: 200000.0,
      targetDate: DateTime(2025, 4, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SavingsTemplate(
      activeGoals: _activeGoals,
      completedGoals: _completedGoals,
      onAddGoalPressed: () => _showAddGoalDialog(context),
      onGoalSelected: _handleGoalSelected,
      goalCardBuilder: _buildGoalCard,
      onCreateGoal: _createNewGoal,
    );
  }

  // Handle the selection of a savings goal
  void _handleGoalSelected(SavingGoalData goal) {
    // TODO: Navigate to goal detail screen or show detail dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected goal: ${goal.name}')),
    );
  }

  // Build a card widget for a savings goal
  Widget _buildGoalCard(BuildContext context, SavingGoalData goal) {
    final progress = goal.currentAmount / goal.targetAmount;
    final isCompleted = goal.currentAmount >= goal.targetAmount;
    final color = isCompleted
        ? BarakahColors.success
        : (progress > 0.7
            ? BarakahColors.info
            : progress > 0.4
                ? BarakahColors.warning
                : BarakahColors.error);

    final targetDateString = goal.targetDate != null
        ? '${goal.targetDate!.month}/${goal.targetDate!.year}'
        : 'No date';

    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(BarakahSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.star,
                  color: color,
                ),
              ),
              const SizedBox(width: BarakahSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal.name, style: BarakahTypography.subtitle1),
                    Text(
                      'Target: $targetDateString',
                      style: BarakahTypography.caption,
                    ),
                  ],
                ),
              ),
              if (!isCompleted)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showAddContributionDialog(context, goal),
                  color: BarakahColors.primary,
                ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PKR ${goal.currentAmount.toStringAsFixed(0)}',
                style: BarakahTypography.body1,
              ),
              Text(
                'PKR ${goal.targetAmount.toStringAsFixed(0)}',
                style: BarakahTypography.body1,
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.sm),
          BarakahProgressBar(
            value: progress,
            color: color,
          ),
          const SizedBox(height: BarakahSpacing.sm),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% saved',
            style: BarakahTypography.caption.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Create a new goal and add it to the active goals list
  Future<void> _createNewGoal(
      String name, double targetAmount, DateTime? targetDate) async {
    setState(() {
      _activeGoals.add(
        SavingGoalData(
          name: name,
          targetAmount: targetAmount,
          currentAmount: 0,
          targetDate: targetDate,
        ),
      );
    });
  }

  // Show dialog to add money to an existing goal
  void _showAddContributionDialog(BuildContext context, SavingGoalData goal) {
    double? amount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add to ${goal.name}',
          style: BarakahTypography.headline2,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: 'PKR ',
                prefixIcon: Icon(Icons.money),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => amount = double.tryParse(value),
            ),
            const SizedBox(height: BarakahSpacing.md),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'From Account',
                prefixIcon: Icon(Icons.account_balance_wallet),
              ),
              items: ['Cash', 'Bank Account', 'Savings Account']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged:
                  (value) {}, // Account selection will be used in a full implementation
            ),
          ],
        ),
        actions: [
          BarakahButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
            isSmall: true,
          ),
          BarakahButton(
            label: 'Add',
            onPressed: () {
              if (amount != null && amount! > 0) {
                setState(() {
                  // Find the index of this goal
                  final index = _activeGoals.indexWhere((g) =>
                      g.name == goal.name &&
                      g.targetAmount == goal.targetAmount);

                  if (index != -1) {
                    // Create new updated goal
                    final updatedGoal = SavingGoalData(
                      name: goal.name,
                      targetAmount: goal.targetAmount,
                      currentAmount: goal.currentAmount + amount!,
                      targetDate: goal.targetDate,
                      notes: goal.notes,
                      isRecurring: goal.isRecurring,
                      recurringAmount: goal.recurringAmount,
                    );

                    // Replace the goal with updated version
                    _activeGoals[index] = updatedGoal;

                    // If goal is completed, move it to completed goals
                    if (updatedGoal.currentAmount >= updatedGoal.targetAmount) {
                      _activeGoals.removeAt(index);
                      _completedGoals.add(updatedGoal);
                    }
                  }
                });
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Added PKR ${amount?.toStringAsFixed(0) ?? 0} to ${goal.name}')),
              );
            },
            isSmall: true,
          ),
        ],
      ),
    );
  }

  // Show dialog to add a new savings goal
  void _showAddGoalDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    double targetAmount = 0;
    DateTime? targetDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create New Goal',
          style: BarakahTypography.headline2,
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  prefixIcon: Icon(Icons.star_outline),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) name = value;
                },
              ),
              const SizedBox(height: BarakahSpacing.md),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Target Amount',
                  prefixIcon: Icon(Icons.money),
                  prefixText: 'PKR ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value!);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed != null) targetAmount = parsed;
                },
              ),
              const SizedBox(height: BarakahSpacing.md),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date != null) {
                    setState(() {
                      targetDate = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Target Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    targetDate == null
                        ? 'Select Date'
                        : '${targetDate?.day}/${targetDate?.month}/${targetDate?.year}',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          BarakahButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
            isSmall: true,
          ),
          BarakahButton(
            label: 'Create',
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                _createNewGoal(name, targetAmount, targetDate);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Created new goal: $name (PKR ${targetAmount.toStringAsFixed(0)})'),
                  ),
                );
              }
            },
            isSmall: true,
          ),
        ],
      ),
    );
  }
}
