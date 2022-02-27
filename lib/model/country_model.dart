import 'dart:convert';

CountryModel countryFromJson(String str) => CountryModel.fromJson(json.decode(str));

String countryToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
  Data? data;

  CountryModel({
    this.data,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  List<CountryElements>? countries;

  Data({
    this.countries,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    countries: List<CountryElements>.from(json["countries"].map((x) => CountryElements.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "countries": List<dynamic>.from(countries!.map((x) => x.toJson())),
  };
}

class CountryElements {
  String? countryName;
  List<Language>? countryLanguages;

  CountryElements({
    this.countryName,
    this.countryLanguages,
  });


  factory CountryElements.fromJson(Map<String, dynamic> json) => CountryElements(
    countryName: json["name"],
    countryLanguages: json["languages"] != null ? List<Language>.from(json["languages"].map((x) => Language.fromJson(x))): [],
  );

  Map<String, dynamic> toJson() => {
    "name": countryName,
    "languages": List<dynamic>.from(countryLanguages!.map((x) => x.toJson())),
  };
}

class Language {
  String? code;
  String? name;

  Language({
    this.code,
    this.name,
  });


  factory Language.fromJson(Map<String, dynamic> json) => Language(
    code: json["code"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
  };
}
