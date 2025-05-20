import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../atoms/base_components.dart';

/// Data class for account type summary
class AccountTypeSummaryData {
  final String type;
  final double total;
  final List<AccountData> accounts;
  final bool isPositiveBalance;

  const AccountTypeSummaryData({
    required this.type,
    required this.total,
    required this.accounts,
    required this.isPositiveBalance,
  });
}

/// Data class for individual account
class AccountData {
  final String name;
  final double balance;
  final IconData icon;
  final String institution;
  final String accountNumber;

  const AccountData({
    required this.name,
    required this.balance,
    required this.icon,
    required this.institution,
    required this.accountNumber,
  });
}

/// Sort options for accounts list
enum AccountSortOption {
  nameAsc,
  nameDesc,
  balanceAsc,
  balanceDesc,
  institution,
}

/// A template for the accounts screen that's business logic agnostic.
class AccountsTemplate extends StatelessWidget {
  final double netWorth;
  final DateTime asOfDate;
  final List<AccountTypeSummaryData> accountTypes;
  final Function(AccountData) onAccountTap;
  final VoidCallback onAddAccount;
  final Function(AccountSortOption) onSortChanged;
  final VoidCallback onInfoTap;

  const AccountsTemplate({
    super.key,
    required this.netWorth,
    required this.asOfDate,
    required this.accountTypes,
    required this.onAccountTap,
    required this.onAddAccount,
    required this.onSortChanged,
    required this.onInfoTap,
  });

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
        padding: const EdgeInsets.all(BarakahSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNetWorth(context),
            const SizedBox(height: BarakahSpacing.lg),
            ...accountTypes.map((type) => Column(
                  children: [
                    _buildAccountTypeSection(context, type),
                    const SizedBox(height: BarakahSpacing.md),
                  ],
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddAccount,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNetWorth(BuildContext context) {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Net Worth',
                style: BarakahTypography.caption,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: onInfoTap,
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.sm),
          Text(
            '\$${netWorth.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: netWorth >= 0 ? Colors.green : Colors.red,
                ),
          ),
          Text(
            'As of ${_formatDate(asOfDate)}',
            style: BarakahTypography.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeSection(
      BuildContext context, AccountTypeSummaryData type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(type.type, style: BarakahTypography.subtitle1),
            const SizedBox(width: BarakahSpacing.sm),
            Text(
              '\$${type.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: type.isPositiveBalance ? Colors.green : Colors.red,
                  ),
            ),
          ],
        ),
        const SizedBox(height: BarakahSpacing.sm),
        ...type.accounts.map((account) => _AccountCard(
              account: account,
              onTap: () => onAccountTap(account),
            )),
      ],
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: AccountSortOption.values
            .map((option) => ListTile(
                  title: Text(_getSortOptionLabel(option)),
                  onTap: () {
                    Navigator.pop(context);
                    onSortChanged(option);
                  },
                ))
            .toList(),
      ),
    );
  }

  String _getSortOptionLabel(AccountSortOption option) {
    switch (option) {
      case AccountSortOption.nameAsc:
        return 'Name (A to Z)';
      case AccountSortOption.nameDesc:
        return 'Name (Z to A)';
      case AccountSortOption.balanceAsc:
        return 'Balance (Low to High)';
      case AccountSortOption.balanceDesc:
        return 'Balance (High to Low)';
      case AccountSortOption.institution:
        return 'Institution';
    }
  }

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _AccountCard extends StatelessWidget {
  final AccountData account;
  final VoidCallback onTap;

  const _AccountCard({
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: BarakahSpacing.sm),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(account.icon),
        ),
        title: Text(account.name),
        subtitle: Text(account.institution),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${account.balance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: account.balance >= 0 ? Colors.green : Colors.red,
                  ),
            ),
            Text(
              'xxxx${account.accountNumber.substring(account.accountNumber.length - 4)}',
              style: BarakahTypography.caption,
            ),
          ],
        ),
      ),
    );
  }
}
