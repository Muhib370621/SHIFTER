// To parse this JSON data, do
//
//     final getOrderById = getOrderByIdFromJson(jsonString);

import 'dart:convert';

GetOrderById getOrderByIdFromJson(String str) => GetOrderById.fromJson(json.decode(str));

String getOrderByIdToJson(GetOrderById data) => json.encode(data.toJson());

class GetOrderById {
  Value? value;
  List<dynamic>? formatters;
  List<dynamic>? contentTypes;
  dynamic declaredType;
  int? statusCode;

  GetOrderById({
    this.value,
    this.formatters,
    this.contentTypes,
    this.declaredType,
    this.statusCode,
  });

  factory GetOrderById.fromJson(Map<String, dynamic> json) => GetOrderById(
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
  OrderModel? data;

  Value({
    this.code,
    this.message,
    this.data,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : OrderModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class OrderModel {
  int? id;
  String? referancecode;
  String? cashOnDelivery;
  String? clientName;
  String? clientPhone;
  String? companyName;
  String? companyPhone;
  String? status;
  String? pickAddress;
  String? pickAddressLatLng;
  String? dropAddress;
  String? dropAddressLatLng;
  String? deliveryDateTime;
  int? levelid;
  bool? canStartOrder;
  bool? canReachPickup;
  bool? canLeavePickup;
  bool? canReachDrop;
  bool? canCompleteOrder;

  OrderModel({
    this.id,
    this.referancecode,
    this.cashOnDelivery,
    this.clientName,
    this.clientPhone,
    this.companyName,
    this.companyPhone,
    this.status,
    this.pickAddress,
    this.pickAddressLatLng,
    this.dropAddress,
    this.dropAddressLatLng,
    this.deliveryDateTime,
    this.levelid,
    this.canStartOrder,
    this.canReachPickup,
    this.canLeavePickup,
    this.canReachDrop,
    this.canCompleteOrder,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json["id"],
    referancecode: json["referancecode"],
    cashOnDelivery: json["cashOnDelivery"],
    clientName: json["clientName"],
    clientPhone: json["clientPhone"],
    companyName: json["companyName"],
    companyPhone: json["companyPhone"],
    status: json["status"],
    pickAddress: json["pickAddress"],
    pickAddressLatLng: json["pickAddressLatLng"],
    dropAddress: json["dropAddress"],
    dropAddressLatLng: json["dropAddressLatLng"],
    deliveryDateTime: json["deliveryDateTime"],
    levelid: json["levelid"],
    canStartOrder: json["canStartOrder"],
    canReachPickup: json["canReachPickup"],
    canLeavePickup: json["canLeavePickup"],
    canReachDrop: json["canReachDrop"],
    canCompleteOrder: json["canCompleteOrder"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "referancecode": referancecode,
    "cashOnDelivery": cashOnDelivery,
    "clientName": clientName,
    "clientPhone": clientPhone,
    "companyName": companyName,
    "companyPhone": companyPhone,
    "status": status,
    "pickAddress": pickAddress,
    "pickAddressLatLng": pickAddressLatLng,
    "dropAddress": dropAddress,
    "dropAddressLatLng": dropAddressLatLng,
    "deliveryDateTime": deliveryDateTime,
    "levelid": levelid,
    "canStartOrder": canStartOrder,
    "canReachPickup": canReachPickup,
    "canLeavePickup": canLeavePickup,
    "canReachDrop": canReachDrop,
    "canCompleteOrder": canCompleteOrder,
  };
}
