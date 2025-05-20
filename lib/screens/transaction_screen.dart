import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../design_system/atoms/constants.dart';
import '../design_system/atoms/button.dart';
import '../design_system/atoms/base_components.dart';

enum TransactionType {
  expense('Expense', Icons.arrow_downward, Colors.red),
  income('Income', Icons.arrow_upward, Colors.green),
  transfer('Transfer', Icons.compare_arrows, Colors.blue),
  asset('Asset', Icons.real_estate_agent, Colors.purple),
  liability('Liability', Icons.credit_card, Colors.orange),
  capital('Capital', Icons.account_balance, Colors.indigo);

  final String label;
  final IconData icon;
  final Color color;

  const TransactionType(this.label, this.icon, this.color);
}

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String? _selectedAccount;
  String? _selectedToAccount;
  TransactionType _selectedType = TransactionType.expense;
  bool _isRecurring = false;
  String? _selectedFrequency;

  List<String> get _categories {
    switch (_selectedType) {
      case TransactionType.expense:
        return [
          'Transport',
          'Food',
          'Shopping',
          'Bills',
          'Entertainment',
          'Others'
        ];
      case TransactionType.income:
        return ['Salary', 'Business', 'Investment', 'Rental', 'Other Income'];
      case TransactionType.asset:
        return [
          'Property',
          'Vehicles',
          'Investments',
          'Equipment',
          'Other Assets'
        ];
      case TransactionType.liability:
        return ['Loans', 'Credit Cards', 'Mortgages', 'Other Liabilities'];
      case TransactionType.capital:
        return [
          'Owner Investment',
          'Owner Drawing',
          'Retained Earnings',
          'Other Capital'
        ];
      case TransactionType.transfer:
        return [];
    }
  }

  final List<String> _accounts = [
    'Cash',
    'Bank Account',
    'Credit Card',
    'Savings Account'
  ];

  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BarakahSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTypeSelector(),
                const SizedBox(height: BarakahSpacing.lg),
                _buildAmountInput(),
                const SizedBox(height: BarakahSpacing.lg),
                _buildDatePicker(),
                const SizedBox(height: BarakahSpacing.lg),
                _buildCategoryDropdown(),
                const SizedBox(height: BarakahSpacing.lg),
                _buildAccountSelection(),
                const SizedBox(height: BarakahSpacing.lg),
                _buildRecurringSection(),
                const SizedBox(height: BarakahSpacing.lg),
                _buildDescriptionInput(),
                const SizedBox(height: BarakahSpacing.xl),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TransactionType.values.map((type) {
          final isSelected = type == _selectedType;
          return Padding(
            padding: const EdgeInsets.only(right: BarakahSpacing.sm),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    type.icon,
                    color: isSelected ? Colors.white : type.color,
                    size: 18,
                  ),
                  const SizedBox(width: BarakahSpacing.xs),
                  Text(type.label),
                ],
              ),
              selected: isSelected,
              selectedColor: type.color,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedType = type);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAmountInput() {
    return BarakahCard(
      child: TextFormField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: BarakahTypography.headline1.copyWith(
          color: _selectedType.color,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixText: 'PKR ',
          hintText: '0.00',
          prefixIcon: Icon(_selectedType.icon, color: _selectedType.color),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an amount';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return BarakahCard(
      child: InkWell(
        onTap: () async {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: BarakahSpacing.sm),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: BarakahColors.primary),
              const SizedBox(width: BarakahSpacing.md),
              Text(
                DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                style: BarakahTypography.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    if (_selectedType == TransactionType.transfer)
      return const SizedBox.shrink();

    return BarakahCard(
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.category, color: BarakahColors.primary),
          hintText: 'Select Category',
        ),
        items: _categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedCategory = value);
        },
        validator: (value) {
          if (_selectedType != TransactionType.transfer &&
              (value == null || value.isEmpty)) {
            return 'Please select a category';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAccountSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BarakahCard(
          child: DropdownButtonFormField<String>(
            value: _selectedAccount,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.account_balance_wallet,
                color: BarakahColors.primary,
              ),
              hintText: _selectedType == TransactionType.transfer
                  ? 'From Account'
                  : 'Select Account',
            ),
            items: _accounts.map((account) {
              return DropdownMenuItem(
                value: account,
                child: Text(account),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedAccount = value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an account';
              }
              return null;
            },
          ),
        ),
        if (_selectedType == TransactionType.transfer) ...[
          const SizedBox(height: BarakahSpacing.md),
          BarakahCard(
            child: DropdownButtonFormField<String>(
              value: _selectedToAccount,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.account_balance_wallet,
                  color: BarakahColors.primary,
                ),
                hintText: 'To Account',
              ),
              items: _accounts
                  .where((account) => account != _selectedAccount)
                  .map((account) {
                return DropdownMenuItem(
                  value: account,
                  child: Text(account),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedToAccount = value);
              },
              validator: (value) {
                if (_selectedType == TransactionType.transfer &&
                    (value == null || value.isEmpty)) {
                  return 'Please select destination account';
                }
                return null;
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRecurringSection() {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Recurring Transaction'),
            value: _isRecurring,
            onChanged: (value) {
              setState(() => _isRecurring = value);
            },
          ),
          if (_isRecurring) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(BarakahSpacing.sm),
              child: DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.repeat, color: BarakahColors.primary),
                  hintText: 'Select Frequency',
                ),
                items: _frequencies.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(frequency),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedFrequency = value);
                },
                validator: (value) {
                  if (_isRecurring && (value == null || value.isEmpty)) {
                    return 'Please select frequency';
                  }
                  return null;
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return BarakahCard(
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Add a note (optional)',
          prefixIcon: Icon(Icons.note_alt, color: BarakahColors.primary),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BarakahButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
          ),
        ),
        const SizedBox(width: BarakahSpacing.md),
        Expanded(
          child: BarakahButton(
            label: 'Save',
            onPressed: _saveTransaction,
          ),
        ),
      ],
    );
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      // Add transaction saving logic here
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
