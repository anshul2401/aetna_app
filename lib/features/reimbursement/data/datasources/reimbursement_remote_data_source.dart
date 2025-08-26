import 'dart:io';
import '../models/reimbursement_request.dart';
import '../models/reimbursement_response.dart';
import 'package:dio/dio.dart';

abstract class ReimbursementRemoteDataSource {
  Future<ReimbursementResponse> submitReimbursement({
    required ReimbursementRequest request,
    List<File>? attachedFiles, // Changed from File? to List<File>?
  });
}

class ReimbursementRemoteDataSourceImpl
    implements ReimbursementRemoteDataSource {
  final Dio _dio;

  ReimbursementRemoteDataSourceImpl(this._dio);

  @override
  Future<ReimbursementResponse> submitReimbursement({
    required ReimbursementRequest request,
    List<File>? attachedFiles, // Changed parameter type
  }) async {
    try {
      final formData = FormData.fromMap({
        'description': request.description,
        'category': request.category,
        'serviceProvider': request.serviceProvider,
        'amount': request.amount,
        'purchaseDate': request.purchaseDate.toIso8601String(),
        'notes': request.notes,
      });

      // Handle multiple files
      if (attachedFiles != null && attachedFiles.isNotEmpty) {
        for (int i = 0; i < attachedFiles.length; i++) {
          final file = attachedFiles[i];
          formData.files.add(
            MapEntry(
              'attachments[$i]', // Use array notation for multiple files
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await _dio.post(
        '/api/reimbursement/submit',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      return ReimbursementResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
