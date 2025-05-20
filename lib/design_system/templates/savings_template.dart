import 'package:flutter/material.dart';
import '../atoms/constants.dart';

/// Data model for a savings goal
class SavingGoalData {
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? targetDate;
  final String? notes;
  final bool isRecurring;
  final double? recurringAmount;

  const SavingGoalData({
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    this.notes,
    this.isRecurring = false,
    this.recurringAmount,
  });
}

/// Template for the savings goals screen that handles the layout and structure
/// while remaining business logic agnostic.
class SavingsTemplate extends StatelessWidget {
  final List<SavingGoalData> activeGoals;
  final List<SavingGoalData> completedGoals;
  final void Function() onAddGoalPressed;
  final void Function(SavingGoalData goal) onGoalSelected;
  final Widget Function(BuildContext, SavingGoalData) goalCardBuilder;
  final Future<void> Function(
      String name, double targetAmount, DateTime? targetDate)? onCreateGoal;

  const SavingsTemplate({
    super.key,
    required this.activeGoals,
    required this.completedGoals,
    required this.onAddGoalPressed,
    required this.onGoalSelected,
    required this.goalCardBuilder,
    this.onCreateGoal,
  });

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
              onPressed: onAddGoalPressed,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _GoalsTabContent(
              goals: activeGoals,
              onGoalSelected: onGoalSelected,
              goalCardBuilder: goalCardBuilder,
              emptyMessage: 'No active savings goals',
            ),
            _GoalsTabContent(
              goals: completedGoals,
              onGoalSelected: onGoalSelected,
              goalCardBuilder: goalCardBuilder,
              emptyMessage: 'No completed savings goals',
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsTabContent extends StatelessWidget {
  final List<SavingGoalData> goals;
  final void Function(SavingGoalData) onGoalSelected;
  final Widget Function(BuildContext, SavingGoalData) goalCardBuilder;
  final String emptyMessage;

  const _GoalsTabContent({
    required this.goals,
    required this.onGoalSelected,
    required this.goalCardBuilder,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: BarakahSpacing.sm),
          child: InkWell(
            onTap: () => onGoalSelected(goal),
            child: goalCardBuilder(context, goal),
          ),
        );
      },
    );
  }
}
