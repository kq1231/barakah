import 'package:flutter/material.dart';

/// A data class to hold information about a single entry in a double-entry transaction.
class EntryData {
  final String? accountId;
  final bool isDebit;
  final double amount;
  final TextEditingController amountController;

  EntryData({
    this.accountId,
    this.isDebit = true,
    this.amount = 0.0,
    required this.amountController,
  });
}
