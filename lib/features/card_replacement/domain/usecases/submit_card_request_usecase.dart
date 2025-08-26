import '../repositories/card_repository.dart';
import '../../data/models/card_response.dart';

class SubmitCardRequestUseCase {
  final CardRepository _repository;

  SubmitCardRequestUseCase(this._repository);

  Future<CardResponse> call({
    required String reason,
    required String phoneNumber,
    required String street,
    required String streetLine2,
    required String city,
    required String state,
    required String zipCode,
  }) async {
    if (reason.trim().isEmpty) {
      throw Exception('Reason is required');
    }

    if (phoneNumber.trim().isEmpty) {
      throw Exception('Phone number is required');
    }

    if (street.trim().isEmpty) {
      throw Exception('Street address is required');
    }

    if (city.trim().isEmpty) {
      throw Exception('City is required');
    }

    if (state.trim().isEmpty) {
      throw Exception('State is required');
    }

    if (zipCode.trim().isEmpty) {
      throw Exception('Zip code is required');
    }

    return await _repository.submitCardRequest(
      reason: reason,
      phoneNumber: phoneNumber,
      street: street,
      streetLine2: streetLine2,
      city: city,
      state: state,
      zipCode: zipCode,
    );
  }
}
