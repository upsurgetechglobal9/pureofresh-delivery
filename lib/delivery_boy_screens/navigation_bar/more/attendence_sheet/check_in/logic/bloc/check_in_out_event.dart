part of 'check_in_out_bloc.dart';

abstract class CheckInOutEvent extends Equatable {
  const CheckInOutEvent();

  @override
  List<Object> get props => [];
}

class CheckInDetailsSendingEvent extends CheckInOutEvent {
  final String checkinWearHelmet;
  final String checkinWearTshirt;
  final String checkinWearMask;
  final File checkInImage;

  const CheckInDetailsSendingEvent({
    required this.checkinWearHelmet,
    required this.checkinWearTshirt,
    required this.checkinWearMask,
    required this.checkInImage,
  });

  @override
  List<Object> get props =>
      [checkinWearHelmet, checkinWearTshirt, checkinWearMask, checkInImage];
}

class CheckOutDetailsSendingEvent extends CheckInOutEvent {
  final String checkoutWearHelmet;
  final String checkoutWearTshirt;
  final String checkoutWearMask;
  final File checkoutImage;

  const CheckOutDetailsSendingEvent({
    required this.checkoutWearHelmet,
    required this.checkoutWearTshirt,
    required this.checkoutWearMask,
    required this.checkoutImage,
  });

  @override
  List<Object> get props =>
      [checkoutWearHelmet, checkoutWearTshirt, checkoutWearMask, checkoutImage];
}
