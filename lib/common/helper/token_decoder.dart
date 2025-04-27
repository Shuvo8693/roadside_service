import 'package:jwt_decoder/jwt_decoder.dart';

String? getCompanyFromToken(String token) {
  try {
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken['company'] as String?;
  } catch (e) {
    print('Error decoding token: $e');
    return null;
  }
}
