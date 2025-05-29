class UserModel {
  int id;
  String firstName;
  String lastName;
  dynamic email;
  String phone;
  dynamic photo;
  dynamic verifyCode;
  String accessToken;
  String refreshToken;
  bool allowtracknot;
  bool allowcompanynot;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.photo,
    required this.verifyCode,
    required this.accessToken,
    required this.refreshToken,
    required this.allowtracknot,
    required this.allowcompanynot,
  });
}