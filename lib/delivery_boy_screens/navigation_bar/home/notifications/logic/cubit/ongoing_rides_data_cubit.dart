import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../repository/dashboard_details_repository.dart';
import '../../models/delivery_preferences_model.dart';
import '../../models/on_going_rides_list_data_model.dart';
import '../../models/single_ongoing_order_model.dart';

part 'ongoing_rides_data_state.dart';

class OngoingRidesDataCubit extends Cubit<OngoingRidesDataState> {
  DashBoardDetailsReposotory dashBoardDetailsReposotory;
  Timer? _timer;
  OngoingRidesDataCubit(this.dashBoardDetailsReposotory)
      : super(OngoingRidesDataState(
            ongoingRidesResponseModel:
                OngoingRidesResponseModel(errCode: '', data: []),
            deliveryServiceResponse: DeliveryServiceResponse(
                data: DeliveryServiceData(
                    isFood: false, isCab: false, isPickupAndDrop: false)),
            singleOngoingOrderModel:
                SingleOngoingOrderModel(errCode: '', data: []))) {
    _startTimer(); //need to uncomment
  }

// Future<void> fetchOngoingRides(String type) async {
  //   try {
  //     emit(state.copyWith(dataLoading: true));
  //     final ongoingRidesResponseModel =
  //         await dashBoardDetailsReposotory.fetchOngingRides(type);
  //     emit(
  //         state.copyWith(ongoingRidesResponseModel: ongoingRidesResponseModel));
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     if (isClosed) {
  //       return;
  //     }
  //     emit(state.copyWith(error: e.toString()));
  //   }
  // }

  Future<void> fetchSingleOrderData({final bool isLoading = false}) async {
    try {
      if (isLoading) {
        emit(state.copyWith(singleOrderdataLoading: true));
      }
      final singleOngoingOrderModel =
          await dashBoardDetailsReposotory.fetchSingleOrderList();
      emit(state.copyWith(singleOngoingOrderModel: singleOngoingOrderModel));
      if (singleOngoingOrderModel.data.isEmpty) {
        stopTimer();
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (isClosed) {
        return;
      }
      emit(state.copyWith(singleOrdererror: e.toString()));
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> closeF() {
    stopTimer();
    return super.close();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel the previous timer, if any
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _initTimerIfOnline();
      if (isClosed) {
        return;
      }
    });
  }

  Future<void> _initTimerIfOnline() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isOnline = prefs.getBool('status') ?? false;
      if (isOnline) {
        fetchSingleOrderData(isLoading: false);
      } else {
        stopTimer();
      }
    } catch (e) {
      // ignore prefs read errors; do not start timer on failure
    }
  }

  // Future<bool> fetchOnlineStatusFromApi() async {
  //   try {
  //     final formData = FormData.fromMap({
  //       'access_token': Constants.prefs!.getString("token"),
  //     });
  //     final dio = Dio();
  //     final response = await dio.post(
  //         "${UrlLinksData.serverUrl}Online_or_offline_status",
  //         data: formData);
  //     print("hereee $response");
  //     if (response.data['err_code'] == 'valid') {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<void> fetchDeliveryServices() async {
    try {
      emit(state.copyWith(deliveryServiceLoad: true));
      final deliveryServiceResponse =
          await dashBoardDetailsReposotory.fetchDeliveryPreferences();
      emit(state.copyWith(deliveryServiceResponse: deliveryServiceResponse));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (isClosed) {
        return;
      }
      emit(state.copyWith(deliveryServiceerror: e.toString()));
    }
  }
}
