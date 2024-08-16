import 'dart:convert';

OpenWeatherDataModel openWeatherDataModelFromJson(String str) =>
    OpenWeatherDataModel.fromJson(json.decode(str));

String openWeatherDataModelToJson(OpenWeatherDataModel data) =>
    json.encode(data.toJson());

class OpenWeatherDataModel {
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Rain? rain; // Make rain nullable
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  OpenWeatherDataModel({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.rain,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  factory OpenWeatherDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException("Null JSON provided to OpenWeatherDataModel");
    }
    return OpenWeatherDataModel(
      coord: Coord.fromJson(json["coord"] ?? {}),
      weather: (json["weather"] as List<dynamic>? ?? [])
          .map((e) => Weather.fromJson(e ?? {}))
          .toList(),
      base: json["base"] ?? "",
      main: Main.fromJson(json["main"] ?? {}),
      visibility: json["visibility"] ?? 0,
      wind: Wind.fromJson(json["wind"] ?? {}),
      rain: json["rain"] != null ? Rain.fromJson(json["rain"]) : null,
      clouds: Clouds.fromJson(json["clouds"] ?? {}),
      dt: json["dt"] ?? 0,
      sys: Sys.fromJson(json["sys"] ?? {}),
      timezone: json["timezone"] ?? 0,
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      cod: json["cod"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "coord": coord.toJson(),
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
        "base": base,
        "main": main.toJson(),
        "visibility": visibility,
        "wind": wind.toJson(),
        "rain": rain?.toJson(), // Use ?.toJson() for nullable types
        "clouds": clouds.toJson(),
        "dt": dt,
        "sys": sys.toJson(),
        "timezone": timezone,
        "id": id,
        "name": name,
        "cod": cod,
      };
}

class Clouds {
  final int all;

  Clouds({
    required this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic>? json) {
    return Clouds(
      all: json?["all"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}

class Coord {
  final double lon;
  final double lat;

  Coord({
    required this.lon,
    required this.lat,
  });

  factory Coord.fromJson(Map<String, dynamic>? json) {
    return Coord(
      lon: json?["lon"]?.toDouble() ?? 0.0,
      lat: json?["lat"]?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
      };
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int? seaLevel; // Make seaLevel nullable
  final int? grndLevel; // Make grndLevel nullable

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic>? json) {
    return Main(
      temp: json?["temp"]?.toDouble() ?? 0.0,
      feelsLike: json?["feels_like"]?.toDouble() ?? 0.0,
      tempMin: json?["temp_min"]?.toDouble() ?? 0.0,
      tempMax: json?["temp_max"]?.toDouble() ?? 0.0,
      pressure: json?["pressure"] ?? 0,
      humidity: json?["humidity"] ?? 0,
      seaLevel: json?["sea_level"],
      grndLevel: json?["grnd_level"],
    );
  }

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "pressure": pressure,
        "humidity": humidity,
        "sea_level": seaLevel,
        "grnd_level": grndLevel,
      };
}

class Rain {
  final double the1H;

  Rain({
    required this.the1H,
  });

  factory Rain.fromJson(Map<String, dynamic>? json) {
    return Rain(
      the1H: json?["1h"]?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        "1h": the1H,
      };
}

class Sys {
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic>? json) {
    return Sys(
      country: json?["country"] ?? "",
      sunrise: json?["sunrise"] ?? 0,
      sunset: json?["sunset"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "country": country,
        "sunrise": sunrise,
        "sunset": sunset,
      };
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic>? json) {
    return Weather(
      id: json?["id"] ?? 0,
      main: json?["main"] ?? "",
      description: json?["description"] ?? "",
      icon: json?["icon"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
      };
}

class Wind {
  final double speed;
  final int deg;
  final double? gust; // Make gust nullable

  Wind({
    required this.speed,
    required this.deg,
    this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic>? json) {
    return Wind(
      speed: json?["speed"]?.toDouble() ?? 0.0,
      deg: json?["deg"] ?? 0,
      gust: json?["gust"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
        "gust": gust,
      };
}
