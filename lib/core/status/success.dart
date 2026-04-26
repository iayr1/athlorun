class Success {
  final String message;
  const Success({this.message = ""});
}

class PermissionSuccess extends Success {

 String get successMessage => super.message;

  PermissionSuccess({super.message = "Permission Granted"});
}

