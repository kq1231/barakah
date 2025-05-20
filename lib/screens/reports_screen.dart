import 'package:flutter/material.dart';
import '../design_system/atoms/constants.dart';
import '../design_system/atoms/base_components.dart';
import '../design_system/molecules/charts.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Monthly'),
              Tab(text: 'Categories'),
              Tab(text: 'Yearly'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => _exportReport(context),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _MonthlyReportTab(),
            _CategoriesReportTab(),
            _YearlyReportTab(),
          ],
        ),
      ),
    );
  }

  void _exportReport(BuildContext context) {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting report...')),
    );
  }
}

class _MonthlyReportTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthSelector(),
          const SizedBox(height: BarakahSpacing.lg),
          _buildMonthlyOverview(),
          const SizedBox(height: BarakahSpacing.lg),
          _buildDailyExpenses(),
          const SizedBox(height: BarakahSpacing.lg),
          _buildTopExpenses(),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {},
        ),
        Text(
          'May 2025',
          style: BarakahTypography.headline2,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMonthlyOverview() {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Overview',
            style: BarakahTypography.subtitle1,
          ),
          const SizedBox(height: BarakahSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Income',
                      style: BarakahTypography.caption,
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    const BarakahAmount(
                      amount: 75000,
                      showSign: false,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expenses',
                      style: BarakahTypography.caption,
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    const BarakahAmount(
                      amount: -45000,
                      showSign: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyExpenses() {
    final data = List.generate(
      7,
      (index) => BarData(
        label: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
        value: [3000.0, 2500.0, 4000.0, 1500.0, 3500.0, 5000.0, 2000.0][index],
        color: BarakahColors.primary,
      ),
    );

    return BarakahCard(
      child: BarakahBarChart(
        title: 'Daily Expenses',
        data: data,
        maxValue: 5000,
      ),
    );
  }

  Widget _buildTopExpenses() {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Expenses',
            style: BarakahTypography.subtitle1,
          ),
          const SizedBox(height: BarakahSpacing.md),
          _buildExpenseItem(
            'Shopping',
            15000,
            Icons.shopping_bag,
            BarakahColors.warning,
          ),
          const Divider(),
          _buildExpenseItem(
            'Transport',
            12000,
            Icons.directions_car,
            BarakahColors.info,
          ),
          const Divider(),
          _buildExpenseItem(
            'Food',
            10000,
            Icons.restaurant,
            BarakahColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
    String category,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BarakahSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(BarakahSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: BarakahSpacing.md),
          Expanded(
            child: Text(
              category,
              style: BarakahTypography.subtitle1,
            ),
          ),
          BarakahAmount(
            amount: -amount,
            showSign: false,
          ),
        ],
      ),
    );
  }
}

class _CategoriesReportTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      child: Column(
        children: [
          _buildCategoryPieChart(),
          const SizedBox(height: BarakahSpacing.lg),
          _buildCategoryList(),
        ],
      ),
    );
  }

  Widget _buildCategoryPieChart() {
    final data = [
      PieData(
        label: 'Shopping',
        value: 15000,
        color: BarakahColors.warning,
      ),
      PieData(
        label: 'Transport',
        value: 12000,
        color: BarakahColors.info,
      ),
      PieData(
        label: 'Food',
        value: 10000,
        color: BarakahColors.success,
      ),
      PieData(
        label: 'Bills',
        value: 8000,
        color: BarakahColors.error,
      ),
    ];

    return BarakahCard(
      child: BarakahPieChart(
        title: 'Expenses by Category',
        data: data,
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Categories',
          style: BarakahTypography.subtitle1,
        ),
        const SizedBox(height: BarakahSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final categories = [
              ('Shopping', 15000, Icons.shopping_bag, BarakahColors.warning),
              ('Transport', 12000, Icons.directions_car, BarakahColors.info),
              ('Food', 10000, Icons.restaurant, BarakahColors.success),
              ('Bills', 8000, Icons.receipt, BarakahColors.error),
            ];
            final category = categories[index];
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(BarakahSpacing.sm),
                decoration: BoxDecoration(
                  color: category.$4.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(category.$3, color: category.$4),
              ),
              title: Text(category.$1),
              trailing: BarakahAmount(
                amount: -category.$2.toDouble(),
                showSign: false,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _YearlyReportTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      child: Column(
        children: [
          _buildYearlyChart(),
          const SizedBox(height: BarakahSpacing.lg),
          _buildYearlyStats(),
        ],
      ),
    );
  }

  Widget _buildYearlyChart() {
    final data = List.generate(
      12,
      (index) => BarData(
        label: [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ][index],
        value: [
          45000,
          38000,
          52000,
          41000,
          45000,
          48000,
          51000,
          44000,
          47000,
          43000,
          46000,
          50000
        ][index]
            .toDouble(),
        color: BarakahColors.primary,
      ),
    );

    return BarakahCard(
      child: BarakahBarChart(
        title: 'Monthly Expenses (2025)',
        data: data,
        maxValue: 55000,
      ),
    );
  }

  Widget _buildYearlyStats() {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yearly Statistics',
            style: BarakahTypography.subtitle1,
          ),
          const SizedBox(height: BarakahSpacing.md),
          _buildStatItem(
              'Total Income', 900000, Icons.arrow_upward, Colors.green),
          const Divider(),
          _buildStatItem(
              'Total Expenses', 550000, Icons.arrow_downward, Colors.red),
          const Divider(),
          _buildStatItem('Net Savings', 350000, Icons.savings, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BarakahSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(BarakahSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: BarakahSpacing.md),
          Expanded(
            child: Text(
              label,
              style: BarakahTypography.subtitle1,
            ),
          ),
          BarakahAmount(
            amount: amount,
            showSign: false,
          ),
        ],
      ),
    );
  }
}
