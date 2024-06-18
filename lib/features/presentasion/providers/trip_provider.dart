import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:travel/features/data/datasources/trip_local_datasource.dart';
import 'package:travel/features/data/models/trip_model.dart';
import 'package:travel/features/data/repositories/trip_repository_impl.dart';
import 'package:travel/features/domain/entities/trip.dart';
import 'package:travel/features/domain/repositories/trip_repository.dart';
import 'package:travel/features/domain/usecases/add_trip.dart';
import 'package:travel/features/domain/usecases/delete_trip.dart';
import 'package:travel/features/domain/usecases/get_trips.dart';

final tripLocalDatasourceProvider = Provider<TripLocalDatasource>((ref) {
  final Box<TripModel> tripBox = Hive.box('trips');
  return TripLocalDatasource(tripBox);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final tripLocalDatasource = ref.read(tripLocalDatasourceProvider);
  return TripRepositoryImpl(tripLocalDatasource);
});

final addTripProvider = Provider<AddTrip>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return AddTrip(repository);
});

final getTripsProvider = Provider<GetTrips>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return GetTrips(repository);
});

final deleteTripProvider = Provider<DeleteTrip>((ref) {
  final repository = ref.read(tripRepositoryProvider);
  return DeleteTrip(repository);
});

final tripListNotifierProvider =
    StateNotifierProvider<TripListNotifier, List<Trip>>((ref) {
  final getTrips = ref.read(getTripsProvider);
  final addTrip = ref.read(addTripProvider);
  final deleteTrip = ref.read(deleteTripProvider);

  return TripListNotifier(getTrips, addTrip, deleteTrip);
});

class TripListNotifier extends StateNotifier<List<Trip>> {
  final GetTrips _getTrips;
  final AddTrip _addTrip;
  final DeleteTrip _deleteTrip;

  TripListNotifier(
    this._getTrips,
    this._addTrip,
    this._deleteTrip,
  ) : super([]);

  Future<void> loadTrips() async {
    final tripsOrFailure = await _getTrips();
    tripsOrFailure.fold((error) => state = [], (trips) => state = trips);
  }

  Future<void> addNewTrip(Trip trip) async {
    await _addTrip(trip);
  }

  Future<void> removeTrip(int tripId) async {
    await _deleteTrip(tripId);
  }
}
