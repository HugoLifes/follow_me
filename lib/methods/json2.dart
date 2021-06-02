// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.value,
    this.message,
    this.fechaInicial,
    this.fechaFinal,
    this.data,
  });

  int value;
  String message;
  String fechaInicial;
  String fechaFinal;
  Data data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        value: json["value"],
        message: json["message"],
        fechaInicial: json["fechaInicial"],
        fechaFinal: json["fechaFinal"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "fechaInicial": fechaInicial,
        "fechaFinal": fechaFinal,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.idUnidad,
    this.fecha,
    this.latitud,
    this.longitud,
    this.velocidad,
    this.observaciones,
    this.compania,
    this.temperatura,
  });

  String idUnidad;
  String fecha;
  String latitud;
  String longitud;
  String velocidad;
  String observaciones;
  String compania;
  String temperatura;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUnidad: json["ID_UNIDAD"],
        fecha: json["FECHA"],
        latitud: json["LATITUD"],
        longitud: json["LONGITUD"],
        velocidad: json["VELOCIDAD"],
        observaciones: json["OBSERVACIONES"],
        compania: json["COMPANIA"],
        temperatura: json["TEMPERATURA"],
      );

  Map<String, dynamic> toJson() => {
        "ID_UNIDAD": idUnidad,
        "FECHA": fecha,
        "LATITUD": latitud,
        "LONGITUD": longitud,
        "VELOCIDAD": velocidad,
        "OBSERVACIONES": observaciones,
        "COMPANIA": compania,
        "TEMPERATURA": temperatura,
      };
}

Posting postingFromJson(String str) => Posting.fromJson(json.decode(str));

String postingToJson(Posting data) => json.encode(data.toJson());

class Posting {
  Posting({
    this.value,
    this.message,
    this.unitId,
  });

  int value;
  String message;
  int unitId;

  factory Posting.fromJson(Map<String, dynamic> json) => Posting(
        value: json["value"],
        message: json["message"],
        unitId: json["unitId"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
        "unitId": unitId,
      };
}
