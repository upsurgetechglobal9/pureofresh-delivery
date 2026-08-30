import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/dashboard_details_model.dart';
import '../../repository/dashboard_details_repository.dart';

part 'dashboard_home_event.dart';
part 'dashboard_home_state.dart';

class DashboardHomeBloc extends Bloc<DashboardHomeEvent, DashboardHomeState> {
  final DashBoardDetailsReposotory dashBoardDetailsReposotory;

  DashboardHomeBloc({required this.dashBoardDetailsReposotory})
      : super(DashboardHomeInitial()) {
    on<DashboardHomeEvent>((event, emit) async {
      if (event is DashBoardDetailsFetchingEvent) {
        try {
          emit(DashboardLoadingState());
          DashBoardDetailsModel dashBoardDetailsModel =
              await dashBoardDetailsReposotory.dashBoardDetails(
            accessToken: event.accessToken,
          );
          if (dashBoardDetailsModel.errCode == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(DashBoardDetailsLoadedState(dashBoardDetailsModel));
          }
        } catch (e) {
          print(e.toString());
        }
      }
      if (event is UpdatingFirebaseKeyEvent) {
        try {
          await dashBoardDetailsReposotory.updatePushKey(
            accessToken: event.accessToken,
            fireBaseToken: event.pushNotificationFireKey,
            deviceId: event.deviceId,
          );
        } catch (e) {
          print(e.toString());
        }
      }
      if (event is BackgroundLoactionEvent) {
        try {
          final response =
              await dashBoardDetailsReposotory.backgroundLocationUpdate(
                  accessToken: event.accessToken,
                  latitude: event.latitude,
                  longitude: event.longitude);
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
