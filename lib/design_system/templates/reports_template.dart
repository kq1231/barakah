import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../atoms/base_components.dart';
import '../molecules/charts.dart';

/// Data class for monthly report summary
class MonthlyReportData {
  final double income;
  final double expenses;
  final List<DailyTransactionData> dailyTransactions;
  final List<CategoryExpenseData> topExpenses;

  const MonthlyReportData({
    required this.income,
    required this.expenses,
    required this.dailyTransactions,
    required this.topExpenses,
  });
}

/// Data class for daily transactions
class DailyTransactionData {
  final DateTime date;
  final double amount;

  const DailyTransactionData({
    required this.date,
    required this.amount,
  });
}

/// Data class for category expenses
class CategoryExpenseData {
  final String category;
  final double amount;
  final double percentage;

  const CategoryExpenseData({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

/// A template for the reports screen that's business logic agnostic.
/// This template provides a tabbed layout for different types of reports.
class ReportsTemplate extends StatelessWidget {
  final DateTime selectedMonth;
  final MonthlyReportData monthlyData;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onExport;
  final Function(CategoryExpenseData) onCategoryTap;

  const ReportsTemplate({
    super.key,
    required this.selectedMonth,
    required this.monthlyData,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onExport,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: onExport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(BarakahSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(context),
            const SizedBox(height: BarakahSpacing.lg),
            _buildMonthlyOverview(context),
            const SizedBox(height: BarakahSpacing.lg),
            _buildDailyExpensesChart(),
            const SizedBox(height: BarakahSpacing.lg),
            _buildTopExpenses(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onPreviousMonth,
        ),
        Text(
          '${_getMonthName(selectedMonth.month)} ${selectedMonth.year}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onNextMonth,
        ),
      ],
    );
  }

  Widget _buildMonthlyOverview(BuildContext context) {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: BarakahSpacing.md),
          Row(
            children: [
              Expanded(
                child: _OverviewItem(
                  label: 'Income',
                  amount: monthlyData.income,
                  isPositive: true,
                ),
              ),
              const SizedBox(width: BarakahSpacing.md),
              Expanded(
                child: _OverviewItem(
                  label: 'Expenses',
                  amount: monthlyData.expenses,
                  isPositive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.md),
          LinearProgressIndicator(
            value: monthlyData.expenses / monthlyData.income,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              monthlyData.expenses > monthlyData.income
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyExpensesChart() {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Expenses',
            style: BarakahTypography.subtitle1,
          ),
          const SizedBox(height: BarakahSpacing.md),
          SizedBox(
            height: 200,
            child: BarakahBarChart(
              title: 'Daily Expenses',
              data: monthlyData.dailyTransactions
                  .map((t) => BarData(
                        label: t.date.day.toString(),
                        value: t.amount,
                      ))
                  .toList(),
              maxValue: monthlyData.dailyTransactions
                  .fold(0.0, (max, t) => t.amount > max ? t.amount : max),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopExpenses(BuildContext context) {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Expenses',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: BarakahSpacing.md),
          ...monthlyData.topExpenses.map((category) => _CategoryExpenseItem(
                data: category,
                onTap: () => onCategoryTap(category),
              )),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final double amount;
  final bool isPositive;

  const _OverviewItem({
    required this.label,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BarakahTypography.caption),
        const SizedBox(height: BarakahSpacing.xs),
        Text(
          '${isPositive ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isPositive ? Colors.green : Colors.red,
              ),
        ),
      ],
    );
  }
}

class _CategoryExpenseItem extends StatelessWidget {
  final CategoryExpenseData data;
  final VoidCallback onTap;

  const _CategoryExpenseItem({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Text(
          data.category[0].toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      title: Text(data.category),
      subtitle: LinearProgressIndicator(
        value: data.percentage,
        backgroundColor: Colors.grey[200],
      ),
      trailing: Text(
        '\$${data.amount.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
