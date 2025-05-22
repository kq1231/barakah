import 'package:flutter/material.dart';
import '../atoms/constants.dart';

/// Data class for transaction list item
class TransactionListItemData {
  final int id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final String accountName;
  final bool isExpense;
  final IconData categoryIcon;

  const TransactionListItemData({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.accountName,
    required this.isExpense,
    required this.categoryIcon,
  });
}

/// Filter options for transaction list
enum TransactionFilterOption {
  all,
  expense,
  income,
  transfer,
  dateRange,
}

/// Sort options for transaction list
enum TransactionSortOption {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc,
  category,
}

/// A template for the transaction list screen that's business logic agnostic.
class TransactionListTemplate extends StatelessWidget {
  final String title;
  final List<TransactionListItemData> transactions;
  final DateTime? startDate;
  final DateTime? endDate;
  final TransactionFilterOption currentFilter;
  final TransactionSortOption currentSort;
  final double totalIncome;
  final double totalExpense;

  // Callbacks
  final VoidCallback onAddTransaction;
  final Function(TransactionListItemData) onTransactionTap;
  final Function(TransactionFilterOption) onFilterChanged;
  final Function(TransactionSortOption) onSortChanged;
  final VoidCallback onDateRangeSelected;
  final VoidCallback onExport;

  const TransactionListTemplate({
    super.key,
    required this.title,
    required this.transactions,
    this.startDate,
    this.endDate,
    required this.currentFilter,
    required this.currentSort,
    required this.totalIncome,
    required this.totalExpense,
    required this.onAddTransaction,
    required this.onTransactionTap,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onDateRangeSelected,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: onDateRangeSelected,
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: onExport,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(context),
          Expanded(
            child: transactions.isEmpty
                ? _buildEmptyState()
                : _buildTransactionList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTransaction,
        heroTag: 'transaction_add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(BarakahSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(BarakahSpacing.md),
        child: Column(
          children: [
            if (startDate != null && endDate != null)
              Padding(
                padding: const EdgeInsets.only(bottom: BarakahSpacing.sm),
                child: Text(
                  '${_formatDate(startDate!)} - ${_formatDate(endDate!)}',
                  style: BarakahTypography.caption,
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Income',
                    totalIncome,
                    Icons.arrow_upward,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: BarakahSpacing.md),
                Expanded(
                  child: _buildSummaryItem(
                    'Expense',
                    totalExpense,
                    Icons.arrow_downward,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: BarakahSpacing.md),
                Expanded(
                  child: _buildSummaryItem(
                    'Balance',
                    totalIncome - totalExpense,
                    Icons.balance,
                    (totalIncome - totalExpense) >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      String label, double amount, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: BarakahTypography.caption,
        ),
        const SizedBox(height: BarakahSpacing.xs),
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: BarakahSpacing.xs),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
          const SizedBox(height: BarakahSpacing.md),
          Text(
            'No transactions found',
            style: BarakahTypography.headline3,
          ),
          const SizedBox(height: BarakahSpacing.sm),
          Text(
            'Tap + to add your first transaction',
            style: BarakahTypography.body1,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.separated(
      padding: const EdgeInsets.all(BarakahSpacing.md),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionItem(transaction);
      },
      separatorBuilder: (context, index) =>
          const SizedBox(height: BarakahSpacing.sm),
    );
  }

  Widget _buildTransactionItem(TransactionListItemData transaction) {
    return Card(
      child: InkWell(
        onTap: () => onTransactionTap(transaction),
        child: Padding(
          padding: const EdgeInsets.all(BarakahSpacing.md),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: transaction.isExpense
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  transaction.categoryIcon,
                  color: transaction.isExpense ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(width: BarakahSpacing.md),
              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: BarakahTypography.subtitle1,
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    Text(
                      '${transaction.category} • ${transaction.accountName}',
                      style: BarakahTypography.caption,
                    ),
                  ],
                ),
              ),
              // Amount and date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: transaction.isExpense ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: BarakahSpacing.xs),
                  Text(
                    _formatDate(transaction.date),
                    style: BarakahTypography.caption,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All Transactions'),
            leading: const Icon(Icons.all_inclusive),
            selected: currentFilter == TransactionFilterOption.all,
            onTap: () {
              onFilterChanged(TransactionFilterOption.all);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Expenses Only'),
            leading: const Icon(Icons.arrow_downward),
            selected: currentFilter == TransactionFilterOption.expense,
            onTap: () {
              onFilterChanged(TransactionFilterOption.expense);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Income Only'),
            leading: const Icon(Icons.arrow_upward),
            selected: currentFilter == TransactionFilterOption.income,
            onTap: () {
              onFilterChanged(TransactionFilterOption.income);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Transfers Only'),
            leading: const Icon(Icons.compare_arrows),
            selected: currentFilter == TransactionFilterOption.transfer,
            onTap: () {
              onFilterChanged(TransactionFilterOption.transfer);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Date Range'),
            leading: const Icon(Icons.date_range),
            selected: currentFilter == TransactionFilterOption.dateRange,
            onTap: () {
              onFilterChanged(TransactionFilterOption.dateRange);
              Navigator.pop(context);
              onDateRangeSelected();
            },
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Date (Newest First)'),
            leading: const Icon(Icons.arrow_downward),
            selected: currentSort == TransactionSortOption.dateDesc,
            onTap: () {
              onSortChanged(TransactionSortOption.dateDesc);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Date (Oldest First)'),
            leading: const Icon(Icons.arrow_upward),
            selected: currentSort == TransactionSortOption.dateAsc,
            onTap: () {
              onSortChanged(TransactionSortOption.dateAsc);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Amount (Highest First)'),
            leading: const Icon(Icons.arrow_downward),
            selected: currentSort == TransactionSortOption.amountDesc,
            onTap: () {
              onSortChanged(TransactionSortOption.amountDesc);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Amount (Lowest First)'),
            leading: const Icon(Icons.arrow_upward),
            selected: currentSort == TransactionSortOption.amountAsc,
            onTap: () {
              onSortChanged(TransactionSortOption.amountAsc);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Category'),
            leading: const Icon(Icons.category),
            selected: currentSort == TransactionSortOption.category,
            onTap: () {
              onSortChanged(TransactionSortOption.category);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
