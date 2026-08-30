import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/my_profile_details_model.dart';
import '../../repository/support_help_repository.dart';

part 'support_help_event.dart';
part 'support_help_state.dart';

class SupportHelpBloc extends Bloc<SupportHelpEvent, SupportHelpState> {
  final SupportHelpRepository supportHelpRepository;

  SupportHelpBloc({required this.supportHelpRepository})
      : super(SupportHelpInitial()) {
    on<SupportHelpEvent>((event, emit) async {
      if (event is ProfileDetailsFetchingEvent) {
        try {
          emit(ProfileDetailsLoadingState());
          MyProfileDetailsModel myProfileDetailsModel =
              await supportHelpRepository.myProfileDetails();
          if (myProfileDetailsModel.errCode == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ProfileDetailsSuccessState(myProfileDetailsModel));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is ProfileAddDetailsEvent) {
        try {
          emit(ProfileDetailsLoadingState());
          final response = await supportHelpRepository.addingProfileDetails(
              image: event.image, name: event.name, languages: event.languages);
          if (response == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ProfileAddedSuccessState());
          }
        } catch (e) {
         if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is OrderEarningIssueEvent) {
        try {
          // emit(ProfileDetailsLoadingState());
          final response = await supportHelpRepository.orderEarningIssueApiCall(
              image: event.image,
              description: event.description,
              orderId: event.orderId);
          emit(OrderIssueSuccessState());

          if (response == 'valid') {
            Fluttertoast.showToast(msg: "Updated successfully");

            // emit(OrderIssueSuccessState());
          }
          if (response == 'invalid_form') {
            Fluttertoast.showToast(msg: "Updation failed");
            // emit(OrderIssueSuccessState());
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is IncentivesnPayoutIssueEvent) {
        try {
          // emit(ProfileDetailsLoadingState());
          final response = await supportHelpRepository.incentivesIssueApiCall(
              image: event.image,
              description: event.description,
              transId: event.transId);
          if (response == 'valid') {
            Fluttertoast.showToast(msg: "Updated successfully");
          }
          if (response == 'invalid_form') {
            Fluttertoast.showToast(msg: "Updation failed");
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is CodCashIssueEvent) {
        try {
          // emit(ProfileDetailsLoadingState());
          final response = await supportHelpRepository.codCashIssueApiCall(
              image: event.image,
              description: event.description,
              transId: event.transId);
          if (response == 'valid') {
            emit(CodCashIssueSuccessState());
            Fluttertoast.showToast(msg: "Updated successfully");
          }
          if (response == 'invalid_form') {
            Fluttertoast.showToast(msg: "Updation failed");
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is AnyOtherIssueEvent) {
        try {
          // emit(ProfileDetailsLoadingState());
          final response = await supportHelpRepository.anyOtherIssueApiCall(
            image: event.image,
            description: event.description,
          );
          if (response == 'valid') {
            Fluttertoast.showToast(msg: "Updated successfully");
          }
          if (response == 'invalid_form') {
            Fluttertoast.showToast(msg: "Updation failed");
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
