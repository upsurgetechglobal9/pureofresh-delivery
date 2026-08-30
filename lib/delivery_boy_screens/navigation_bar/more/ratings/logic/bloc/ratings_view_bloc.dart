import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../attendence_sheet/models/attendence_sheet_model.dart';
import '../../models/ratings_view_model.dart';
import '../../repository/ratings_view_repository.dart';

part 'ratings_view_event.dart';
part 'ratings_view_state.dart';

class RatingsViewBloc extends Bloc<RatingsViewEvent, RatingsViewState> {
  final RatingsViewRepository ratingsViewRepository;

  RatingsViewBloc({required this.ratingsViewRepository})
      : super(RatingsViewInitial()) {
    on<RatingsViewEvent>((event, emit) async {
      
      if (event is RatingsViewFetchingEvent) {
        try {
          RatingsViewModel ratingsViewModel =
              await RatingsViewRepository().getRatingDetails(
            accessToken: event.accessToken,
          );
          if (ratingsViewModel.errCode == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(RatingDetailsLoaded(ratingsViewModel));
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
