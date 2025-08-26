import 'dart:io';
import '../repositories/reimbursement_repository.dart';
import '../../data/models/reimbursement_response.dart';

class SubmitReimbursementUseCase {
  final ReimbursementRepository _repository;

  SubmitReimbursementUseCase(this._repository);

  Future<ReimbursementResponse> call({
    required String description,
    required String category,
    required String serviceProvider,
    required double amount,
    required DateTime purchaseDate,
    String? notes,
    List<File>?
    attachedFiles, // Changed from File? attachedFile to List<File>? attachedFiles
  }) async {
    if (description.trim().isEmpty) {
      throw Exception('Description is required');
    }

    if (serviceProvider.trim().isEmpty) {
      throw Exception('Service provider is required');
    }

    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }

    return await _repository.submitReimbursement(
      description: description,
      category: category,
      serviceProvider: serviceProvider,
      amount: amount,
      purchaseDate: purchaseDate,
      notes: notes,
      attachedFiles: attachedFiles, // Updated parameter name
    );
  }
}
