import 'package:objectbox/objectbox.dart';
import 'package:barakah/features/contacts/models/contact.dart';
import 'package:barakah/features/entries/models/entry.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;

  /// The date of the transaction
  @Property(type: PropertyType.date)
  DateTime date;

  /// Primary description of the transaction
  String description;

  /// Optional reference number (e.g., invoice number, check number)
  String? reference;

  /// Type of transaction for Islamic finance categorization
  /// Examples: 'asset', 'liability', 'income', 'expense', 'capital', 'zakat', 'sadaqah'
  String type;

  /// Total amount of the transaction (calculated from entries)
  double amount;

  /// Optional notes for additional details
  String? notes;

  /// Tags for flexible categorization (comma-separated)
  String? tags;

  /// Whether this transaction is verified/reconciled
  bool isVerified;

  /// Whether this transaction follows Islamic finance principles
  bool isCompliant;

  /// Reason for non-compliance (if applicable)
  String? complianceNotes;

  /// The contact associated with this transaction
  final contact = ToOne<Contact>();

  /// The entries that make up this transaction (double-entry bookkeeping)
  @Backlink('transaction')
  final entries = ToMany<Entry>();

  Transaction({
    required this.date,
    required this.description,
    required this.type,
    required this.amount,
    this.reference,
    this.notes,
    this.tags,
    this.complianceNotes,
    this.isVerified = false,
    this.isCompliant = true,
  });

  /// Helper method to add an entry to this transaction
  void addEntry(Entry entry) {
    entries.add(entry);
  }

  /// Helper method to remove an entry from this transaction
  void removeEntry(Entry entry) {
    entries.remove(entry);
  }

  /// Helper method to check if the transaction is balanced
  /// (sum of debits equals sum of credits)
  bool isBalanced() {
    if (entries.isEmpty) return false;

    double debits = 0;
    double credits = 0;

    for (final entry in entries) {
      if (entry.isDebit) {
        debits += entry.amount;
      } else {
        credits += entry.amount;
      }
    }

    // Use a small epsilon for floating-point comparison
    const epsilon = 0.001;
    return (debits - credits).abs() < epsilon;
  }

  /// Helper method to get the net amount of the transaction
  /// Positive for debit transactions, negative for credit transactions
  double getNetAmount() {
    double net = 0;
    for (final entry in entries) {
      net += entry.isDebit ? entry.amount : -entry.amount;
    }
    return net;
  }

  /// Helper method to validate Islamic finance compliance
  bool validateCompliance() {
    // TODO: Implement specific Islamic finance validation rules
    // Examples:
    // - No riba (interest) involved
    // - Halal business activities only
    // - Proper profit-sharing agreements
    // - Valid Islamic contracts (murabaha, ijara, etc.)
    return isCompliant;
  }
}
