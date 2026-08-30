part of 'new_order_bloc.dart';

abstract class NewOrderState extends Equatable {
  const NewOrderState();

  @override
  List<Object> get props => [];
}

class NewOrderInitial extends NewOrderState {}

class NewOrderLoadingState extends NewOrderState {}

class NewOrderDetailsSuccessState extends NewOrderState {
  final NewOrderDetailsModel newOrderDetailsModel;

  const NewOrderDetailsSuccessState(this.newOrderDetailsModel);

  @override
  List<Object> get props => [newOrderDetailsModel];
}

class NewOrderDetailsCabSuccessState extends NewOrderState {
  final CabRideDetailModel newOrderDetailsModel;

  const NewOrderDetailsCabSuccessState(this.newOrderDetailsModel);

  @override
  List<Object> get props => [newOrderDetailsModel];
}

class OrderAcceptSuccessState extends NewOrderState {
  final String refId;

  const OrderAcceptSuccessState(this.refId);

  @override
  List<Object> get props => [refId];
}

class OrderAcceptCabSuccessState extends NewOrderState {
  final String refId;

  const OrderAcceptCabSuccessState(this.refId);

  @override
  List<Object> get props => [refId];
}

class ReachedPickupSuccessState extends NewOrderState {
  final String refId;

  const ReachedPickupSuccessState(this.refId);

  @override
  List<Object> get props => [refId];
}

class OrderAcceptFailedState extends NewOrderState {}

class OrderAcceptCabFailedState extends NewOrderState {}

class ReachedRastrauntFailedState extends NewOrderState {}

class CabReachedRastrauntFailedState extends NewOrderState {}

class NewOrderFailedState extends NewOrderState {}

class ReachedtoRestarentSuccessState extends NewOrderState {}

class CabReachedtoRestarentSuccessState extends NewOrderState {}

class ReachedDeliverySuccessState extends NewOrderState {}

class CollectingCashSuccessState extends NewOrderState {}

class CompletingOrdeSuccessState extends NewOrderState {}

class CompletingStopCabSuccessState extends NewOrderState {}

class CompletingStopCabFailState extends NewOrderState {}

class CompletingOrdeCabSuccessState extends NewOrderState {}

class CompletingOrdeCabFailState extends NewOrderState {}

class SendingOTPSuccessState extends NewOrderState {}

class SendingOTPFailureState extends NewOrderState {}

class PickUpRestrantFailedState extends NewOrderState {}

class PickUpRestrantcompleteFailedState extends NewOrderState {}
