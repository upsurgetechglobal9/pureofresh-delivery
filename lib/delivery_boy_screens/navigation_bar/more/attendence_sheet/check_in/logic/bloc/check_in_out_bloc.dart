import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/check_in_out_repository.dart';

part 'check_in_out_event.dart';
part 'check_in_out_state.dart';

class CheckInOutBloc extends Bloc<CheckInOutEvent, CheckInOutState> {
  final CheckInOutRepository checkInOutRepository;

  CheckInOutBloc({required this.checkInOutRepository})
      : super(CheckInOutInitial()) {
    on<CheckInOutEvent>((event, emit) async {
      if (event is CheckInDetailsSendingEvent) {
        try {
          emit(CheckInDetailsLoadingState());
          await checkInOutRepository.checkInApi(
              checkinWearHelmet: event.checkinWearHelmet,
              checkinWearTshirt: event.checkinWearTshirt,
              checkinWearMask: event.checkinWearMask,
              checkInImage: event.checkInImage);
          emit(CheckInDetailsSuccessState());
        } catch (e) {
          print(e.toString());
        }
      }
      if (event is CheckOutDetailsSendingEvent) {
        try {
          emit(CheckoutDetailsLoadingState());
          await checkInOutRepository.checkOutApi(
              checkoutWearHelmet: event.checkoutWearHelmet,
              checkoutWearTshirt: event.checkoutWearTshirt,
              checkoutWearMask: event.checkoutWearMask,
              checkoutImage: event.checkoutImage);
          emit(CheckoutDetailsSuccessState());
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
