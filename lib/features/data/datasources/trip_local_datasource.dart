import 'package:hive/hive.dart';
import 'package:travel/features/data/models/trip_model.dart';

class TripLocalDatasource {
  final Box<TripModel> tripBox;
  TripLocalDatasource(this.tripBox);

  List<TripModel> getTrips() {
    return tripBox.values.toList();
  }

  void addTrip(TripModel trip) {
    tripBox.add(trip);
  }

  void deleteTrip(int id) {
    tripBox.deleteAt(id);
  }
}
