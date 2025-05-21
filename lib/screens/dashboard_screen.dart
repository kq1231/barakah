import 'package:flutter/material.dart';
import '../design_system/templates/dashboard_template.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardTemplate(
      userName: 'Abdullah', // Mock data - replace with actual user name
      totalBalance: 150000,
      accounts: [
        AccountSummaryData(
          name: 'Cash',
          balance: 50000,
          icon: Icons.account_balance_wallet,
        ),
        AccountSummaryData(
          name: 'Bank Account',
          balance: 100000,
          icon: Icons.account_balance,
        ),
      ],
      recentTransactions: [
        TransactionSummaryData(
          title: 'Groceries',
          category: 'Food',
          amount: 2500,
          date: DateTime.now(),
          isExpense: true,
        ),
        TransactionSummaryData(
          title: 'Salary',
          category: 'Income',
          amount: 75000,
          date: DateTime.now().subtract(const Duration(days: 1)),
          isExpense: false,
        ),
      ],
      budgets: [
        BudgetProgressData(
          category: 'Transport',
          spent: 8000,
          limit: 10000,
        ),
        BudgetProgressData(
          category: 'Groceries',
          spent: 15000,
          limit: 20000,
        ),
        BudgetProgressData(
          category: 'Entertainment',
          spent: 4500,
          limit: 5000,
        ),
      ],
      onAddExpense: () {
        Navigator.pushNamed(context, '/transaction',
            arguments: {'type': 'expense'});
      },
      onAddIncome: () {
        Navigator.pushNamed(context, '/transaction',
            arguments: {'type': 'income'});
      },
      onTransfer: () {
        Navigator.pushNamed(context, '/transaction',
            arguments: {'type': 'transfer'});
      },
      onViewAllTransactions: () {
        Navigator.pushNamed(context, '/transactions');
      },
      onViewAllAccounts: () {
        Navigator.pushNamed(context, '/accounts');
      },
      onViewAllBudgets: () {
        Navigator.pushNamed(context, '/budgets');
      },
      onAccountTap: (account) {
        Navigator.pushNamed(
          context,
          '/account/detail',
          arguments: {'name': account.name, 'balance': account.balance},
        );
      },
      onTransactionTap: (transaction) {
        Navigator.pushNamed(
          context,
          '/transaction/detail',
          arguments: {
            'title': transaction.title,
            'amount': transaction.amount,
            'category': transaction.category,
            'date': transaction.date,
          },
        );
      },
      onBudgetTap: (budget) {
        Navigator.pushNamed(
          context,
          '/budget/detail',
          arguments: {
            'category': budget.category,
            'spent': budget.spent,
            'limit': budget.limit,
          },
        );
      },
    );
  }
}
