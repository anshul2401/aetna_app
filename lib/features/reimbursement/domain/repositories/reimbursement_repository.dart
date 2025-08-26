import 'dart:io';
import '../../data/models/reimbursement_response.dart';

abstract class ReimbursementRepository {
  Future<ReimbursementResponse> submitReimbursement({
    required String description,
    required String category,
    required String serviceProvider,
    required double amount,
    required DateTime purchaseDate,
    String? notes,
    List<File>? attachedFiles,
  });
}
