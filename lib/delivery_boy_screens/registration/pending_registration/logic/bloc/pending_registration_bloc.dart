import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../model/pending_registaion_model.dart';
import '../../repository/pending_repository.dart';

part 'pending_registration_event.dart';
part 'pending_registration_state.dart';

class PendingRegistrationBloc
    extends Bloc<PendingRegistrationEvent, PendingRegistrationState> {
  final PendingRepository pendingRepository;

  PendingRegistrationBloc({required this.pendingRepository})
      : super(PendingRegistrationInitial()) {
    on<PendingRegistrationEvent>((event, emit) async {
      if (event is PendingfetchingEvent) {
        try {
          RegistrationPendingModel registrationPendingModel =
              await pendingRepository.pendingScreens();
          if (registrationPendingModel.data != null) {
            emit(PendingRegisterSuccssState(registrationPendingModel));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }
    });
  }
}
