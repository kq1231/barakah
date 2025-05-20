import 'package:flutter/material.dart';
import '../design_system/atoms/constants.dart';
import '../design_system/atoms/button.dart';
import '../design_system/atoms/base_components.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Savings Goals'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddGoalDialog(context),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _ActiveGoalsTab(),
            _CompletedGoalsTab(),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? name;
    double? targetAmount;
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
                onSaved: (value) => name = value,
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
                  return null;
                },
                onSaved: (value) => targetAmount = double.tryParse(value ?? ''),
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
                    targetDate = date;
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
                // TODO: Implement saving the new goal with name, targetAmount, targetDate, InshaaAllah
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Created new goal: $name (PKR ${targetAmount?.toStringAsFixed(0)})')),
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

class _ActiveGoalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: BarakahSpacing.md),
          child: _SavingsGoalCard(
            name: ['New Car', 'House Down Payment', 'Emergency Fund'][index],
            targetAmount: [500000.0, 2000000.0, 300000.0][index],
            currentAmount: [150000.0, 500000.0, 200000.0][index],
            targetDate: ['Dec 2025', 'Jan 2027', 'Aug 2025'][index],
            color: [
              BarakahColors.info,
              BarakahColors.success,
              BarakahColors.warning,
            ][index],
          ),
        );
      },
    );
  }
}

class _CompletedGoalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: BarakahSpacing.md),
          child: _SavingsGoalCard(
            name: ['Laptop', 'Vacation'][index],
            targetAmount: [150000.0, 200000.0][index],
            currentAmount: [150000.0, 200000.0][index],
            targetDate: ['Mar 2025', 'Apr 2025'][index],
            isCompleted: true,
            color: BarakahColors.success,
          ),
        );
      },
    );
  }
}

class _SavingsGoalCard extends StatelessWidget {
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String targetDate;
  final bool isCompleted;
  final Color color;

  const _SavingsGoalCard({
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    this.isCompleted = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentAmount / targetAmount;

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
                    Text(name, style: BarakahTypography.subtitle1),
                    Text(
                      'Target: $targetDate',
                      style: BarakahTypography.caption,
                    ),
                  ],
                ),
              ),
              if (!isCompleted)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showAddContributionDialog(context),
                  color: BarakahColors.primary,
                ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PKR ${currentAmount.toStringAsFixed(0)}',
                style: BarakahTypography.body1,
              ),
              Text(
                'PKR ${targetAmount.toStringAsFixed(0)}',
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

  void _showAddContributionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add to $name',
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
              onChanged: (value) {},
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
            onPressed: () => Navigator.pop(context),
            isSmall: true,
          ),
        ],
      ),
    );
  }
}
