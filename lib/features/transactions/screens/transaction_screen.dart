import 'package:flutter/material.dart';
import 'package:barakah/design_system/templates/transaction_template.dart';
import 'package:barakah/design_system/molecules/entry_data.dart';

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

  // Transaction types with added double-entry options
  late List<TransactionTypeData> _transactionTypes;
  late TransactionTypeData _selectedType;

  // Form state
  DateTime _selectedDate = DateTime.now();
  String? _selectedAccount;
  String? _selectedToAccount;
  bool _isRecurring = false;
  String? _selectedFrequency;

  // Double-entry specific state
  List<EntryData> _entries = [];
  double _totalDebits = 0.0;
  double _totalCredits = 0.0;
  bool _isBalanced = false;

  // Lists for dropdowns
  // Removed categories as requested
  // Instead, we'll use accounts directly for better double-entry accounting

  final List<String> _accounts = [
    // Asset accounts (usually for receiving money)
    'Cash',
    'Bank Account',
    'Credit Card',
    'Savings Account',
    'Investment Account',

    // Islamic financial accounts
    'Zakat Fund',
    'Sadaqa Fund',

    // Asset accounts
    'Gold Assets',
    'Property Assets',
    'Vehicle Assets',

    // Liability accounts
    'Personal Loans',
    'Credit Card Debt',
    'Mortgage',
    'Business Capital',
    'Accounts Receivable',
    'Accounts Payable',

    // Income accounts (sources of income)
    'Salary Income',
    'Freelance Income',
    'Business Income',
    'Rental Income',
    'Investment Income',

    // Expense accounts (categories for expenses)
    'Food Expense',
    'Transportation Expense',
    'Utilities Expense',
    'Rent Expense',
    'Petrol Expense',
    'Charity Expense'
  ];

  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    _initializeTransactionTypes();
    _initializeEntries();

    // Set initial type based on arguments or default to expense
    final initialType = widget.arguments?['type'] as String?;
    _selectedType = _transactionTypes.firstWhere(
      (type) => type.label.toLowerCase() == (initialType ?? 'expense'),
      orElse: () => _transactionTypes[0],
    );
  }

  void _initializeTransactionTypes() {
    _transactionTypes = [
      // Standard transaction types with clearer FROM/TO labels
      TransactionTypeData(
        label: 'Expense',
        icon: Icons.arrow_downward,
        color: Colors.red,
        showCategory: false, // No need for categories, using accounts instead
        fromAccountLabel: 'FROM Account (Money Source)',
        toAccountLabel: 'INTO Expense Account',
        isTransfer: true, // Using transfer logic to show both accounts
      ),
      TransactionTypeData(
        label: 'Income',
        icon: Icons.arrow_upward,
        color: Colors.green,
        showCategory: false, // No need for categories, using accounts instead
        fromAccountLabel: 'INTO Account (Where to Deposit Money)',
        toAccountLabel: 'FROM Income Source Account',
        isTransfer: true, // Using transfer logic to show both accounts
      ),
      TransactionTypeData(
        label: 'Transfer',
        icon: Icons.compare_arrows,
        color: Colors.blue,
        showCategory: false,
        isTransfer: true,
        fromAccountLabel: 'FROM Account (Source)',
        toAccountLabel: 'TO Account (Destination)',
      ),

      // Double-entry transaction types
      TransactionTypeData(
        label: 'Custom',
        icon: Icons.edit_note,
        color: Colors.purple,
        isDoubleEntry: true,
        showCategory: false, // No categories
      ),
      TransactionTypeData(
        label: 'Zakat/Sadaqa',
        icon: Icons.volunteer_activism,
        color: Colors.green.shade700,
        isDoubleEntry: true,
        showCategory: false, // No categories
        // Preset entries for Zakat could be added here later
      ),
      TransactionTypeData(
        label: 'Asset Purchase',
        icon: Icons.home,
        color: Colors.amber.shade700,
        isDoubleEntry: true,
        showCategory: false, // No categories
        // Preset entries for Asset Purchase could be added here later
      ),
      TransactionTypeData(
        label: 'Liability',
        icon: Icons.account_balance,
        color: Colors.red.shade700,
        isDoubleEntry: true,
        showCategory: false, // No categories
        // Preset entries for Liability could be added here later
      ),
    ];
  }

  void _initializeEntries() {
    // Start with two empty entries (debit and credit)
    _entries = [
      EntryData(
        isDebit: true,
        amountController: TextEditingController(),
      ),
      EntryData(
        isDebit: false,
        amountController: TextEditingController(),
      ),
    ];
  }

  // We've removed categories

  void _addEntry() {
    setState(() {
      _entries.add(
        EntryData(
          isDebit:
              _entries.length % 2 == 0, // Alternate between debit and credit
          amountController: TextEditingController(),
        ),
      );
    });
  }

  void _removeEntry(int index) {
    setState(() {
      // Release the controller
      _entries[index].amountController.dispose();

      // Remove the entry
      _entries.removeAt(index);

      // Update balances
      _updateEntryTotals();
    });
  }

  void _onEntryAccountChanged(int index, String? accountId) {
    setState(() {
      _entries[index] = EntryData(
        accountId: accountId,
        isDebit: _entries[index].isDebit,
        amount: _entries[index].amount,
        amountController: _entries[index].amountController,
      );
    });
  }

  void _onEntryTypeChanged(int index, bool isDebit) {
    setState(() {
      _entries[index] = EntryData(
        accountId: _entries[index].accountId,
        isDebit: isDebit,
        amount: _entries[index].amount,
        amountController: _entries[index].amountController,
      );

      // Update balances
      _updateEntryTotals();
    });
  }

  void _onEntryAmountChanged(int index, String amount) {
    final parsedAmount = double.tryParse(amount) ?? 0.0;

    setState(() {
      _entries[index] = EntryData(
        accountId: _entries[index].accountId,
        isDebit: _entries[index].isDebit,
        amount: parsedAmount,
        amountController: _entries[index].amountController,
      );

      // Update balances
      _updateEntryTotals();
    });
  }

  void _updateEntryTotals() {
    double debits = 0.0;
    double credits = 0.0;

    for (final entry in _entries) {
      final amount = double.tryParse(entry.amountController.text) ?? 0.0;

      if (entry.isDebit) {
        debits += amount;
      } else {
        credits += amount;
      }
    }

    setState(() {
      _totalDebits = debits;
      _totalCredits = credits;
      _isBalanced = (debits - credits).abs() <
          0.001; // Allow for floating point imprecision
    });
  }

  void _onTypeChanged(TransactionTypeData type) {
    setState(() {
      _selectedType = type;
      // Reset accounts when type changes
      _selectedAccount = null;
      _selectedToAccount = null;

      // If switching to/from double-entry, initialize entries appropriately
      if (type.isDoubleEntry && _entries.isEmpty) {
        _initializeEntries();
      }

      // For specific transaction types, we can set default accounts
      if (type.label == 'Expense') {
        // For expense, we typically pay from cash/bank accounts
        _selectedAccount = _accounts.firstWhere(
          (account) => account == 'Cash',
          orElse: () => _accounts.first,
        );
        // Try to set a default expense account
        final expenseAccounts =
            _accounts.where((account) => account.contains('Expense')).toList();
        if (expenseAccounts.isNotEmpty) {
          _selectedToAccount = expenseAccounts.first;
        }
      } else if (type.label == 'Income') {
        // For income, we typically receive into cash/bank accounts
        _selectedAccount = _accounts.firstWhere(
          (account) => account == 'Bank Account',
          orElse: () => _accounts.first,
        );
        // Try to set a default income account
        final incomeAccounts =
            _accounts.where((account) => account.contains('Income')).toList();
        if (incomeAccounts.isNotEmpty) {
          _selectedToAccount = incomeAccounts.first;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TransactionTemplate(
      title: 'New Transaction',
      transactionTypes: _transactionTypes,
      selectedType: _selectedType,
      amountController: _amountController,
      selectedDate: _selectedDate,
      categories: [], // Empty list as we're not using categories
      selectedCategory: null, // No selected category
      accounts: _accounts,
      selectedAccount: _selectedAccount,
      selectedToAccount: _selectedToAccount,
      descriptionController: _descriptionController,
      isRecurring: _isRecurring,
      selectedFrequency: _selectedFrequency,
      frequencies: _frequencies,
      formKey: _formKey,

      // Double-entry specific properties
      entries: _entries,
      totalDebits: _totalDebits,
      totalCredits: _totalCredits,
      isBalanced: _isBalanced,
      onAddEntry: _addEntry,
      onRemoveEntry: _removeEntry,
      onEntryAccountChanged: _onEntryAccountChanged,
      onEntryTypeChanged: _onEntryTypeChanged,
      onEntryAmountChanged: _onEntryAmountChanged,

      // Standard callbacks
      onTypeChanged: _onTypeChanged,
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
        // Not using categories anymore
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
      // For double-entry transactions, ensure they're balanced
      if (_selectedType.isDoubleEntry && !_isBalanced) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Transaction is not balanced. Debits must equal credits.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

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

    // Dispose all entry controllers
    for (final entry in _entries) {
      entry.amountController.dispose();
    }

    super.dispose();
  }
}
