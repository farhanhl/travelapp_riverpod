import 'package:dartz/dartz.dart';
import 'package:travel/core/error/failures.dart';
import 'package:travel/features/data/datasources/trip_local_datasource.dart';
import 'package:travel/features/data/models/trip_model.dart';
import 'package:travel/features/domain/entities/trip.dart';
import 'package:travel/features/domain/repositories/trip_repository.dart';

class TripRepositoryImpl extends TripRepository {
  final TripLocalDatasource tripLocalDatasource;
  TripRepositoryImpl(this.tripLocalDatasource);

  @override
  Future<void> addTrip(Trip trip) async {
    final tripModel = TripModel.fromEntity(trip);
    tripLocalDatasource.addTrip(tripModel);
  }

  @override
  Future<void> deleteTrip(int id) async {
    tripLocalDatasource.deleteTrip(id);
  }

  @override
  Future<Either<Failure, List<Trip>>> getTrips() async {
    try {
      final tripModels = tripLocalDatasource.getTrips();
      List<Trip> res = tripModels.map((model) => model.toEntity()).toList();
      return Right(res);
    } catch (error) {
      return Left(SomeSpecificError(error.toString()));
    }
  }
}
