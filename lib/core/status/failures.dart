class Failure {
  final String message;
  const Failure({this.message = ""});

  String get errorMessage => message;
}

class AadhaarFailure extends Failure {
  @override
  String get errorMessage => super.message;

  AadhaarFailure({super.message = "Invalid Aadhaar Number"});
}

class MultiRequestFailure extends Failure {
  @override
  String get errorMessage => super.message;

  MultiRequestFailure({super.message = "Please retry after 45 sec"});
}

class PermissionDeniedFailure extends Failure {
  @override
  String get errorMessage => super.message;
  PermissionDeniedFailure(
      {super.message = "Permissions are required to proceed further."});
}

class PermissionPermanentalyDeniedFailure extends Failure {
  @override
  String get errorMessage => super.message;
  PermissionPermanentalyDeniedFailure(
      {super.message = "Please allow permissions in the settings."});
}

class ConnectionFailure extends Failure {
  @override
  String get errorMessage => super.message;
  ConnectionFailure({super.message = "APP EXPERIENCING INTERNET OUTAGE."});
}

class TimeoutFailure extends Failure {
  @override
  String get errorMessage => super.message;
  TimeoutFailure({super.message = "INTERNET IS SLOW. NEED FASTER CONNECTION."});
}

class ServerFailure extends Failure {
  @override
  String get errorMessage => super.message;
  ServerFailure({super.message = "Internal Server Failure."});
}

class CacheFailure extends Failure {
  @override
  String get errorMessage => super.message;
  CacheFailure({super.message = "Uh-oh! Something went wrong. Please retry."});
}

class GeneralFailure extends Failure {
  @override
  String get errorMessage => super.message;
  GeneralFailure(
      {super.message = "Uh-oh! Something went wrong. Please retry."});
}

class InvalidAadhar extends Failure {
  @override
  String get errorMessage => super.message;
  InvalidAadhar({super.message = "Invalid Aadhar Card"});
}

class BadRequestFailure extends Failure {
  @override
  String get errorMessage => super.message;

  BadRequestFailure(
      {super.message = "Bad Request. Please check the input or try again."});
}

