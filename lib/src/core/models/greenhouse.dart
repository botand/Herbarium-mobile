import 'package:herbarium_mobile/src/core/models/plant.dart';
import 'package:herbarium_mobile/src/core/models/sensor_data.dart';

class Greenhouse {
  final String uuid;

  final String name;

  final List<Plant> plants;

  final SensorData? tankLevel;

  final DateTime lastTimestamp;

  final DateTime createdOn;

  Greenhouse(
      {required this.uuid,
      required this.name,
      this.plants = const [],
      this.tankLevel,
      required this.lastTimestamp,
      required this.createdOn});

  /// Get a plant based on its position in the greenhouse
  Plant? getPlant(int position) {
    for (Plant plant in plants) {
      if (plant.position == position) {
        return plant;
      }
    }
    return null;
  }

  TankStatus get tankStatus {
    if (tankLevel == null) {
      return TankStatus.unknown;
    }
    if (tankLevel != null && tankLevel!.value <= 0.0) {
      return TankStatus.empty;
    }
    if (tankLevel != null && tankLevel!.value < 20.0) {
      return TankStatus.nearlyEmpty;
    }
    return TankStatus.normal;
  }

  factory Greenhouse.fromJson(Map<String, dynamic> map) => Greenhouse(
      uuid: map["uuid"] as String,
      name: map["name"] as String,
      plants: map["plants"] != null
          ? (map["plants"] as List<dynamic>)
              .map((e) => Plant.fromJson(e))
              .toList()
          : [],
      tankLevel: map["tank_level"] != null
          ? SensorData.fromJson(map["tank_level"] as Map<String, dynamic>)
          : null,
      lastTimestamp: DateTime.parse(map['last_timestamp'] as String),
      createdOn: DateTime.parse(map['created_at'] as String));

  @override
  String toString() {
    return 'Greenhouse{uuid: $uuid, '
        'name: $name, '
        'plants: $plants, '
        'tankLevel: $tankLevel, '
        'lastTimestamp: $lastTimestamp, '
        'createdAt: $createdOn}';
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'plants': plants,
        'tank_level': tankLevel,
        'last_timestamp': lastTimestamp,
        'created_at': createdOn
      };
}

enum TankStatus { unknown, normal, nearlyEmpty, empty }
