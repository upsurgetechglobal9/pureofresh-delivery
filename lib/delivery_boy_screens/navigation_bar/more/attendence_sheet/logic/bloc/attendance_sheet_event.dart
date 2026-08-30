part of 'attendance_sheet_bloc.dart';

abstract class AttendanceSheetEvent extends Equatable {
  const AttendanceSheetEvent();

  @override
  List<Object> get props => [];
}

class AttendanceSheetFetchingEvent extends AttendanceSheetEvent {
  final String accessToken;

  const AttendanceSheetFetchingEvent({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}

class AttendanceCheckInValidationEvent extends AttendanceSheetEvent {
  final String accessToken;

  const AttendanceCheckInValidationEvent({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}

class AttendanceCheckOutValidationEvent extends AttendanceSheetEvent {
  final String accessToken;

  const AttendanceCheckOutValidationEvent({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}
