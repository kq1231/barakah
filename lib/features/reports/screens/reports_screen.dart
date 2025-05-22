import 'package:flutter/material.dart';
import 'package:barakah/design_system/atoms/constants.dart';
import 'package:barakah/design_system/atoms/base_components.dart';
import 'package:barakah/design_system/molecules/charts.dart';
import 'package:barakah/design_system/templates/reports_template.dart';

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
}

class _MonthlyReportTab extends StatefulWidget {
  @override
  State<_MonthlyReportTab> createState() => _MonthlyReportTabState();
}

class _MonthlyReportTabState extends State<_MonthlyReportTab> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(2025, 5); // Default to May 2025
  }

  @override
  Widget build(BuildContext context) {
    // Create sample data for the report
    final monthlyData = MonthlyReportData(
      income: 75000,
      expenses: 45000,
      dailyTransactions: _createSampleDailyTransactions(),
      topExpenses: _createSampleTopExpenses(),
    );

    return ReportsTemplate(
      selectedMonth: _selectedMonth,
      monthlyData: monthlyData,
      onPreviousMonth: () {
        setState(() {
          _selectedMonth = DateTime(
            _selectedMonth.year,
            _selectedMonth.month - 1,
          );
        });
      },
      onNextMonth: () {
        setState(() {
          _selectedMonth = DateTime(
            _selectedMonth.year,
            _selectedMonth.month + 1,
          );
        });
      },
      onExport: () => _exportReport(context),
      onCategoryTap: (category) {
        // Handle category tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category tapped: ${category.category}')),
        );
      },
    );
  }

  List<DailyTransactionData> _createSampleDailyTransactions() {
    // Sample data for daily transactions in the current month
    final daysInMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final random = [
      3000.0,
      2500.0,
      4000.0,
      1500.0,
      3500.0,
      5000.0,
      2000.0,
      2800.0
    ];

    return List.generate(
      daysInMonth,
      (index) => DailyTransactionData(
        date: DateTime(_selectedMonth.year, _selectedMonth.month, index + 1),
        amount: random[index % random.length],
      ),
    );
  }

  List<CategoryExpenseData> _createSampleTopExpenses() {
    return [
      CategoryExpenseData(
        category: 'Shopping',
        amount: 15000,
        percentage: 15000 / 45000,
      ),
      CategoryExpenseData(
        category: 'Transport',
        amount: 12000,
        percentage: 12000 / 45000,
      ),
      CategoryExpenseData(
        category: 'Food',
        amount: 10000,
        percentage: 10000 / 45000,
      ),
      CategoryExpenseData(
        category: 'Bills',
        amount: 8000,
        percentage: 8000 / 45000,
      ),
    ];
  }

  void _exportReport(BuildContext context) {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting report...')),
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
