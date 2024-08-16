// To parse this JSON data, do
//
//     final reverseGeoGeocodingModel = reverseGeoGeocodingModelFromJson(jsonString);

import 'dart:convert';

ReverseGeoGeocodingModel reverseGeoGeocodingModelFromJson(String str) =>
    ReverseGeoGeocodingModel.fromJson(json.decode(str));

String reverseGeoGeocodingModelToJson(ReverseGeoGeocodingModel data) =>
    json.encode(data.toJson());

class ReverseGeoGeocodingModel {
  String? placeId;
  String? licence;
  String? osmType;
  String? osmId;
  String? lat;
  String? lon;
  String? displayName;
  Address? address;
  List<String>? boundingbox;

  ReverseGeoGeocodingModel({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.displayName,
    this.address,
    this.boundingbox,
  });

  factory ReverseGeoGeocodingModel.fromJson(Map<String, dynamic> json) =>
      ReverseGeoGeocodingModel(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        boundingbox: json["boundingbox"] == null
            ? []
            : List<String>.from(json["boundingbox"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "address": address?.toJson(),
        "boundingbox": boundingbox == null
            ? []
            : List<dynamic>.from(boundingbox!.map((x) => x)),
      };
}

class Address {
  String? it;
  String? road;
  String? hamlet;
  String? village;
  String? yes;
  String? city;
  String? county;
  String? stateDistrict;
  String? state;
  String? postcode;
  String? country;
  String? countryCode;

  Address({
    this.it,
    this.road,
    this.hamlet,
    this.village,
    this.yes,
    this.city,
    this.county,
    this.stateDistrict,
    this.state,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        it: json["it"],
        road: json["road"],
        hamlet: json["hamlet"],
        village: json["village"],
        yes: json["yes"],
        city: json["city"],
        county: json["county"],
        stateDistrict: json["state_district"],
        state: json["state"],
        postcode: json["postcode"],
        country: json["country"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "it": it,
        "road": road,
        "hamlet": hamlet,
        "village": village,
        "yes": yes,
        "city": city,
        "county": county,
        "state_district": stateDistrict,
        "state": state,
        "postcode": postcode,
        "country": country,
        "country_code": countryCode,
      };
}
