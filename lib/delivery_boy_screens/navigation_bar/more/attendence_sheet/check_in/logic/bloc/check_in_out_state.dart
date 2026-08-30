part of 'check_in_out_bloc.dart';

abstract class CheckInOutState extends Equatable {
  const CheckInOutState();

  @override
  List<Object> get props => [];
}

class CheckInOutInitial extends CheckInOutState {}

class CheckInDetailsLoadingState extends CheckInOutState {}

class CheckInDetailsSuccessState extends CheckInOutState {}

class CheckoutDetailsLoadingState extends CheckInOutState {}

class CheckoutDetailsSuccessState extends CheckInOutState {}
