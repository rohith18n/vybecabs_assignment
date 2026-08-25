class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => message;
}

class RideException implements Exception {
  final String message;
  const RideException(this.message);

  @override
  String toString() => message;
}
