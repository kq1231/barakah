// filepath: lib/features/accounts/screens/edit_account_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakah/design_system/atoms/constants.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';

class EditAccountScreen extends ConsumerStatefulWidget {
  final int accountId;

  const EditAccountScreen({
    super.key,
    required this.accountId,
  });

  @override
  ConsumerState<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = 'asset';
  int? _selectedParentAccountId;
  bool _isSubmitting = false;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    try {
      final account = await ref.read(accountProvider(widget.accountId).future);
      if (account != null) {
        setState(() {
          _nameController.text = account.name;
          _selectedType = account.type;
          _selectedParentAccountId = account.parent.targetId;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Account not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading account: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsNotifierProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Account')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Account')),
        body: Center(child: Text('Error: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account'),
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
            children: ['asset', 'liability', 'income', 'expense', 'capital']
                .map((type) {
              return RadioListTile<String>(
                title: Text(_capitalizeFirstLetter(type)),
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
            // Also exclude the current account to prevent circular references
            final filteredAccounts = accounts
                .where((account) =>
                    account.type == _selectedType &&
                    account.id != widget.accountId)
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

  Future<void> _saveAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Get the existing account
        final account =
            await ref.read(accountProvider(widget.accountId).future);

        if (account != null) {
          // Update account properties
          account.name = _nameController.text.trim();
          account.type = _selectedType;

          // Update parent account relationship
          if (_selectedParentAccountId != null) {
            final accountRepo = ref.read(accountRepositoryProvider);
            final parentAccount =
                accountRepo.getAccountById(_selectedParentAccountId!);
            if (parentAccount != null) {
              account.parent.target = parentAccount;
            }
          } else {
            account.parent.target = null;
          }

          // Save the updated account
          await ref
              .read(accountsNotifierProvider.notifier)
              .updateAccount(account);

          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account updated successfully')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account not found')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating account: $e')),
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

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
