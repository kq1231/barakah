import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:barakah/design_system/atoms/constants.dart';
import 'package:barakah/design_system/atoms/base_components.dart';
import '../providers/account_provider.dart';
import 'edit_account_screen.dart';

class AccountDetailScreen extends ConsumerStatefulWidget {
  final String accountName;
  final double balance;
  final int? accountId;

  const AccountDetailScreen({
    super.key,
    required this.accountName,
    required this.balance,
    this.accountId,
  });

  @override
  ConsumerState<AccountDetailScreen> createState() =>
      _AccountDetailScreenState();
}

class _AccountDetailScreenState extends ConsumerState<AccountDetailScreen> {
  bool _showReconciliation = false;
  final _reconcileController = TextEditingController();
  DateTime _selectedMonth = DateTime.now();

  final _currencyFormat = NumberFormat.currency(
    symbol: 'PKR ',
    decimalDigits: 2,
  );

  @override
  void dispose() {
    _reconcileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balanceAsync = widget.accountId != null
        ? ref.watch(accountBalanceProvider(widget.accountId!))
        : null;

    final currentBalance = balanceAsync?.whenOrNull(
          data: (value) => value,
        ) ??
        widget.balance;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.accountName),
        actions: [
          IconButton(
            icon: const Icon(Icons.balance),
            onPressed: () {
              setState(() => _showReconciliation = !_showReconciliation);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showReconciliation) _buildReconciliationSection(),
          _buildBalanceCard(currentBalance),
          _buildTransactionsList(),
        ],
      ),
    );
  }

  Widget _buildReconciliationSection() {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Reconciliation',
            style: BarakahTypography.subtitle1,
          ),
          const SizedBox(height: BarakahSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _reconcileController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Statement Balance',
                    prefixText: 'PKR ',
                  ),
                ),
              ),
              const SizedBox(width: BarakahSpacing.md),
              ElevatedButton(
                onPressed: _reconcileAccount,
                child: const Text('Reconcile'),
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.sm),
          Text(
            'Difference: ${_currencyFormat.format(_calculateDifference())}',
            style: BarakahTypography.caption.copyWith(
              color: _calculateDifference() == 0
                  ? BarakahColors.success
                  : BarakahColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double currentBalance) {
    return BarakahCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Balance',
                    style: BarakahTypography.caption,
                  ),
                  Text(
                    _currencyFormat.format(currentBalance),
                    style: BarakahTypography.headline1,
                  ),
                ],
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _editAccount();
                      break;
                    case 'delete':
                      _confirmDeleteAccount();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit Account'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete Account'),
                    ),
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedMonth),
                style: BarakahTypography.subtitle1,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Expanded(
      child: Center(
        child: Text(
          'No transactions yet',
          style: BarakahTypography.subtitle1.copyWith(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  double _calculateDifference() {
    final statementBalance = double.tryParse(_reconcileController.text) ?? 0;
    return statementBalance - widget.balance;
  }

  void _reconcileAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reconciliation will be available soon')),
    );
  }

  void _changeMonth(int months) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + months,
        _selectedMonth.day,
      );
    });
  }

  void _editAccount() {
    if (widget.accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot edit this account')),
      );
      return;
    }

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => EditAccountScreen(
          accountId: widget.accountId!,
        ),
      ),
    )
        .then((_) {
      // Refresh the account details when returning from edit screen
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _confirmDeleteAccount() {
    if (widget.accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete this account')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete this account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteAccount();
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: BarakahColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    if (widget.accountId == null) return;

    try {
      await ref
          .read(accountsNotifierProvider.notifier)
          .deleteAccount(widget.accountId!);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: $e')),
        );
      }
    }
  }
}
