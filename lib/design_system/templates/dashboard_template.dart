import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../atoms/button.dart';
import '../atoms/base_components.dart';

/// Data class for account summary information
class AccountSummaryData {
  final String name;
  final double balance;
  final IconData icon;

  const AccountSummaryData({
    required this.name,
    required this.balance,
    required this.icon,
  });
}

/// Data class for transaction summary
class TransactionSummaryData {
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isExpense;

  const TransactionSummaryData({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
  });
}

/// Data class for budget progress
class BudgetProgressData {
  final String category;
  final double spent;
  final double limit;

  const BudgetProgressData({
    required this.category,
    required this.spent,
    required this.limit,
  });
}

/// A template for the dashboard screen that's business logic agnostic.
/// This template defines the UI structure and accepts callbacks for all interactions.
class DashboardTemplate extends StatelessWidget {
  final String userName;
  final double totalBalance;
  final List<AccountSummaryData> accounts;
  final List<TransactionSummaryData> recentTransactions;
  final List<BudgetProgressData> budgets;

  // Quick action callbacks
  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;
  final VoidCallback onTransfer;

  // Navigation callbacks
  final VoidCallback onViewAllTransactions;
  final VoidCallback onViewAllAccounts;
  final VoidCallback onViewAllBudgets;

  // Account interaction callbacks
  final Function(AccountSummaryData) onAccountTap;
  final Function(TransactionSummaryData) onTransactionTap;
  final Function(BudgetProgressData) onBudgetTap;

  const DashboardTemplate({
    super.key,
    required this.userName,
    required this.totalBalance,
    required this.accounts,
    required this.recentTransactions,
    required this.budgets,
    required this.onAddExpense,
    required this.onAddIncome,
    required this.onTransfer,
    required this.onViewAllTransactions,
    required this.onViewAllAccounts,
    required this.onViewAllBudgets,
    required this.onAccountTap,
    required this.onTransactionTap,
    required this.onBudgetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(BarakahSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: BarakahSpacing.lg),
              _buildQuickActions(),
              const SizedBox(height: BarakahSpacing.lg),
              _buildAccountsSection(),
              const SizedBox(height: BarakahSpacing.lg),
              _buildRecentTransactionsSection(),
              const SizedBox(height: BarakahSpacing.lg),
              _buildBudgetSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $userName',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: BarakahSpacing.sm),
        Text(
          'Total Balance',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          '\$${totalBalance.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionButton(
          icon: Icons.remove,
          label: 'Expense',
          onTap: onAddExpense,
        ),
        _QuickActionButton(
          icon: Icons.add,
          label: 'Income',
          onTap: onAddIncome,
        ),
        _QuickActionButton(
          icon: Icons.swap_horiz,
          label: 'Transfer',
          onTap: onTransfer,
        ),
      ],
    );
  }

  Widget _buildAccountsSection() {
    return _DashboardSection(
      title: 'Accounts',
      onViewAll: onViewAllAccounts,
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: accounts.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: BarakahSpacing.sm),
          itemBuilder: (context, index) {
            final account = accounts[index];
            return _AccountCard(
              account: account,
              onTap: () => onAccountTap(account),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsSection() {
    return _DashboardSection(
      title: 'Recent Transactions',
      onViewAll: onViewAllTransactions,
      child: Column(
        children: recentTransactions.take(5).map((transaction) {
          return _TransactionItem(
            transaction: transaction,
            onTap: () => onTransactionTap(transaction),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBudgetSection() {
    return _DashboardSection(
      title: 'Budgets',
      onViewAll: onViewAllBudgets,
      child: Column(
        children: budgets.take(3).map((budget) {
          return _BudgetProgressCard(
            budget: budget,
            onTap: () => onBudgetTap(budget),
          );
        }).toList(),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onTap,
      isOutlined: true,
      isSmall: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: BarakahSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _DashboardSection extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  final Widget child;

  const _DashboardSection({
    required this.title,
    required this.onViewAll,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: BarakahSpacing.sm),
        child,
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  final AccountSummaryData account;
  final VoidCallback onTap;

  const _AccountCard({
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(BarakahSpacing.md),
          width: 160,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(account.icon),
              const SizedBox(height: BarakahSpacing.sm),
              Text(
                account.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: BarakahSpacing.xs),
              Text(
                '\$${account.balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionSummaryData transaction;
  final VoidCallback onTap;

  const _TransactionItem({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor:
            transaction.isExpense ? Colors.red[100] : Colors.green[100],
        child: Icon(
          transaction.isExpense ? Icons.remove : Icons.add,
          color: transaction.isExpense ? Colors.red : Colors.green,
        ),
      ),
      title: Text(transaction.title),
      subtitle: Text(transaction.category),
      trailing: Text(
        transaction.isExpense
            ? '-\$${transaction.amount.toStringAsFixed(2)}'
            : '+\$${transaction.amount.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: transaction.isExpense ? Colors.red : Colors.green,
            ),
      ),
    );
  }
}

class _BudgetProgressCard extends StatelessWidget {
  final BudgetProgressData budget;
  final VoidCallback onTap;

  const _BudgetProgressCard({
    required this.budget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = budget.spent / budget.limit;
    final isOverBudget = progress > 1;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(BarakahSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    budget.category,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isOverBudget ? Colors.red : null,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: BarakahSpacing.sm),
              LinearProgressIndicator(
                value: progress.clamp(0, 1),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOverBudget ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: BarakahSpacing.xs),
              Text(
                '\$${budget.spent.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
