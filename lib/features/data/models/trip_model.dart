import 'package:hive/hive.dart';
import 'package:travel/features/domain/entities/trip.dart';
part 'trip_model.g.dart';

@HiveType(typeId: 0)
class TripModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String location;

  TripModel({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
  });

  factory TripModel.fromEntity(Trip trip) => TripModel(
        title: trip.title,
        description: trip.description,
        date: trip.date,
        location: trip.location,
      );

  Trip toEntity() => Trip(
        title: title,
        description: description,
        date: date,
        location: location,
      );
}
