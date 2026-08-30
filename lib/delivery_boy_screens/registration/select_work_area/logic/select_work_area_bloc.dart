import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../model/select_work_area_model.dart';
import '../repository/select_work_area_repository.dart';

part 'select_work_area_event.dart';
part 'select_work_area_state.dart';

class SelectWorkAreaBloc
    extends Bloc<SelectWorkAreaEvent, SelectWorkAreaState> {
  final SelectWorkAreaRepository selectWorkAreaRepository;

  SelectWorkAreaBloc({required this.selectWorkAreaRepository})
      : super(SelectWorkAreaInitial()) {
    on<SelectWorkAreaEvent>((event, emit) async {
      if (event is SelectWorkAreaFetching) {
        try {
          emit(LoadingState());
          SelectWorkAreaModel selectWorkAreaModel =
              await selectWorkAreaRepository.selectingWorkArea(
            cityId: event.cityId, keyWord: event.searchLetter,
          );
          if (selectWorkAreaModel.errCode != 'invalid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(SelectWorkAreaLoadedState(selectWorkAreaModel));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is WorkAreasetupEvent) {
        try {
          selectWorkAreaRepository.setupWorkLocation(
            cityId: event.cityId,
            locationId: event.locationId,
          );
          emit(NextButtonClickedState());
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
