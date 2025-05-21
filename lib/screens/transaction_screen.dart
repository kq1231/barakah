import 'package:flutter/material.dart';
import '../design_system/templates/transaction_template.dart';

class TransactionScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const TransactionScreen({super.key, this.arguments});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Transaction types
  late List<TransactionTypeData> _transactionTypes;
  late TransactionTypeData _selectedType;

  // Form state
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String? _selectedAccount;
  String? _selectedToAccount;
  bool _isRecurring = false;
  String? _selectedFrequency;

  // Lists for dropdowns
  final List<String> _expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Others'
  ];

  final List<String> _incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Rental',
    'Other Income'
  ];

  final List<String> _accounts = [
    'Cash',
    'Bank Account',
    'Credit Card',
    'Savings Account'
  ];

  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _transactionTypes = [
      TransactionTypeData(
        label: 'Expense',
        icon: Icons.arrow_downward,
        color: Colors.red,
      ),
      TransactionTypeData(
        label: 'Income',
        icon: Icons.arrow_upward,
        color: Colors.green,
      ),
      TransactionTypeData(
        label: 'Transfer',
        icon: Icons.compare_arrows,
        color: Colors.blue,
        showCategory: false,
        isTransfer: true,
      ),
    ];

    // Set initial type based on arguments or default to expense
    final initialType = widget.arguments?['type'] as String?;
    _selectedType = _transactionTypes.firstWhere(
      (type) => type.label.toLowerCase() == (initialType ?? 'expense'),
      orElse: () => _transactionTypes[0],
    );
  }

  // Get categories based on transaction type
  List<String> get _categories {
    if (_selectedType.label == 'Expense') {
      return _expenseCategories;
    } else if (_selectedType.label == 'Income') {
      return _incomeCategories;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return TransactionTemplate(
      title: 'New Transaction',
      transactionTypes: _transactionTypes,
      selectedType: _selectedType,
      amountController: _amountController,
      selectedDate: _selectedDate,
      categories: _categories,
      selectedCategory: _selectedCategory,
      accounts: _accounts,
      selectedAccount: _selectedAccount,
      selectedToAccount: _selectedToAccount,
      descriptionController: _descriptionController,
      isRecurring: _isRecurring,
      selectedFrequency: _selectedFrequency,
      frequencies: _frequencies,
      formKey: _formKey,
      onTypeChanged: (type) {
        setState(() {
          _selectedType = type;
          // Reset category when type changes
          _selectedCategory = null;
        });
      },
      onDateTapped: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      onCategoryChanged: (category) {
        setState(() => _selectedCategory = category);
      },
      onAccountChanged: (account) {
        setState(() {
          _selectedAccount = account;
          // Reset destination if same as source
          if (_selectedToAccount == account) {
            _selectedToAccount = null;
          }
        });
      },
      onToAccountChanged: (account) {
        setState(() => _selectedToAccount = account);
      },
      onRecurringChanged: (isRecurring) {
        setState(() {
          _isRecurring = isRecurring;
          if (!isRecurring) {
            _selectedFrequency = null;
          }
        });
      },
      onFrequencyChanged: (frequency) {
        setState(() => _selectedFrequency = frequency);
      },
      onSave: _saveTransaction,
      onCancel: () => Navigator.pop(context),
    );
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      // Add transaction saving logic here

      // Show success message and pop
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
