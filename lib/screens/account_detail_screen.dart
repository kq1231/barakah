import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../design_system/atoms/constants.dart';
import '../design_system/atoms/button.dart';
import '../design_system/atoms/base_components.dart';
import '../design_system/molecules/list_items.dart';

class AccountDetailScreen extends StatefulWidget {
  final String accountName;
  final double balance;

  const AccountDetailScreen({
    Key? key,
    required this.accountName,
    required this.balance,
  }) : super(key: key);

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  bool _showReconciliation = false;
  final _reconcileController = TextEditingController();
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
          _buildBalanceCard(),
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
              BarakahButton(
                label: 'Reconcile',
                onPressed: _reconcileAccount,
                isSmall: true,
              ),
            ],
          ),
          const SizedBox(height: BarakahSpacing.sm),
          Text(
            'Difference: PKR ${_calculateDifference()}',
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

  Widget _buildBalanceCard() {
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
                  const SizedBox(height: BarakahSpacing.xs),
                  BarakahAmount(
                    amount: widget.balance,
                    isLarge: true,
                    showSign: false,
                  ),
                ],
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: _handleMenuAction,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Account'),
                  ),
                  const PopupMenuItem(
                    value: 'export',
                    child: Text('Export Transactions'),
                  ),
                  const PopupMenuItem(
                    value: 'archive',
                    child: Text('Archive Account'),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          _buildMonthSelector(),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _selectedMonth = DateTime(
                _selectedMonth.year,
                _selectedMonth.month - 1,
              );
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(_selectedMonth),
          style: BarakahTypography.subtitle1,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _selectedMonth = DateTime(
                _selectedMonth.year,
                _selectedMonth.month + 1,
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildTransactionsList() {
    // Mock transactions for demonstration
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(BarakahSpacing.md),
        itemCount: 5,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return TransactionListItem(
            title: 'Transaction ${index + 1}',
            subtitle: '20 May 2025',
            icon: Icons.receipt,
            iconColor: BarakahColors.primary,
            amount: index % 2 == 0 ? -1000.0 : 2000.0,
          );
        },
      ),
    );
  }

  void _reconcileAccount() {
    if (_reconcileController.text.isNotEmpty) {
      // Add reconciliation logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account reconciled successfully'),
        ),
      );
    }
  }

  double _calculateDifference() {
    final statementBalance = double.tryParse(_reconcileController.text) ?? 0;
    return statementBalance - widget.balance;
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'edit':
        // Show edit account dialog
        break;
      case 'export':
        // Handle export
        break;
      case 'archive':
        // Handle archive
        break;
    }
  }

  @override
  void dispose() {
    _reconcileController.dispose();
    super.dispose();
  }
}
