part of 'basic_details_bloc.dart';

abstract class BasicDetailsState extends Equatable {
  const BasicDetailsState();

  @override
  List<Object> get props => [];
}

class BasicDetailsInitial extends BasicDetailsState {}

class ShowVerifyOtpState extends BasicDetailsState {}

class VerifyOtpLoading extends BasicDetailsState {}

class VerifyOtpSuccess extends BasicDetailsState {}

class VerifyOtpFail extends BasicDetailsState {}
