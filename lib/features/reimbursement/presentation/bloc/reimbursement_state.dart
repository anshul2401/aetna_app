import 'package:equatable/equatable.dart';
import 'dart:io';

enum ReimbursementStatus { initial, loading, success, failure }

class ReimbursementState extends Equatable {
  final ReimbursementStatus status;
  final String description;
  final String category;
  final String provider;
  final double amount;
  final DateTime? purchaseDate;
  final String notes;
  final List<File> attachedFiles; // Changed from File? to List<File>
  final String? errorMessage;
  final bool isFormValid;

  const ReimbursementState({
    this.status = ReimbursementStatus.initial,
    this.description = '',
    this.category = 'Rent',
    this.provider = '',
    this.amount = 0.0,
    this.purchaseDate,
    this.notes = '',
    this.attachedFiles = const [], // Changed default value
    this.errorMessage,
    this.isFormValid = false,
  });

  ReimbursementState copyWith({
    ReimbursementStatus? status,
    String? description,
    String? category,
    String? provider,
    double? amount,
    DateTime? purchaseDate,
    String? notes,
    List<File>? attachedFiles, // Changed type
    String? errorMessage,
    bool? isFormValid,
  }) {
    return ReimbursementState(
      status: status ?? this.status,
      description: description ?? this.description,
      category: category ?? this.category,
      provider: provider ?? this.provider,
      amount: amount ?? this.amount,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      notes: notes ?? this.notes,
      attachedFiles: attachedFiles ?? this.attachedFiles, // Changed
      errorMessage: errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
    status,
    description,
    category,
    provider,
    amount,
    purchaseDate,
    notes,
    attachedFiles, // Changed
    errorMessage,
    isFormValid,
  ];
}
