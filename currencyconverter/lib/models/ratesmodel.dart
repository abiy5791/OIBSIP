// To parse this JSON data, do
//
//     final ratesmodel = ratesmodelFromJson(jsonString);

import 'dart:convert';

Ratesmodel ratesmodelFromJson(String str) =>
    Ratesmodel.fromJson(json.decode(str));

String ratesmodelToJson(Ratesmodel data) => json.encode(data.toJson());

class Ratesmodel {
  String disclaimer;
  String license;
  int timestamp;
  String base;
  Map<String, double> rates;

  Ratesmodel({
    required this.disclaimer,
    required this.license,
    required this.timestamp,
    required this.base,
    required this.rates,
  });

  factory Ratesmodel.fromJson(Map<String, dynamic> json) => Ratesmodel(
        disclaimer: json["disclaimer"],
        license: json["license"],
        timestamp: json["timestamp"],
        base: json["base"],
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "disclaimer": disclaimer,
        "license": license,
        "timestamp": timestamp,
        "base": base,
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
