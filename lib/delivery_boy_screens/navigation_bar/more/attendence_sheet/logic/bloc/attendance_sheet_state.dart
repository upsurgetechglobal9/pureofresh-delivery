part of 'attendance_sheet_bloc.dart';

abstract class AttendanceSheetState extends Equatable {
  const AttendanceSheetState();

  @override
  List<Object> get props => [];
}

class AttendanceSheetInitial extends AttendanceSheetState {}

class AttendanceDetailsLoaded extends AttendanceSheetState {
  final AttendanceDetailsModel attendanceDetailsModeldata;

  const AttendanceDetailsLoaded(this.attendanceDetailsModeldata);

  @override
  List<Object> get props => [attendanceDetailsModeldata];
}

class CheckInValidSuccessSate extends AttendanceSheetState {
  final String response;
  const CheckInValidSuccessSate(this.response);
}

class CheckOutValidSuccessSate extends AttendanceSheetState {
  final String response;
  const CheckOutValidSuccessSate(this.response);
}

class CheckInValidFaildSate extends AttendanceSheetState {
  final String response;
  const CheckInValidFaildSate(this.response);
}

class CheckOutValidFaildSate extends AttendanceSheetState {
  final String response;
  const CheckOutValidFaildSate(this.response);
}
