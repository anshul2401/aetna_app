#!/bin/bash

# Create directories
mkdir -p lib/features/reimbursement/data/models
mkdir -p lib/features/reimbursement/presentation/bloc

# Create reimbursement_request.dart
cat > lib/features/reimbursement/data/models/reimbursement_request.dart << 'DART'
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reimbursement_request.freezed.dart';
part 'reimbursement_request.g.dart';

@freezed
class ReimbursementRequest with _$ReimbursementRequest {
  const factory ReimbursementRequest({
    required String description,
    required String category,
    required String serviceProvider,
    required double amount,
    required DateTime purchaseDate,
    String? notes,
    String? attachmentPath,
  }) = _ReimbursementRequest;

  factory ReimbursementRequest.fromJson(Map<String, dynamic> json) =>
      _$ReimbursementRequestFromJson(json);
}
DART

# Create reimbursement_response.dart
cat > lib/features/reimbursement/data/models/reimbursement_response.dart << 'DART'
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reimbursement_response.freezed.dart';
part 'reimbursement_response.g.dart';

@freezed
class ReimbursementResponse with _$ReimbursementResponse {
  const factory ReimbursementResponse({
    required String id,
    required String status,
    required String message,
    DateTime? submittedAt,
  }) = _ReimbursementResponse;

  factory ReimbursementResponse.fromJson(Map<String, dynamic> json) =>
      _$ReimbursementResponseFromJson(json);
}
DART

echo "✅ Model files created successfully!"
echo "Now run: dart run build_runner build"
