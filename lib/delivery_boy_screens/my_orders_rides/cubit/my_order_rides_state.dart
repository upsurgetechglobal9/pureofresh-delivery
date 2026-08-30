part of 'my_order_rides_cubit.dart';

class MyOrderRidesState extends Equatable {
  final bool? dataLoad;
  final bool? dataLoadedSuccess;
  final MyOrdersRideModel? rideList;
  const MyOrderRidesState(
      {this.rideList, this.dataLoad, this.dataLoadedSuccess});

  @override
  List<Object?> get props => [rideList, dataLoad, dataLoadedSuccess];

  MyOrderRidesState copyWith(
      {MyOrdersRideModel? rideList, bool? dataLoadedSuccess, bool? dataLoad}) {
    return MyOrderRidesState(rideList: rideList ?? this.rideList,
    dataLoadedSuccess:dataLoadedSuccess??this.dataLoadedSuccess,
    dataLoad:dataLoad??this.dataLoad
    );
  }
}
