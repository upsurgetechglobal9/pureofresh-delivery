part of 'firebase_store_data_cubit.dart';

 class FirebaseStoreDataState extends Equatable {
  final String? driverId;
  final String? driverName;
  final double? driverlatitude;
  final double? driverlongitude;
  const FirebaseStoreDataState({
    this.driverId,
    this.driverName,
    this.driverlatitude,
    this.driverlongitude,
  });

  @override
  List<Object?> get props => [driverId, driverName, driverlatitude, driverlongitude];

  FirebaseStoreDataState copyWith({
    String? driverId,
    String? driverName,
    double? driverlatitude,
    double? driverlongitude,
  }) {
    return FirebaseStoreDataState(
      driverId: driverId,
      driverName: driverName,
      driverlatitude: driverlatitude,
      driverlongitude: driverlongitude,
    );
  }
}

