import 'package:flutter/material.dart';
import '../design_system/atoms/constants.dart';
import '../design_system/atoms/base_components.dart';
import 'account_detail_screen.dart';
import 'add_account_screen.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortOptions(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BarakahSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalBalance(),
              const SizedBox(height: BarakahSpacing.lg),
              _buildAccountTypeSection(context, 'Assets', true),
              const SizedBox(height: BarakahSpacing.md),
              _buildAccountTypeSection(context, 'Liabilities', false),
              const SizedBox(height: BarakahSpacing.md),
              _buildAccountTypeSection(context, 'Equity', false),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddAccountScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTotalBalance() {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Worth',
            style: BarakahTypography.caption,
          ),
          const SizedBox(height: BarakahSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PKR 450,000',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'As of ${DateTime.now().day} ${_getMonthName(DateTime.now().month)}',
                      style: BarakahTypography.caption,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeSection(
      BuildContext context, String title, bool isExpanded) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: BarakahTypography.subtitle1),
            const SizedBox(width: BarakahSpacing.sm),
            Text(
              'PKR ${title == "Assets" ? "500,000" : title == "Liabilities" ? "50,000" : "450,000"}',
              style: BarakahTypography.caption,
            ),
          ],
        ),
        const SizedBox(height: BarakahSpacing.sm),
        if (isExpanded) ..._buildAccountList(context),
      ],
    );
  }

  List<Widget> _buildAccountList(BuildContext context) {
    final accounts = [
      ('Cash', 25000.0, Icons.money),
      ('Bank Account', 400000.0, Icons.account_balance),
      ('Credit Card', -15000.0, Icons.credit_card),
    ];

    return accounts.map((account) {
      return Padding(
        padding: const EdgeInsets.only(bottom: BarakahSpacing.sm),
        child: BarakahCard(
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AccountDetailScreen(
                  accountName: account.$1,
                  balance: account.$2,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(BarakahSpacing.md),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(BarakahSpacing.sm),
                    decoration: BoxDecoration(
                      color: BarakahColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(account.$3, color: BarakahColors.primary),
                  ),
                  const SizedBox(width: BarakahSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(account.$1, style: BarakahTypography.subtitle1),
                        const SizedBox(height: BarakahSpacing.xs),
                        BarakahAmount(
                          amount: account.$2,
                          showSign: false,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: BarakahColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
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

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.sort_by_alpha),
            title: const Text('Sort by Name'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.sort),
            title: const Text('Sort by Balance'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Sort by Last Used'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
