import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../repository/select_vehicle_repository.dart';

part 'vehicle_information_event.dart';
part 'vehicle_information_state.dart';

class VehicleInformationBloc
    extends Bloc<VehicleInformationEvent, VehicleInformationState> {
  final SelectVehicleRepository selectVehicleRepository;

  VehicleInformationBloc({required this.selectVehicleRepository})
      : super(VehicleInformationInitial()) {
    on<VehicleInformationEvent>((event, emit) async {
      if (event is AddVehicleDetailsEvent) {
        try {
          emit(VehicleDetailsLoadingState());
          final registerResponce =
              await selectVehicleRepository.vehicleRegisteration(
            vehicleType: event.vehicleType,
            vehicleNumber: event.vehicleNumber,
            vehicleValidity: event.vehicleValidity,
            drivingLicenseNumber: event.drivingLicenseNumber,
            drivingLicensePhoto: event.drivingLicensePhoto,
            vehiclePhoto: event.vehiclePhoto,
            vehiclePhoto2: event.vehiclePhoto2,
            rc1: event.rc1,
            rc2: event.rc2,
            vehicleName: event.vehicleName,
            drivingLicensePhotoTwo: event.drivingLicensePhotoTwo,
          );
          print('response IN');
          print(registerResponce);
          if(registerResponce == 'valid'){
            emit(VehicleDetailsSuccessState()); 
          }else if(registerResponce == 'invalid'){
            print('Invalid CAse');
            emit(VehicleDetailsFaildeState());
          }
         // emit(VehicleDetailsSuccessState());
          // print("emit${res}");
          // if (referAFriendModel.message != null) {
          //   print("emit${referAFriendModel.message}");
          //   // emit(state.copyWith(codFetchingCompleted: true));
          // emit(VerifyOtp(res));
          // }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
