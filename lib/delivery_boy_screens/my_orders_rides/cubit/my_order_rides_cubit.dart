import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/my_orders_model.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/my_orders_rides_repository.dart';

part 'my_order_rides_state.dart';

class MyOrderRidesCubit extends Cubit<MyOrderRidesState> {
  final MyOrdersRidesRepository myOrdersRidesRepository;
  MyOrderRidesCubit(this.myOrdersRidesRepository) : super(MyOrderRidesState());

  Future<void> fecthRideList(type) async {
    try {
      emit(state.copyWith(dataLoad: true, dataLoadedSuccess: false));
      final location = await myOrdersRidesRepository.fecthRideList(type: type);
      emit(state.copyWith(
          rideList: location, dataLoad: false, dataLoadedSuccess: true));
    } catch (e) {
      emit(state.copyWith());
    }
  }
}
