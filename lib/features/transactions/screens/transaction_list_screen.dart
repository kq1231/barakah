import 'package:flutter/material.dart';
import 'package:barakah/design_system/templates/transaction_list_template.dart';
import 'transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  TransactionFilterOption _currentFilter = TransactionFilterOption.all;
  TransactionSortOption _currentSort = TransactionSortOption.dateDesc;
  DateTime? _startDate;
  DateTime? _endDate;

  // Mock data for transactions
  final List<TransactionListItemData> _allTransactions = [
    TransactionListItemData(
      id: 1,
      title: 'Grocery Shopping',
      category: 'Food',
      amount: 120.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      accountName: 'Cash',
      isExpense: true,
      categoryIcon: Icons.shopping_basket,
    ),
    TransactionListItemData(
      id: 2,
      title: 'Salary Deposit',
      category: 'Income',
      amount: 3500.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      accountName: 'Bank Account',
      isExpense: false,
      categoryIcon: Icons.work,
    ),
    TransactionListItemData(
      id: 3,
      title: 'Electricity Bill',
      category: 'Utilities',
      amount: 85.20,
      date: DateTime.now().subtract(const Duration(days: 3)),
      accountName: 'Credit Card',
      isExpense: true,
      categoryIcon: Icons.bolt,
    ),
    TransactionListItemData(
      id: 4,
      title: 'Transfer to Savings',
      category: 'Transfer',
      amount: 500.00,
      date: DateTime.now().subtract(const Duration(days: 5)),
      accountName: 'Bank Account',
      isExpense: true,
      categoryIcon: Icons.compare_arrows,
    ),
    TransactionListItemData(
      id: 5,
      title: 'Freelance Work',
      category: 'Income',
      amount: 750.00,
      date: DateTime.now().subtract(const Duration(days: 7)),
      accountName: 'Bank Account',
      isExpense: false,
      categoryIcon: Icons.laptop,
    ),
    TransactionListItemData(
      id: 6,
      title: 'Restaurant Dinner',
      category: 'Food',
      amount: 95.80,
      date: DateTime.now().subtract(const Duration(days: 8)),
      accountName: 'Credit Card',
      isExpense: true,
      categoryIcon: Icons.restaurant,
    ),
    TransactionListItemData(
      id: 7,
      title: 'Mobile Phone Bill',
      category: 'Utilities',
      amount: 65.00,
      date: DateTime.now().subtract(const Duration(days: 10)),
      accountName: 'Bank Account',
      isExpense: true,
      categoryIcon: Icons.phone_android,
    ),
    TransactionListItemData(
      id: 8,
      title: 'Bonus Payment',
      category: 'Income',
      amount: 1200.00,
      date: DateTime.now().subtract(const Duration(days: 15)),
      accountName: 'Bank Account',
      isExpense: false,
      categoryIcon: Icons.monetization_on,
    ),
  ];

  List<TransactionListItemData> get _filteredTransactions {
    var transactions = List<TransactionListItemData>.from(_allTransactions);

    // Apply filters
    switch (_currentFilter) {
      case TransactionFilterOption.expense:
        transactions = transactions
            .where((t) => t.isExpense && t.category != 'Transfer')
            .toList();
        break;
      case TransactionFilterOption.income:
        transactions = transactions.where((t) => !t.isExpense).toList();
        break;
      case TransactionFilterOption.transfer:
        transactions =
            transactions.where((t) => t.category == 'Transfer').toList();
        break;
      case TransactionFilterOption.dateRange:
        if (_startDate != null && _endDate != null) {
          transactions = transactions
              .where((t) =>
                  t.date
                      .isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                  t.date.isBefore(_endDate!.add(const Duration(days: 1))))
              .toList();
        }
        break;
      case TransactionFilterOption.all:
      default:
        // No filter
        break;
    }

    // Apply sorting
    switch (_currentSort) {
      case TransactionSortOption.dateAsc:
        transactions.sort((a, b) => a.date.compareTo(b.date));
        break;
      case TransactionSortOption.amountDesc:
        transactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case TransactionSortOption.amountAsc:
        transactions.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case TransactionSortOption.category:
        transactions.sort((a, b) => a.category.compareTo(b.category));
        break;
      case TransactionSortOption.dateDesc:
      default:
        transactions.sort((a, b) => b.date.compareTo(a.date));
        break;
    }

    return transactions;
  }

  double get _totalIncome {
    return _filteredTransactions
        .where((t) => !t.isExpense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get _totalExpense {
    return _filteredTransactions
        .where((t) => t.isExpense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _filteredTransactions;

    return TransactionListTemplate(
      title: 'Transactions',
      transactions: filteredTransactions,
      startDate: _startDate,
      endDate: _endDate,
      currentFilter: _currentFilter,
      currentSort: _currentSort,
      totalIncome: _totalIncome,
      totalExpense: _totalExpense,
      onAddTransaction: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TransactionScreen(),
          ),
        );
      },
      onTransactionTap: (transaction) {
        // In a real app, navigate to transaction details or edit screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${transaction.title}')),
        );
      },
      onFilterChanged: (filter) {
        setState(() {
          _currentFilter = filter;
        });
      },
      onSortChanged: (sort) {
        setState(() {
          _currentSort = sort;
        });
      },
      onDateRangeSelected: () async {
        final dateRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: _startDate != null && _endDate != null
              ? DateTimeRange(start: _startDate!, end: _endDate!)
              : null,
        );

        if (dateRange != null) {
          setState(() {
            _startDate = dateRange.start;
            _endDate = dateRange.end;
            _currentFilter = TransactionFilterOption.dateRange;
          });
        }
      },
      onExport: () {
        // In a real app, implement export functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export functionality would be implemented here'),
          ),
        );
      },
    );
  }
}
