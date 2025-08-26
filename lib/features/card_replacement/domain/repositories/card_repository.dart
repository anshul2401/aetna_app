import '../../data/models/card_response.dart';

abstract class CardRepository {
  Future<CardResponse> submitCardRequest({
    required String reason,
    required String phoneNumber,
    required String street,
    required String streetLine2,
    required String city,
    required String state,
    required String zipCode,
  });
}
