import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/fines_model.dart';
import '../../repository/fines_repository.dart';

part 'fines_event.dart';
part 'fines_state.dart';

class FinesBloc extends Bloc<FinesEvent, FinesState> {
  final FinesRepository finesRepository;

  FinesBloc({required this.finesRepository}) : super(FinesInitial()) {
    on<FinesEvent>((event, emit) async {
      if (event is FinesFetchingEvent) {
        try {
          FinesModel finesModel = await finesRepository.finesApiCall();
          if (finesModel.errCode == 'valid') {
            emit(FinesSuccess(finesModel));
          }
        } catch (e) {
          emit(FinesErrorState(e.toString()));
        }
      }
    });
  }
}
