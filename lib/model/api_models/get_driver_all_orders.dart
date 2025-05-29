// To parse this JSON data, do
//
//     final getDriverAllOrders = getDriverAllOrdersFromJson(jsonString);

import 'dart:convert';

GetDriverAllOrders getDriverAllOrdersFromJson(String str) => GetDriverAllOrders.fromJson(json.decode(str));

String getDriverAllOrdersToJson(GetDriverAllOrders data) => json.encode(data.toJson());

class GetDriverAllOrders {
  Value? value;
  List<dynamic>? formatters;
  List<dynamic>? contentTypes;
  dynamic declaredType;
  int? statusCode;

  GetDriverAllOrders({
    this.value,
    this.formatters,
    this.contentTypes,
    this.declaredType,
    this.statusCode,
  });

  factory GetDriverAllOrders.fromJson(Map<String, dynamic> json) => GetDriverAllOrders(
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
  Data? data;

  Value({
    this.code,
    this.message,
    this.data,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<OrderAllDataList>? dataList;
  int? totalCount;

  Data({
    this.dataList,
    this.totalCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dataList: json["dataList"] == null ? [] : List<OrderAllDataList>.from(json["dataList"]!.map((x) => OrderAllDataList.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "dataList": dataList == null ? [] : List<dynamic>.from(dataList!.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class OrderAllDataList {
  int? id;
  DateTime? date;
  String? day;
  String? referancecode;
  String? photo;
  String? customer;
  String? pickAddresstxt;
  String? pickAddress;
  String? dropAddress;

  OrderAllDataList({
    this.id,
    this.date,
    this.day,
    this.referancecode,
    this.photo,
    this.customer,
    this.pickAddresstxt,
    this.pickAddress,
    this.dropAddress,
  });

  factory OrderAllDataList.fromJson(Map<String, dynamic> json) => OrderAllDataList(
    id: json["id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    day: json["day"],
    referancecode: json["referancecode"],
    photo: json["photo"],
    customer: json["customer"],
    pickAddresstxt: json["pickAddresstxt"],
    pickAddress: json["pickAddress"],
    dropAddress: json["dropAddress"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "day": day,
    "referancecode": referancecode,
    "photo": photo,
    "customer": customer,
    "pickAddresstxt": pickAddresstxt,
    "pickAddress": pickAddress,
    "dropAddress": dropAddress,
  };
}
