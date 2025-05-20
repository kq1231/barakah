import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../atoms/button.dart';
import '../atoms/base_components.dart';
import '../molecules/charts.dart';

/// Data class for budget overview
class BudgetOverviewData {
  final double totalBudget;
  final double totalSpent;
  final DateTime monthStart;
  final DateTime monthEnd;
  final List<CategoryBudgetData> categories;

  const BudgetOverviewData({
    required this.totalBudget,
    required this.totalSpent,
    required this.monthStart,
    required this.monthEnd,
    required this.categories,
  });

  double get remainingBudget => totalBudget - totalSpent;
  double get progressPercentage => (totalSpent / totalBudget).clamp(0.0, 1.0);
  bool get isOverBudget => totalSpent > totalBudget;
}

/// Data class for category budget
class CategoryBudgetData {
  final String name;
  final IconData icon;
  final double budget;
  final double spent;
  final List<SpendingHistoryPoint> history;

  const CategoryBudgetData({
    required this.name,
    required this.icon,
    required this.budget,
    required this.spent,
    required this.history,
  });

  double get remainingBudget => budget - spent;
  double get progressPercentage => (spent / budget).clamp(0.0, 1.0);
  bool get isOverBudget => spent > budget;
}

/// Data class for spending history
class SpendingHistoryPoint {
  final DateTime date;
  final double amount;

  const SpendingHistoryPoint({
    required this.date,
    required this.amount,
  });
}

/// A template for the budget screen that's business logic agnostic.
class BudgetTemplate extends StatelessWidget {
  final BudgetOverviewData overview;
  final VoidCallback onAddBudget;
  final Function(CategoryBudgetData) onCategoryTap;
  final Function(String, double) onBudgetCreated;

  const BudgetTemplate({
    super.key,
    required this.overview,
    required this.onAddBudget,
    required this.onCategoryTap,
    required this.onBudgetCreated,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Budget'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Categories'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddBudgetDialog(context),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(context),
            _buildCategoriesTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthlyProgress(context),
          const SizedBox(height: BarakahSpacing.lg),
          _buildSpendingBreakdown(context),
          const SizedBox(height: BarakahSpacing.lg),
          _buildTopCategories(context),
        ],
      ),
    );
  }

  Widget _buildMonthlyProgress(BuildContext context) {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Budget',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: BarakahSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStat('Spent', overview.totalSpent, Colors.blue),
              _buildProgressStat('Remaining', overview.remainingBudget,
                  overview.isOverBudget ? Colors.red : Colors.green),
            ],
          ),
          const SizedBox(height: BarakahSpacing.md),
          LinearProgressIndicator(
            value: overview.progressPercentage,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              overview.isOverBudget ? Colors.red : Colors.blue,
            ),
          ),
          const SizedBox(height: BarakahSpacing.sm),
          Text(
            '${(overview.progressPercentage * 100).toInt()}% of budget used',
            style: BarakahTypography.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingBreakdown(BuildContext context) {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Breakdown',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: BarakahSpacing.md),
          SizedBox(
            height: 200,
            child: BarakahPieChart(
              title: 'Budget Overview',
              data: overview.categories
                  .map((c) => PieData(
                        label: c.name,
                        value: c.spent,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategories(BuildContext context) {
    final sortedCategories = List<CategoryBudgetData>.from(overview.categories)
      ..sort((a, b) => b.spent.compareTo(a.spent));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Categories',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: BarakahSpacing.md),
        ...sortedCategories.take(5).map(
              (category) => _CategoryBudgetCard(
                data: category,
                onTap: () => onCategoryTap(category),
              ),
            ),
      ],
    );
  }

  Widget _buildCategoriesTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      itemCount: overview.categories.length,
      itemBuilder: (context, index) {
        final category = overview.categories[index];
        return _CategoryBudgetCard(
          data: category,
          onTap: () => onCategoryTap(category),
          showHistory: true,
        );
      },
    );
  }

  Widget _buildProgressStat(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: BarakahTypography.caption,
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    String? category;
    double? amount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Budget',
          style: BarakahTypography.headline2,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
              items: ['Food', 'Transport', 'Shopping']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => category = value,
            ),
            const SizedBox(height: BarakahSpacing.md),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.money),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => amount = double.tryParse(value),
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
              if (category != null && amount != null) {
                onBudgetCreated(category!, amount!);
                Navigator.pop(context);
              }
            },
            isSmall: true,
          ),
        ],
      ),
    );
  }
}

class _CategoryBudgetCard extends StatelessWidget {
  final CategoryBudgetData data;
  final VoidCallback onTap;
  final bool showHistory;

  const _CategoryBudgetCard({
    required this.data,
    required this.onTap,
    this.showHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: BarakahSpacing.sm),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(BarakahSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(data.icon),
                  const SizedBox(width: BarakahSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '\$${data.spent.toStringAsFixed(2)} of \$${data.budget.toStringAsFixed(2)}',
                          style: BarakahTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(data.progressPercentage * 100).toInt()}%',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: data.isOverBudget ? Colors.red : null,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: BarakahSpacing.sm),
              LinearProgressIndicator(
                value: data.progressPercentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  data.isOverBudget ? Colors.red : Colors.blue,
                ),
              ),
              if (showHistory && data.history.isNotEmpty) ...[
                const SizedBox(height: BarakahSpacing.md),
                SizedBox(
                  height: 100,
                  child: BarakahBarChart(
                    title: 'Spending History',
                    data: data.history
                        .map((h) => BarData(
                              label: h.date.day.toString(),
                              value: h.amount,
                            ))
                        .toList(),
                    maxValue: data.history
                        .fold(0.0, (max, h) => h.amount > max ? h.amount : max),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
