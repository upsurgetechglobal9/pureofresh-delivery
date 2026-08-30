import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/new_order/models/cab_new_order_model.dart';

import '../models/new_order_model.dart';
import '../models/order_accepting_model.dart';
import '../repository/new_order_repository.dart';

part 'new_order_event.dart';
part 'new_order_state.dart';

class NewOrderBloc extends Bloc<NewOrderEvent, NewOrderState> {
  final NewOrderRepository newOrderRepository;
  NewOrderBloc({required this.newOrderRepository}) : super(NewOrderInitial()) {
    on<NewOrderEvent>((event, emit) async {
      if (event is NewOrderDetailsEvent) {
        try {
          emit(NewOrderLoadingState());

          if (event.apptype == 'cab' || event.apptype == 'pickupanddrop') {
            CabRideDetailModel newOrderDetailsModel =
                await newOrderRepository.newOrderCabDetailsApiCall(
                    referId: event.refId, apptype: event.apptype);
            emit(NewOrderDetailsCabSuccessState(newOrderDetailsModel));
          } else {
            NewOrderDetailsModel newOrderDetailsModel =
                await newOrderRepository.newOrderDetailsApiCall(
                    referId: event.refId, type: event.apptype);
            if (newOrderDetailsModel.errCode == 'valid') {
              emit(NewOrderDetailsSuccessState(newOrderDetailsModel));
            }
          }
        } catch (e) {
          emit(NewOrderFailedState());
        }
      }

      if (event is AcceptingOrderEvent) {
        try {
          OrderAcceptResponseModel orderAcceptResponseModel =
              await newOrderRepository.acceptingOrderApiCall(
            referId: event.refId,
          );

          if (orderAcceptResponseModel.errCode == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(OrderAcceptSuccessState(event.refId));
          }
          if (orderAcceptResponseModel.errCode == 'invalid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(OrderAcceptFailedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is AcceptingOrderCabEvent) {
        try {
          OrderAcceptResponseModel orderAcceptResponseModel =
              await newOrderRepository.acceptingOrderCabApiCall(
                  referId: event.refId, apptype: event.apptype);
          if (orderAcceptResponseModel.errCode == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(OrderAcceptCabSuccessState(event.refId));
          } else if (orderAcceptResponseModel.errCode == 'invalid') {
            Fluttertoast.showToast(msg: orderAcceptResponseModel.message);
            emit(OrderAcceptCabFailedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is ReachedToRestrantLocationEvent) {
        try {
          String responseData =
              await newOrderRepository.reachedtoRestarentApiCall(
            referId: event.refId,
          );

          if (responseData == "valid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ReachedtoRestarentSuccessState());
          } else if (responseData == "invalid") {
            //Fluttertoast.showToast(msg: responseData);
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ReachedRastrauntFailedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is CabReachedToRestrantLocationEvent) {
        try {
          final responseData =
              await newOrderRepository.cabReachedtoRestarentApiCall(
                  referId: event.refId, apptype: event.apptype);

          if (responseData.errCode == "valid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CabReachedtoRestarentSuccessState());
          }
          if (responseData.errCode == "invalid") {
            // Fluttertoast.showToast(msg: responseData.message.toString());
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CabReachedRastrauntFailedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is PickupfromRestrantLocationAndOutforDeliveryEvent) {
        try {
          String responseData = await newOrderRepository
              .pickUpFromrestarantAndOutforDeliveryApiCall(
                  referId: event.refId,
                  exchangeItem1: event.exchange1,
                  exchangeItem2: event.exchange2,
                  exchangeItem3: event.exchange3);

          if (responseData == "valid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ReachedDeliverySuccessState());
          }
          if (responseData == "invalid") {
            // Fluttertoast.showToast(msg: responseData.toString());

            // emit(state.copyWith(codFetchingCompleted: true));
            // Fluttertoast.showToast(
            //     msg: "Order Not Ready, Please Contact Store");
            emit(PickUpRestrantFailedState());
          }
          if (responseData == "invalid_complete") {
            //Fluttertoast.showToast(msg: responseData.toString());

            // emit(state.copyWith(codFetchingCompleted: true));
            // Fluttertoast.showToast(
            //     msg: "Order might be completed or Cancelled");
            emit(PickUpRestrantcompleteFailedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is ReachedDeliveryLocationEvent) {
        try {
          String responseData = await newOrderRepository.reachedDeliveryApiCall(
            referId: event.refId,
          );

          if (responseData == "valid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ReachedDeliverySuccessState());
          }
          if (responseData == "invalid") {
            //Fluttertoast.showToast(msg: responseData.toString());

            // emit(state.copyWith(codFetchingCompleted: true));
            emit(OrderAcceptFailedState());
          }
        } catch (e) {
          print(e.toString());
        }
      }

      if (event is CompleteOrderEvent) {
        try {
          String responseData = await newOrderRepository.completeOrderApiCall(otp: event.otp);

          if (responseData == "valid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CompletingOrdeSuccessState());
          }
          if (responseData == "invalid") {
            //Fluttertoast.showToast(msg: responseData.toString());

            // emit(state.copyWith(codFetchingCompleted: true));
            // emit(CollectingCashFailedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is CompleteStopCabEvent) {
        try {
          String responseData =
              await newOrderRepository.completeStopsCabApiCall(
                  referId: event.refId,
                  apptype: event.apptype,
                  locationId: event.locationId);

          if (responseData == "valid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CompletingStopCabSuccessState());
          }
          if (responseData == "invalid") {
            //Fluttertoast.showToast(msg: responseData.toString());
            emit(CompletingStopCabFailState());
            // emit(state.copyWith(codFetchingCompleted: true));
            // emit(CollectingCashFailedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is CompleteOrderCabEvent) {
        try {
          String responseData =
              await newOrderRepository.completeOrderCabApiCall(
                  referId: event.refId, apptype: event.apptype);

          if (responseData == "valid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CompletingOrdeCabSuccessState());
          }
          if (responseData == "invalid") {
            // Fluttertoast.showToast(msg: responseData.toString());

            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CompletingOrdeCabFailState());
            // emit(CollectingCashFailedState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is SendingOTPEvent) {
        try {
          final responseData = await newOrderRepository.otpfromUserApiCall(
              pin: event.otp, apptype: event.apptype, referId: event.refId);

          if (responseData.errCode == "valid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(SendingOTPSuccessState());
          }
          if (responseData.errCode == "invalid") {
            //Fluttertoast.showToast(msg: responseData.message.toString());

            emit(SendingOTPFailureState());
            // emit(state.copyWith(codFetchingCompleted: true));
            // emit(CollectingCashFailedState());
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
