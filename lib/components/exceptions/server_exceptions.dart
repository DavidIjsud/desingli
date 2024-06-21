import 'general_exception.dart';

class ServerException extends AppException {
  ServerException({
    String? message,
  }) : super(message: message);
}
