import 'package:equatable/equatable.dart';

class ReimbursementRequest extends Equatable {
  final String description;
  final String category;
  final String serviceProvider;
  final double amount;
  final DateTime purchaseDate;
  final String? notes;
  final String? attachmentPath;

  const ReimbursementRequest({
    required this.description,
    required this.category,
    required this.serviceProvider,
    required this.amount,
    required this.purchaseDate,
    this.notes,
    this.attachmentPath,
  });

  factory ReimbursementRequest.fromJson(Map<String, dynamic> json) {
    return ReimbursementRequest(
      description: json['description'] as String,
      category: json['category'] as String,
      serviceProvider: json['serviceProvider'] as String,
      amount: (json['amount'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      notes: json['notes'] as String?,
      attachmentPath: json['attachmentPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'category': category,
      'serviceProvider': serviceProvider,
      'amount': amount,
      'purchaseDate': purchaseDate.toIso8601String(),
      'notes': notes,
      'attachmentPath': attachmentPath,
    };
  }

  @override
  List<Object?> get props => [
    description,
    category,
    serviceProvider,
    amount,
    purchaseDate,
    notes,
    attachmentPath,
  ];
}
