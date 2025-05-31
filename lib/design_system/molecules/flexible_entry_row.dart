import 'package:flutter/material.dart';
import '../atoms/constants.dart';

/// A flexible entry row component for double-entry accounting that doesn't impose
/// rigid language about money flow and allows users to freely decide debit/credit designation.
class FlexibleEntryRow extends StatelessWidget {
  final int index;
  final String? selectedAccount;
  final List<String> accounts;
  final bool isDebit;
  final TextEditingController amountController;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<bool> onEntryTypeChanged;
  final VoidCallback onRemove;
  final bool canRemove;

  const FlexibleEntryRow({
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

    // Define colors
    final Color borderColor =
        isDebit ? Colors.green.shade300 : Colors.red.shade300;
    final Color headerColor = isDarkMode
        ? (isDebit ? Colors.green.shade900 : Colors.red.shade900)
        : (isDebit ? Colors.green.shade100 : Colors.red.shade100);

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
          // Header with debit/credit switch
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: BarakahSpacing.md, vertical: BarakahSpacing.sm),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6.0),
                topRight: Radius.circular(6.0),
              ),
            ),
            child: Row(
              children: [
                // Debit/Credit Switch
                GestureDetector(
                  onTap: () => onEntryTypeChanged(!isDebit),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BarakahSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey.shade700 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDebit ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDebit ? Icons.add_circle : Icons.remove_circle,
                          size: 16,
                          color: isDebit ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDebit ? 'Debit' : 'Credit',
                          style: TextStyle(
                            color: isDebit ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.swap_horiz,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Definition tooltip
                Tooltip(
                  message: isDebit
                      ? 'Debit: Increases asset and expense accounts, decreases liability, equity, and income accounts'
                      : 'Credit: Increases liability, equity, and income accounts, decreases asset and expense accounts',
                  child: Icon(
                    Icons.info_outline,
                    size: 18,
                    color: isDebit ? Colors.green : Colors.red,
                  ),
                ),

                const SizedBox(width: BarakahSpacing.sm),

                // Remove button
                if (canRemove)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: onRemove,
                    tooltip: 'Remove entry',
                    color:
                        isDebit ? Colors.green.shade700 : Colors.red.shade700,
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
                // Simple account selector without rigid language
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: BarakahTypography.caption.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    DropdownButtonFormField<String>(
                      value: selectedAccount,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Select Account',
                        helperText: isDebit
                            ? 'This account will be debited'
                            : 'This account will be credited',
                        helperMaxLines: 1,
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

                // Amount field
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
