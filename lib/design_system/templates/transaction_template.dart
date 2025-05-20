import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../atoms/button.dart';
import '../atoms/base_components.dart';

/// A template for transaction-related screens that's business logic agnostic.
/// This template defines the UI structure and accepts callbacks for all interactions.
class TransactionTemplate extends StatelessWidget {
  final String title;
  final List<TransactionTypeData> transactionTypes;
  final TransactionTypeData selectedType;
  final TextEditingController amountController;
  final DateTime selectedDate;
  final List<String> categories;
  final String? selectedCategory;
  final List<String> accounts;
  final String? selectedAccount;
  final String? selectedToAccount;
  final TextEditingController descriptionController;
  final bool isRecurring;
  final String? selectedFrequency;
  final List<String> frequencies;
  final GlobalKey<FormState> formKey;

  // Callbacks
  final ValueChanged<TransactionTypeData> onTypeChanged;
  final VoidCallback onDateTapped;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<String?> onToAccountChanged;
  final ValueChanged<bool> onRecurringChanged;
  final ValueChanged<String?> onFrequencyChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const TransactionTemplate({
    Key? key,
    required this.title,
    required this.transactionTypes,
    required this.selectedType,
    required this.amountController,
    required this.selectedDate,
    required this.categories,
    required this.selectedCategory,
    required this.accounts,
    required this.selectedAccount,
    this.selectedToAccount,
    required this.descriptionController,
    required this.isRecurring,
    this.selectedFrequency,
    required this.frequencies,
    required this.formKey,
    required this.onTypeChanged,
    required this.onDateTapped,
    required this.onCategoryChanged,
    required this.onAccountChanged,
    required this.onToAccountChanged,
    required this.onRecurringChanged,
    required this.onFrequencyChanged,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BarakahSpacing.md),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTypeSelector(),
                const SizedBox(height: BarakahSpacing.lg),
                _buildAmountInput(),
                const SizedBox(height: BarakahSpacing.lg),
                _buildDatePicker(context),
                const SizedBox(height: BarakahSpacing.lg),
                if (selectedType.showCategory) ...[
                  _buildCategoryDropdown(),
                  const SizedBox(height: BarakahSpacing.lg),
                ],
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
        children: transactionTypes.map((type) {
          final isSelected = type == selectedType;
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
                  onTypeChanged(type);
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
        controller: amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: BarakahTypography.headline1.copyWith(
          color: selectedType.color,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixText: 'PKR ',
          hintText: '0.00',
          prefixIcon: Icon(selectedType.icon, color: selectedType.color),
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

  Widget _buildDatePicker(BuildContext context) {
    return BarakahCard(
      child: InkWell(
        onTap: onDateTapped,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: BarakahSpacing.sm),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: BarakahColors.primary),
              const SizedBox(width: BarakahSpacing.md),
              Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: BarakahTypography.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return BarakahCard(
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.category, color: BarakahColors.primary),
          hintText: 'Select Category',
        ),
        items: categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: onCategoryChanged,
        validator: (value) {
          if (selectedType.showCategory && (value == null || value.isEmpty)) {
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
            value: selectedAccount,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.account_balance_wallet,
                color: BarakahColors.primary,
              ),
              hintText:
                  selectedType.isTransfer ? 'From Account' : 'Select Account',
            ),
            items: accounts.map((account) {
              return DropdownMenuItem(
                value: account,
                child: Text(account),
              );
            }).toList(),
            onChanged: onAccountChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an account';
              }
              return null;
            },
          ),
        ),
        if (selectedType.isTransfer) ...[
          const SizedBox(height: BarakahSpacing.md),
          BarakahCard(
            child: DropdownButtonFormField<String>(
              value: selectedToAccount,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.account_balance_wallet,
                  color: BarakahColors.primary,
                ),
                hintText: 'To Account',
              ),
              items: accounts
                  .where((account) => account != selectedAccount)
                  .map((account) {
                return DropdownMenuItem(
                  value: account,
                  child: Text(account),
                );
              }).toList(),
              onChanged: onToAccountChanged,
              validator: (value) {
                if (selectedType.isTransfer &&
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
            value: isRecurring,
            onChanged: onRecurringChanged,
          ),
          if (isRecurring) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(BarakahSpacing.sm),
              child: DropdownButtonFormField<String>(
                value: selectedFrequency,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.repeat, color: BarakahColors.primary),
                  hintText: 'Select Frequency',
                ),
                items: frequencies.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(frequency),
                  );
                }).toList(),
                onChanged: onFrequencyChanged,
                validator: (value) {
                  if (isRecurring && (value == null || value.isEmpty)) {
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
        controller: descriptionController,
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
            onPressed: onCancel,
            isOutlined: true,
          ),
        ),
        const SizedBox(width: BarakahSpacing.md),
        Expanded(
          child: BarakahButton(
            label: 'Save',
            onPressed: onSave,
          ),
        ),
      ],
    );
  }
}

class TransactionTypeData {
  final String label;
  final IconData icon;
  final Color color;
  final bool showCategory;
  final bool isTransfer;

  const TransactionTypeData({
    required this.label,
    required this.icon,
    required this.color,
    this.showCategory = true,
    this.isTransfer = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeData &&
          runtimeType == other.runtimeType &&
          label == other.label;

  @override
  int get hashCode => label.hashCode;
}
