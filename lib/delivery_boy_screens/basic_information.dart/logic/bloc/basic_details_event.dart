part of 'basic_details_bloc.dart';

abstract class BasicDetailsEvent extends Equatable {
  const BasicDetailsEvent();

  @override
  List<Object> get props => [];
}

class AddBasicInformation extends BasicDetailsEvent {
  final String mobileNumber;
  final String name;
  final String age;
  final String emailId;
  final String laguage;
  final String gender;
  final String latitude;
  final String longitude;
  const AddBasicInformation(
      {required this.mobileNumber,
      required this.name,
      required this.age,
      required this.emailId,
      required this.laguage,
      required this.gender,
      required this.latitude,
      required this.longitude});
  @override
  List<Object> get props =>
      [mobileNumber, name, age, emailId, latitude, longitude];
}

class VerifyOtpEvent extends BasicDetailsEvent {
  final String mobileNumber;
  final String otp;
  final String type;

  const VerifyOtpEvent(
      {required this.mobileNumber, required this.otp, required this.type});
  @override
  List<Object> get props => [mobileNumber, otp, type];
}
