import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/basic_information.dart/repository/repository.dart';

part 'register_data_state.dart';

class RegisterDataCubit extends Cubit<RegisterDataState> {
  final BasicInformationRepository basicInformationRepository;
  RegisterDataCubit(this.basicInformationRepository)
      : super(const RegisterDataState());

  void doregisterData({
    required String selectedTypeId,
    required String vechileTypeId,
    required String name,
    required String email,
    required String mobileNumber,
    required String gender,
    required String age,
    required String laguages,
    required String latitude,
    required String longitude,
  }) async {
    try {
      emit(state.copyWith(dataLoading: true));
      final isRegisterSucess =
          await basicInformationRepository.basicRegisterationNew(
              selectedTypeId: selectedTypeId,
              vechileTypeId: vechileTypeId,
              name: name,
              email: email,
              mobileNumber: mobileNumber,
              gender: gender,
              age: age,
              laguages: laguages,
              latitude: latitude,
              longitude: longitude);
      emit(state.copyWith(isRegisterSucess: isRegisterSucess));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
