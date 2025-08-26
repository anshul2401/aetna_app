import 'package:equatable/equatable.dart';

class ReimbursementResponse extends Equatable {
  final String id;
  final String status;
  final String message;
  final DateTime? submittedAt;

  const ReimbursementResponse({
    required this.id,
    required this.status,
    required this.message,
    this.submittedAt,
  });

  factory ReimbursementResponse.fromJson(Map<String, dynamic> json) {
    return ReimbursementResponse(
      id: json['id'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      submittedAt: json['submittedAt'] != null 
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'message': message,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, status, message, submittedAt];
}
