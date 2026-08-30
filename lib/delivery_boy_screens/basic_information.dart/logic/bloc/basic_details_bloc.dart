import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../repository/repository.dart';
part 'basic_details_event.dart';
part 'basic_details_state.dart';

class BasicDetailsBloc extends Bloc<BasicDetailsEvent, BasicDetailsState> {
  final BasicInformationRepository basicInformationRepository;
  BasicDetailsBloc({required this.basicInformationRepository})
      : super(BasicDetailsInitial()) {
    on<BasicDetailsEvent>((event, emit) async {
      if (event is AddBasicInformation) {
        try {
          final registerResponce =
              await basicInformationRepository.basicRegisteration(
            mobileNumber: event.mobileNumber,
            name: event.name,
            age: event.age,
            email: event.emailId,
            gender: event.gender,
            laguages: event.laguage,
            latitude: event.latitude,
            longitude: event.longitude,
          );
          Fluttertoast.showToast(msg: registerResponce);
          emit(ShowVerifyOtpState());
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is VerifyOtpEvent) {
        try {
          emit(VerifyOtpLoading());
          final otpResponce = await basicInformationRepository.verifyOTP(
              mobileNumber: event.mobileNumber,
              otp: event.otp,
              type: event.type);
          if (otpResponce == 'valid') {
            emit(VerifyOtpSuccess());
          } else {
            emit(VerifyOtpFail());
          }
          // if (referAFriendModel.message != null) {
          //   // emit(state.copyWith(codFetchingCompleted: true));
          // emit(VerifyOtp(res));
          // }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }
    });
  }
}
