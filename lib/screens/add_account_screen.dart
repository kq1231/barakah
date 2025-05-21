import 'package:flutter/material.dart';
import '../design_system/atoms/constants.dart';
import '../design_system/atoms/button.dart';
import '../design_system/atoms/base_components.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _openingBalanceController = TextEditingController();
  String _selectedType = 'Asset';
  String? _selectedParentAccount;

  final List<String> _accountTypes = [
    'Asset',
    'Liability',
    'Equity',
    'Income',
    'Expense',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(BarakahSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAccountTypeSelector(),
              const SizedBox(height: BarakahSpacing.lg),
              _buildNameInput(),
              const SizedBox(height: BarakahSpacing.lg),
              if (_selectedType != 'Equity') _buildParentAccountDropdown(),
              if (_selectedType != 'Equity')
                const SizedBox(height: BarakahSpacing.lg),
              _buildOpeningBalanceInput(),
              const SizedBox(height: BarakahSpacing.xl),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type',
          style: BarakahTypography.subtitle1,
        ),
        const SizedBox(height: BarakahSpacing.sm),
        Wrap(
          spacing: BarakahSpacing.sm,
          children: _accountTypes.map((type) {
            final isSelected = type == _selectedType;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedType = type);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNameInput() {
    return BarakahCard(
      child: TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Account Name',
          prefixIcon: Icon(Icons.account_balance, color: BarakahColors.primary),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter an account name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildParentAccountDropdown() {
    // Mock parent accounts based on type
    final parentAccounts = [
      'Cash',
      'Bank Accounts',
      'Credit Cards',
      if (_selectedType == 'Asset') 'Current Assets',
      if (_selectedType == 'Liability') 'Long Term Liabilities',
    ];

    return BarakahCard(
      child: DropdownButtonFormField<String>(
        value: _selectedParentAccount,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Parent Account (Optional)',
          prefixIcon: Icon(Icons.account_tree, color: BarakahColors.primary),
        ),
        items: parentAccounts.map((account) {
          return DropdownMenuItem(
            value: account,
            child: Text(account),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedParentAccount = value);
        },
      ),
    );
  }

  Widget _buildOpeningBalanceInput() {
    return BarakahCard(
      child: TextFormField(
        controller: _openingBalanceController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Opening Balance',
          prefixText: 'PKR ',
          prefixIcon: Icon(Icons.money, color: BarakahColors.primary),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter an opening balance';
          }
          if (double.tryParse(value!) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildActionButtons() {
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
            label: 'Create',
            onPressed: _createAccount,
          ),
        ),
      ],
    );
  }

  void _createAccount() {
    if (_formKey.currentState?.validate() ?? false) {
      // Add account creation logic here
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }
}
