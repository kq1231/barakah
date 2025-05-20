import 'package:flutter/material.dart';
import '../design_system/atoms/constants.dart';
import '../design_system/atoms/button.dart';
import '../design_system/atoms/base_components.dart';
import '../design_system/molecules/list_items.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

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
            _BudgetOverviewTab(),
            _BudgetCategoriesTab(),
          ],
        ),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
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
              onChanged: (value) {},
            ),
            const SizedBox(height: BarakahSpacing.md),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.money),
                prefixText: 'PKR ',
              ),
              keyboardType: TextInputType.number,
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

class _BudgetOverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(BarakahSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthlyOverview(),
            const SizedBox(height: BarakahSpacing.lg),
            Text(
              'Categories',
              style: BarakahTypography.headline2,
            ),
            const SizedBox(height: BarakahSpacing.md),
            _buildCategoriesList(),
          ],
        ),
      ),
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
                      'Total Budget',
                      style: BarakahTypography.caption,
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    const Text(
                      'PKR 100,000',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spent',
                      style: BarakahTypography.caption,
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    const BarakahAmount(
                      amount: -65000,
                      showSign: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.md),
          const BarakahProgressBar(
            value: 0.65,
            color: BarakahColors.primary,
          ),
          const SizedBox(height: BarakahSpacing.sm),
          Text(
            '35% remaining',
            style: BarakahTypography.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Column(
      children: [
        BudgetProgressCard(
          category: 'Food',
          spent: 25000,
          total: 30000,
          color: BarakahColors.success,
        ),
        const SizedBox(height: BarakahSpacing.sm),
        BudgetProgressCard(
          category: 'Transport',
          spent: 15000,
          total: 20000,
          color: BarakahColors.warning,
        ),
        const SizedBox(height: BarakahSpacing.sm),
        BudgetProgressCard(
          category: 'Shopping',
          spent: 25000,
          total: 50000,
          color: BarakahColors.info,
        ),
      ],
    );
  }
}

class _BudgetCategoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      itemCount: 6,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(BarakahSpacing.sm),
            decoration: BoxDecoration(
              color: BarakahColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.category, color: BarakahColors.primary),
          ),
          title: Text(
            [
              'Food',
              'Transport',
              'Shopping',
              'Bills',
              'Entertainment',
              'Others'
            ][index],
            style: BarakahTypography.subtitle1,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        );
      },
    );
  }
}
