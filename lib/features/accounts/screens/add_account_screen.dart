import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakah/design_system/atoms/constants.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _openingBalanceController = TextEditingController();
  String _selectedType = 'asset';
  int? _selectedParentAccountId;
  bool _isSubmitting = false;

  final List<String> _accountTypes = [
    'asset',
    'liability',
    'income',
    'expense',
    'capital',
  ];

  @override
  void initState() {
    super.initState();
    // Prefill the opening balance with 0
    _openingBalanceController.text = '0.0';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsNotifierProvider);

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
              _buildParentAccountDropdown(accountsAsync),
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: _accountTypes.map((type) {
              return RadioListTile<String>(
                title: Text(type.capitalize()),
                value: type,
                groupValue: _selectedType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                      // Reset parent selection when type changes
                      _selectedParentAccountId = null;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Name',
          style: BarakahTypography.subtitle1,
        ),
        const SizedBox(height: BarakahSpacing.sm),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Enter account name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an account name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildParentAccountDropdown(AsyncValue<List<Account>> accountsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Parent Account (Optional)',
          style: BarakahTypography.subtitle1,
        ),
        const SizedBox(height: BarakahSpacing.sm),
        accountsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Error loading accounts: $error'),
          data: (accounts) {
            // Filter accounts to show only accounts of the same type
            final filteredAccounts = accounts
                .where((account) => account.type == _selectedType)
                .toList();

            return DropdownButtonFormField<int?>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: _selectedParentAccountId,
              hint: const Text('Select parent account (optional)'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('None'),
                ),
                ...filteredAccounts.map((account) {
                  return DropdownMenuItem<int?>(
                    value: account.id,
                    child: Text(account.name),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedParentAccountId = value;
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOpeningBalanceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Balance',
          style: BarakahTypography.subtitle1,
        ),
        const SizedBox(height: BarakahSpacing.sm),
        TextFormField(
          controller: _openingBalanceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: '0.00',
            border: OutlineInputBorder(),
            prefixText: 'PKR ',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an opening balance';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: BarakahSpacing.md),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _saveAccount,
          child: Text(_isSubmitting ? 'Saving...' : 'Save'),
        ),
      ],
    );
  }

  void _saveAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Create the account
        final account = Account(
          name: _nameController.text.trim(),
          type: _selectedType,
        );

        // Set parent if selected
        if (_selectedParentAccountId != null) {
          final accountRepo = ref.read(accountRepositoryProvider);
          final parentAccount =
              accountRepo.getAccountById(_selectedParentAccountId!);
          if (parentAccount != null) {
            account.parent.target = parentAccount;
          }
        }

        // Save the account using the notifier
        await ref.read(accountRepositoryProvider).createAccount(account);

        // Refresh the accounts list
        ref.invalidate(accountsNotifierProvider);

        // TODO: Handle opening balance by creating a transaction
        // This would be implemented when we add the transactions feature

        // Navigate back after successful creation
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating account: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
