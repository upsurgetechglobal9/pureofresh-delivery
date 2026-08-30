part of 'new_order_bloc.dart';

abstract class NewOrderEvent extends Equatable {
  const NewOrderEvent();

  @override
  List<Object> get props => [];
}

class NewOrderDetailsEvent extends NewOrderEvent {
  final String refId;
  String? apptype;

  NewOrderDetailsEvent({required this.refId, this.apptype});
  @override
  List<Object> get props => [refId, apptype!];
}

class AcceptingOrderEvent extends NewOrderEvent {
  final String refId;

  const AcceptingOrderEvent({
    required this.refId,
  });
  @override
  List<Object> get props => [refId];
}

class AcceptingOrderCabEvent extends NewOrderEvent {
  final String refId;
  final String apptype;

  const AcceptingOrderCabEvent({required this.refId, required this.apptype});
  @override
  List<Object> get props => [refId];
}

class ReachedToRestrantLocationEvent extends NewOrderEvent {
  final String refId;

  const ReachedToRestrantLocationEvent({
    required this.refId,
  });
  @override
  List<Object> get props => [refId];
}

class CabReachedToRestrantLocationEvent extends NewOrderEvent {
  final String refId;
  final String apptype;

  const CabReachedToRestrantLocationEvent(
      {required this.refId, required this.apptype});
  @override
  List<Object> get props => [refId];
}

class PickupfromRestrantLocationAndOutforDeliveryEvent extends NewOrderEvent {
  final String refId;
  final String exchange1;
  final String exchange2;
  final String exchange3;

  const PickupfromRestrantLocationAndOutforDeliveryEvent({
    required this.refId,
    required this.exchange1,
    required this.exchange2,
    required this.exchange3,
  });
  @override
  List<Object> get props => [refId, exchange1, exchange2, exchange3];
}

class ReachedDeliveryLocationEvent extends NewOrderEvent {
  final String refId;

  const ReachedDeliveryLocationEvent({
    required this.refId,
  });
  @override
  List<Object> get props => [refId];
}

class CollectingCashEvent extends NewOrderEvent {
  final String amount;

  const CollectingCashEvent({
    required this.amount,
  });
  @override
  List<Object> get props => [amount];
}

class CompleteOrderEvent extends NewOrderEvent {
  final String otp;
  const CompleteOrderEvent(this.otp);
  @override
  List<Object> get props => [otp];
}

class CompleteOrderCabEvent extends NewOrderEvent {
  final String refId;
  final String apptype;

  const CompleteOrderCabEvent({required this.refId, required this.apptype});
  @override
  List<Object> get props => [refId, apptype];
}

class CompleteStopCabEvent extends NewOrderEvent {
  final String refId;
  final String apptype;
  final String locationId;

  const CompleteStopCabEvent(
      {required this.refId, required this.apptype, required this.locationId});
  @override
  List<Object> get props => [refId, apptype];
}

class SendingOTPEvent extends NewOrderEvent {
  final String refId;
  final String apptype;
  final String otp;

  const SendingOTPEvent(
      {required this.otp, required this.refId, required this.apptype});
  @override
  List<Object> get props => [otp];
}
