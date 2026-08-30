import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/login/models/driver_type_model.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/login/repository/driver_type_repository.dart';

part 'rider_type_selected_data_state.dart';

class RiderTypeSelectedDataCubit extends Cubit<RiderTypeSelectedDataState> {
  final RiderTypeRepository riderTypeRepository;
  RiderTypeSelectedDataCubit(this.riderTypeRepository)
      : super(const RiderTypeSelectedDataState());

  Future<void> featchRiderTypes() async {
    try {
      emit(state.copyWith(dataLoading: true));
      final riderTypeResponseModel =
          await riderTypeRepository.featchRiderTypes();
      emit(state.copyWith(riderTypeResponseModel: riderTypeResponseModel));
    } catch (e) {
      emit(state.copyWith());
    }
  }
}
