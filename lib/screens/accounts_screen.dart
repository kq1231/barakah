import 'package:flutter/material.dart';
import '../design_system/templates/accounts_template.dart';
import 'account_detail_screen.dart';
import 'add_account_screen.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - in a real app, this would come from a data layer
    final assetAccounts = [
      AccountData(
        name: 'Cash',
        balance: 50000,
        icon: Icons.money,
        institution: 'Personal',
        accountNumber: 'CASH-001',
      ),
      AccountData(
        name: 'Bank Account',
        balance: 150000,
        icon: Icons.account_balance,
        institution: 'HBL Bank',
        accountNumber: 'XXXX-5678',
      ),
      AccountData(
        name: 'Investments',
        balance: 300000,
        icon: Icons.trending_up,
        institution: 'PSX',
        accountNumber: 'INV-1234',
      ),
    ];

    final liabilityAccounts = [
      AccountData(
        name: 'Credit Card',
        balance: 25000,
        icon: Icons.credit_card,
        institution: 'HBL Bank',
        accountNumber: 'XXXX-9012',
      ),
      AccountData(
        name: 'Auto Loan',
        balance: 25000,
        icon: Icons.directions_car,
        institution: 'Meezan Bank',
        accountNumber: 'LOAN-7890',
      ),
    ];

    final accountTypes = [
      AccountTypeSummaryData(
        type: 'Assets',
        total: 500000, // Sum of all asset balances
        accounts: assetAccounts,
        isPositiveBalance: true,
      ),
      AccountTypeSummaryData(
        type: 'Liabilities',
        total: 50000, // Sum of all liability balances
        accounts: liabilityAccounts,
        isPositiveBalance: false,
      ),
    ];

    return AccountsTemplate(
      netWorth: 450000, // Assets - Liabilities
      asOfDate: DateTime.now(),
      accountTypes: accountTypes,
      onAccountTap: (account) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AccountDetailScreen(
              accountName: account.name,
              balance: account.balance,
            ),
          ),
        );
      },
      onAddAccount: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddAccountScreen(),
          ),
        );
      },
      onSortChanged: (sortOption) {
        // In a real app, you would re-sort the accounts based on the selected option
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Sorting by: ${_getSortOptionLabel(sortOption)}')),
        );
      },
      onInfoTap: () {
        // Show info about net worth calculation
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Net Worth'),
            content: const Text(
              'Net worth is calculated as the sum of all assets minus liabilities. It represents your overall financial position.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
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
}
