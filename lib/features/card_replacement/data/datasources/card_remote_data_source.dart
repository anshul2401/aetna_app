import '../models/card_request.dart';
import '../models/card_response.dart';
import 'package:dio/dio.dart';

abstract class CardRemoteDataSource {
  Future<CardResponse> submitCardRequest({
    required CardRequest request,
  });
}

class CardRemoteDataSourceImpl implements CardRemoteDataSource {
  final Dio _dio;

  CardRemoteDataSourceImpl(this._dio);

  @override
  Future<CardResponse> submitCardRequest({
    required CardRequest request,
  }) async {
    try {
      final response = await _dio.post(
        '/api/card/replacement',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return CardResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
