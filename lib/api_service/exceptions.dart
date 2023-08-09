// ignore_for_file: constant_identifier_names

class ResponseType {
  static const int SUCCESS = 200;
  static const int CREATED = 201;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int SERVICE_UNAVAILABLE = 503;
  static const int GATEWAY_TIMEOUT = 504;
}

/// exceptions
class BadRequestException implements Exception {
  final String message;
  const BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
}

class InternalServerErrorException implements Exception {
  final String message;
  const InternalServerErrorException(this.message);
}

class ServiceUnavailableException implements Exception {
  final String message;
  const ServiceUnavailableException(this.message);
}

class GatewayTimeoutException implements Exception {
  final String message;
  const GatewayTimeoutException(this.message);
}

class UnknownResponseException implements Exception {
  final String message;
  const UnknownResponseException(this.message);
}