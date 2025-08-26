import 'package:equatable/equatable.dart';

class CardRequest extends Equatable {
  final String reason;
  final String phoneNumber;
  final String street;
  final String streetLine2;
  final String city;
  final String state;
  final String zipCode;

  const CardRequest({
    required this.reason,
    required this.phoneNumber,
    required this.street,
    required this.streetLine2,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory CardRequest.fromJson(Map<String, dynamic> json) {
    return CardRequest(
      reason: json['reason'] as String,
      phoneNumber: json['phoneNumber'] as String,
      street: json['street'] as String,
      streetLine2: json['streetLine2'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'phoneNumber': phoneNumber,
      'street': street,
      'streetLine2': streetLine2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }

  @override
  List<Object?> get props => [
    reason,
    phoneNumber,
    street,
    streetLine2,
    city,
    state,
    zipCode,
  ];
}
