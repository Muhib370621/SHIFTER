// To parse this JSON data, do
//
//     final getDriverByIdModel = getDriverByIdModelFromJson(jsonString);

import 'dart:convert';

GetDriverByIdModel getDriverByIdModelFromJson(String str) => GetDriverByIdModel.fromJson(json.decode(str));

String getDriverByIdModelToJson(GetDriverByIdModel data) => json.encode(data.toJson());

class GetDriverByIdModel {
  Value? value;
  List<dynamic>? formatters;
  List<dynamic>? contentTypes;
  dynamic declaredType;
  int? statusCode;

  GetDriverByIdModel({
    this.value,
    this.formatters,
    this.contentTypes,
    this.declaredType,
    this.statusCode,
  });

  factory GetDriverByIdModel.fromJson(Map<String, dynamic> json) => GetDriverByIdModel(
    value: json["value"] == null ? null : Value.fromJson(json["value"]),
    formatters: json["formatters"] == null ? [] : List<dynamic>.from(json["formatters"]!.map((x) => x)),
    contentTypes: json["contentTypes"] == null ? [] : List<dynamic>.from(json["contentTypes"]!.map((x) => x)),
    declaredType: json["declaredType"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "value": value?.toJson(),
    "formatters": formatters == null ? [] : List<dynamic>.from(formatters!.map((x) => x)),
    "contentTypes": contentTypes == null ? [] : List<dynamic>.from(contentTypes!.map((x) => x)),
    "declaredType": declaredType,
    "statusCode": statusCode,
  };
}

class Value {
  int? code;
  String? message;
  DriverData? data;

  Value({
    this.code,
    this.message,
    this.data,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : DriverData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class DriverData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  dynamic photo;
  dynamic verifyCode;
  dynamic accessToken;
  dynamic refreshToken;
  bool? allowtracknot;
  bool? allowcompanynot;

  DriverData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
    this.verifyCode,
    this.accessToken,
    this.refreshToken,
    this.allowtracknot,
    this.allowcompanynot,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) => DriverData(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phone: json["phone"],
    photo: json["photo"],
    verifyCode: json["verifyCode"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    allowtracknot: json["allowtracknot"],
    allowcompanynot: json["allowcompanynot"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "photo": photo,
    "verifyCode": verifyCode,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "allowtracknot": allowtracknot,
    "allowcompanynot": allowcompanynot,
  };
}
