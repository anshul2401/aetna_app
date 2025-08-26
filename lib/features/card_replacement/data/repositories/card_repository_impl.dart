import '../../domain/repositories/card_repository.dart';
import '../models/card_request.dart';
import '../models/card_response.dart';
import '../datasources/card_remote_data_source.dart';

class CardRepositoryImpl implements CardRepository {
  final CardRemoteDataSource _remoteDataSource;

  CardRepositoryImpl(this._remoteDataSource);

  @override
  Future<CardResponse> submitCardRequest({
    required String reason,
    required String phoneNumber,
    required String street,
    required String streetLine2,
    required String city,
    required String state,
    required String zipCode,
  }) async {
    try {
      final request = CardRequest(
        reason: reason,
        phoneNumber: phoneNumber,
        street: street,
        streetLine2: streetLine2,
        city: city,
        state: state,
        zipCode: zipCode,
      );

      return await _remoteDataSource.submitCardRequest(request: request);
    } catch (e) {
      throw Exception('Failed to submit card request: $e');
    }
  }
}
