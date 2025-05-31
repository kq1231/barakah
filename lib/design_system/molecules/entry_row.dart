import 'package:flutter/material.dart';
import '../atoms/constants.dart';

/// A molecule component that represents a single entry row in a double-entry transaction.
class EntryRow extends StatelessWidget {
  final int index;
  final String? selectedAccount;
  final List<String> accounts;
  final bool isDebit;
  final TextEditingController amountController;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<bool> onEntryTypeChanged;
  final VoidCallback onRemove;
  final bool canRemove;

  const EntryRow({
    super.key,
    required this.index,
    required this.selectedAccount,
    required this.accounts,
    required this.isDebit,
    required this.amountController,
    required this.onAccountChanged,
    required this.onEntryTypeChanged,
    required this.onRemove,
    this.canRemove = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color headerColor =
        isDebit ? Colors.green.shade100 : Colors.red.shade100;
    final Color borderColor =
        isDebit ? Colors.green.shade300 : Colors.red.shade300;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: BarakahSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: BarakahSpacing.md, vertical: BarakahSpacing.sm),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? (isDebit ? Colors.green.shade900 : Colors.red.shade900)
                  : headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6.0),
                topRight: Radius.circular(6.0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isDebit ? Icons.add_circle : Icons.remove_circle,
                  color: isDebit ? Colors.green.shade700 : Colors.red.shade700,
                  size: 20,
                ),
                const SizedBox(width: BarakahSpacing.sm),
                Text(
                  isDebit ? 'DEBIT ENTRY' : 'CREDIT ENTRY',
                  style: BarakahTypography.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isDebit ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
                const Spacer(),
                if (canRemove)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color:
                          isDebit ? Colors.green.shade700 : Colors.red.shade700,
                      size: 20,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: onRemove,
                    tooltip: 'Remove entry',
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(BarakahSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account selector with improved label
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: BarakahTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        children: [
                          TextSpan(
                            text: isDebit ? 'INTO: ' : 'FROM: ',
                            style: TextStyle(
                              color: isDebit ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: isDebit
                                ? 'Which account is receiving money?'
                                : 'Which account is providing money?',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    DropdownButtonFormField<String>(
                      value: selectedAccount,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: isDebit
                            ? '🟢 Destination Account (Money going IN)'
                            : '🔴 Source Account (Money coming OUT)',
                        helperText: isDebit
                            ? 'Example: Petrol account for fuel expenses'
                            : 'Example: Cash or Bank account',
                        helperMaxLines: 2,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: BarakahSpacing.md,
                          vertical: BarakahSpacing.sm,
                        ),
                        prefixIcon: Icon(
                          Icons.account_balance_wallet,
                          color: isDebit ? Colors.green : Colors.red,
                        ),
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
                  ],
                ),

                const SizedBox(height: BarakahSpacing.md),

                // Amount field with appropriate styling
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: BarakahTypography.caption.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    TextFormField(
                      controller: amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Enter Amount',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: BarakahSpacing.md,
                          vertical: BarakahSpacing.sm,
                        ),
                        prefixText: 'PKR ',
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: isDebit ? Colors.green : Colors.red,
                        ),
                      ),
                      style: TextStyle(
                        color: isDebit
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
