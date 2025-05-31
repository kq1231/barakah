import 'package:flutter/material.dart';
import '../atoms/constants.dart';
import '../atoms/button.dart';
import '../atoms/base_components.dart';
import '../molecules/flexible_entry_row.dart';
import '../molecules/entry_data.dart';

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

  // Double-entry specific properties
  final List<EntryData> entries;
  final double totalDebits;
  final double totalCredits;
  final bool isBalanced;

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

  // Double-entry callbacks
  final VoidCallback onAddEntry;
  final Function(int) onRemoveEntry;
  final Function(int, String?) onEntryAccountChanged;
  final Function(int, bool) onEntryTypeChanged;
  final Function(int, String) onEntryAmountChanged;

  const TransactionTemplate({
    super.key,
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
    // Double-entry properties
    this.entries = const [],
    this.totalDebits = 0,
    this.totalCredits = 0,
    this.isBalanced = false,
    this.onAddEntry = _defaultCallback,
    this.onRemoveEntry = _defaultIndexCallback,
    this.onEntryAccountChanged = _defaultIndexStringCallback,
    this.onEntryTypeChanged = _defaultIndexBoolCallback,
    this.onEntryAmountChanged = _defaultIndexStringCallback,
  });

  static void _defaultCallback() {}
  static void _defaultIndexCallback(int _) {}
  static void _defaultIndexStringCallback(int _, String? __) {}
  static void _defaultIndexBoolCallback(int _, bool __) {}

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
                if (!selectedType.isDoubleEntry) ...[
                  // Standard transaction fields
                  _buildAmountInput(),
                  const SizedBox(height: BarakahSpacing.lg),
                  _buildDatePicker(context),
                  const SizedBox(height: BarakahSpacing.lg),
                  _buildAccountSelection(),
                ] else ...[
                  // Double-entry transaction fields
                  _buildDatePicker(context),
                  const SizedBox(height: BarakahSpacing.lg),
                  _buildDoubleEntrySection(),
                ],
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

  // Removed category dropdown as requested

  Widget _buildAccountSelection() {
    final String fromLabel = selectedType.fromAccountLabel ??
        (selectedType.isTransfer
            ? 'FROM Account (Money Coming Out)'
            : selectedType.label == 'Expense'
                ? 'FROM Account (Money Being Spent)'
                : selectedType.label == 'Income'
                    ? 'INTO Account (Money Being Received)'
                    : 'Select Account');

    final String toLabel = selectedType.toAccountLabel ??
        (selectedType.isTransfer
            ? 'INTO Account (Money Going In)'
            : selectedType.label == 'Expense'
                ? 'INTO Account (Expense Category)'
                : 'TO Account');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Source/From account
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedType.label == 'Income'
                  ? 'Which account is receiving the money? (Bank, Cash, etc.)'
                  : 'Which account is the money coming from?',
              style: BarakahTypography.caption.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: BarakahSpacing.xs),
            BarakahCard(
              child: DropdownButtonFormField<String>(
                value: selectedAccount,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    selectedType.label == 'Income'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: BarakahColors.primary,
                  ),
                  hintText: fromLabel,
                  helperText: selectedType.label == 'Expense'
                      ? 'Example: Cash or Bank Account'
                      : selectedType.label == 'Income'
                          ? 'Example: Bank Account or Cash'
                          : null,
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
          ],
        ),

        if (selectedType.isTransfer ||
            selectedType.label == 'Expense' ||
            selectedType.label == 'Income') ...[
          const SizedBox(height: BarakahSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedType.isTransfer
                    ? 'Which account is receiving the money?'
                    : selectedType.label == 'Expense'
                        ? 'What expense account is this for?'
                        : 'Which income source is providing the money?',
                style: BarakahTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: BarakahSpacing.xs),
              BarakahCard(
                child: DropdownButtonFormField<String>(
                  value: selectedToAccount,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      selectedType.isTransfer
                          ? Icons.arrow_downward
                          : selectedType.label == 'Income'
                              ? Icons.monetization_on
                              : Icons.category,
                      color: BarakahColors.primary,
                    ),
                    hintText: toLabel,
                    helperText: selectedType.label == 'Expense'
                        ? 'Example: Petrol Expense, Food Expense'
                        : selectedType.label == 'Income'
                            ? 'Example: Salary Income, Freelance Income'
                            : selectedType.isTransfer
                                ? 'Example: Savings Account'
                                : null,
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
                    if ((selectedType.isTransfer ||
                            selectedType.label == 'Expense' ||
                            selectedType.label == 'Income') &&
                        (value == null || value.isEmpty)) {
                      if (selectedType.isTransfer) {
                        return 'Please select destination account';
                      } else if (selectedType.label == 'Expense') {
                        return 'Please select expense account';
                      } else {
                        return 'Please select income source account';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
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

  Widget _buildDoubleEntrySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Balance summary card
        BarakahCard(
          child: Padding(
            padding: const EdgeInsets.all(BarakahSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction Balance',
                  style: BarakahTypography.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: BarakahSpacing.xs),
                Text(
                  'Total debits must equal total credits',
                  style: BarakahTypography.caption,
                ),
                const SizedBox(height: BarakahSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Debits',
                              style: BarakahTypography.caption),
                          Text(
                            'PKR ${totalDebits.toStringAsFixed(2)}',
                            style: BarakahTypography.subtitle1.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Credits',
                              style: BarakahTypography.caption),
                          Text(
                            'PKR ${totalCredits.toStringAsFixed(2)}',
                            style: BarakahTypography.subtitle1.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: BarakahSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isBalanced
                            ? 'Transaction is balanced ✅'
                            : 'Transaction is not balanced yet ❌',
                        style: TextStyle(
                          color: isBalanced ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (totalDebits != totalCredits)
                      Text(
                        'Difference: PKR ${(totalDebits - totalCredits).abs().toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: BarakahSpacing.md),

        // Explanation card
        BarakahCard(
          child: Padding(
            padding: const EdgeInsets.all(BarakahSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Double-Entry Accounting Basics:',
                  style: BarakahTypography.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: BarakahSpacing.sm),
                const Text(
                  '• Every transaction affects at least two accounts',
                ),
                const SizedBox(height: BarakahSpacing.xs),
                const Text(
                  '• Total debits must equal total credits',
                ),
                const SizedBox(height: BarakahSpacing.xs),
                const Text(
                  '• Debit: Increases assets & expenses, decreases liabilities & income',
                ),
                const SizedBox(height: BarakahSpacing.xs),
                const Text(
                  '• Credit: Increases liabilities & income, decreases assets & expenses',
                ),
                const SizedBox(height: BarakahSpacing.md),
                const Text(
                  'Toggle between debit and credit entries as needed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: BarakahSpacing.md),

        // Entries list
        ...entries.asMap().entries.map((mapEntry) {
          final index = mapEntry.key;
          final entry = mapEntry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: BarakahSpacing.md),
            child: FlexibleEntryRow(
              index: index,
              selectedAccount: entry.accountId,
              accounts: accounts,
              isDebit: entry.isDebit,
              amountController: entry.amountController,
              onAccountChanged: (account) =>
                  onEntryAccountChanged(index, account),
              onEntryTypeChanged: (isDebit) =>
                  onEntryTypeChanged(index, isDebit),
              onRemove: () => onRemoveEntry(index),
              canRemove: entries.length > 2, // Need at least 2 entries
            ),
          );
        }).toList(),

        // Add entry button
        Center(
          child: OutlinedButton.icon(
            onPressed: onAddEntry,
            icon: const Icon(Icons.add),
            label: const Text('Add Entry'),
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
  final bool isDoubleEntry; // New property to indicate double-entry transaction
  final String? defaultFromAccount; // Default FROM account (source of funds)
  final String? defaultToAccount; // Default TO account (destination of funds)
  final String? fromAccountLabel; // Custom label for FROM account selection
  final String? toAccountLabel; // Custom label for TO account selection
  final List<String>? templateEntries; // Optional preset entries for this type

  const TransactionTypeData({
    required this.label,
    required this.icon,
    required this.color,
    this.showCategory = true,
    this.isTransfer = false,
    this.isDoubleEntry = false,
    this.defaultFromAccount,
    this.defaultToAccount,
    this.fromAccountLabel,
    this.toAccountLabel,
    this.templateEntries,
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
