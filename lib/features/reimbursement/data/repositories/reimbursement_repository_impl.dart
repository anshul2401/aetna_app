import 'dart:io';
import '../../domain/repositories/reimbursement_repository.dart';
import '../models/reimbursement_request.dart';
import '../models/reimbursement_response.dart';
import '../datasources/reimbursement_remote_data_source.dart';

class ReimbursementRepositoryImpl implements ReimbursementRepository {
  final ReimbursementRemoteDataSource _remoteDataSource;

  ReimbursementRepositoryImpl(this._remoteDataSource);

  @override
  Future<ReimbursementResponse> submitReimbursement({
    required String description,
    required String category,
    required String serviceProvider,
    required double amount,
    required DateTime purchaseDate,
    String? notes,
    List<File>? attachedFiles, // Changed from File? to List<File>?
  }) async {
    try {
      final request = ReimbursementRequest(
        description: description,
        category: category,
        serviceProvider: serviceProvider,
        amount: amount,
        purchaseDate: purchaseDate,
        notes: notes,
        // For backward compatibility, store the first file's path if any files exist
        attachmentPath: attachedFiles?.isNotEmpty == true
            ? attachedFiles!.first.path
            : null,
      );

      return await _remoteDataSource.submitReimbursement(
        request: request,
        attachedFiles: attachedFiles, // Pass the list of files
      );
    } catch (e) {
      throw Exception('Failed to submit reimbursement: $e');
    }
  }
}
