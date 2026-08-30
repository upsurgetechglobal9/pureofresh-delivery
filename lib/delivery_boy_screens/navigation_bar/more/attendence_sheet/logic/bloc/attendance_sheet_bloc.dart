import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/attendence_sheet_model.dart';
import '../../repository/attendance_sheet_repository.dart';

part 'attendance_sheet_event.dart';
part 'attendance_sheet_state.dart';

class AttendanceSheetBloc
    extends Bloc<AttendanceSheetEvent, AttendanceSheetState> {
  final AttendanceSheetReposotory attendanceSheetReposotory;

  AttendanceSheetBloc({required this.attendanceSheetReposotory})
      : super(AttendanceSheetInitial()) {
    on<AttendanceSheetEvent>((event, emit) async {
      if (event is AttendanceSheetFetchingEvent) {
        try {
          AttendanceDetailsModel attendanceDetailsModel =
              await attendanceSheetReposotory.attendanceDetails(
            accessToken: event.accessToken,
          );
          if (attendanceDetailsModel.errCode == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(AttendanceDetailsLoaded(attendanceDetailsModel));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is AttendanceCheckInValidationEvent) {
        try {
          final response =
              await attendanceSheetReposotory.checkInValidationDetails(
            accessToken: event.accessToken,
          );
          if (response == 'valid') {
            emit(CheckInValidSuccessSate(response));
          } else if (response == 'invalid') {

            emit(CheckInValidFaildSate(response));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is AttendanceCheckOutValidationEvent) {
        try {
          final response =
              await attendanceSheetReposotory.checkOutValidationDetails(
            accessToken: event.accessToken,
          );
          if (response == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CheckOutValidSuccessSate(response));
          } else if (response == 'invalid') {
            emit(CheckOutValidFaildSate(response));
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
