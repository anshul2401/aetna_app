import 'package:equatable/equatable.dart';

enum CardReplacementStatus { 
  initial, 
  loading, 
  showingAcknowledgment, 
  submitting, 
  success, 
  failure 
}

class CardReplacementState extends Equatable {
  final CardReplacementStatus status;
  final String reason;
  final String phoneNumber;
  final String street;
  final String streetLine2;
  final String city;
  final String state;
  final String zipCode;
  final String? errorMessage;
  final bool isFormValid;

  const CardReplacementState({
    this.status = CardReplacementStatus.initial,
    this.reason = '',
    this.phoneNumber = '',
    this.street = '',
    this.streetLine2 = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.errorMessage,
    this.isFormValid = false,
  });

  CardReplacementState copyWith({
    CardReplacementStatus? status,
    String? reason,
    String? phoneNumber,
    String? street,
    String? streetLine2,
    String? city,
    String? state,
    String? zipCode,
    String? errorMessage,
    bool? isFormValid,
  }) {
    return CardReplacementState(
      status: status ?? this.status,
      reason: reason ?? this.reason,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      street: street ?? this.street,
      streetLine2: streetLine2 ?? this.streetLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      errorMessage: errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        status,
        reason,
        phoneNumber,
        street,
        streetLine2,
        city,
        state,
        zipCode,
        errorMessage,
        isFormValid,
      ];
}
