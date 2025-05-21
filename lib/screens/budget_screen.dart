import 'package:flutter/material.dart';
import '../design_system/templates/budget_template.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - in a real app, this would come from a data layer
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    final categories = [
      CategoryBudgetData(
        name: 'Food',
        icon: Icons.fastfood,
        budget: 20000,
        spent: 15000,
        history: [
          SpendingHistoryPoint(
            date: DateTime(now.year, now.month, 5),
            amount: 5000,
          ),
          SpendingHistoryPoint(
            date: DateTime(now.year, now.month, 12),
            amount: 4500,
          ),
          SpendingHistoryPoint(
            date: DateTime(now.year, now.month, 20),
            amount: 5500,
          ),
        ],
      ),
      CategoryBudgetData(
        name: 'Transport',
        icon: Icons.directions_car,
        budget: 10000,
        spent: 8000,
        history: [
          SpendingHistoryPoint(
            date: DateTime(now.year, now.month, 3),
            amount: 3000,
          ),
          SpendingHistoryPoint(
            date: DateTime(now.year, now.month, 10),
            amount: 2500,
          ),
          SpendingHistoryPoint(
            date: DateTime(now.year, now.month, 18),
            amount: 2500,
          ),
        ],
      ),
      CategoryBudgetData(
        name: 'Entertainment',
        icon: Icons.movie,
        budget: 5000,
        spent: 4500,
        history: [
          SpendingHistoryPoint(
            date: DateTime(now.year, now.month, 8),
            amount: 2000,
          ),
          SpendingHistoryPoint(
            date: DateTime(now.year, now.month, 22),
            amount: 2500,
          ),
        ],
      ),
    ];

    final overviewData = BudgetOverviewData(
      totalBudget: 35000, // sum of all category budgets
      totalSpent: 27500, // sum of all category spending
      monthStart: monthStart,
      monthEnd: monthEnd,
      categories: categories,
    );

    return BudgetTemplate(
      overview: overviewData,
      onAddBudget: () => _showAddBudgetDialog(context),
      onCategoryTap: (category) {
        // Navigate to category detail screen
        Navigator.pushNamed(
          context,
          '/budget/category',
          arguments: {'category': category.name},
        );
      },
      onBudgetCreated: (category, amount) {
        // In a real app, you would save the new budget to a data source
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Budget added for $category: PKR $amount')),
        );
      },
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    // This is handled internally by the BudgetTemplate
  }
}
