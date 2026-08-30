import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../models/my_earnings_model.dart';
import '../repository/my_earnings_repository.dart';

part 'my_earnings_event.dart';
part 'my_earnings_state.dart';

class MyEarningsBloc extends Bloc<MyEarningsEvent, MyEarningsState> {
  final MyEarningsRepository myEarningsRepository;
  MyEarningsBloc({required this.myEarningsRepository})
      : super(MyEarningsInitial()) {
    on<MyEarningsEvent>((event, emit) async {
      if (event is MyEarningsFetchingEvent) {
        try {
          MyEarningsModel myEarningsModel =
              await myEarningsRepository.myearningsApiCall(
            fromDate: event.fromDate,
            toDate: event.toDate,
          );
          emit(MyEarningsLoadingState());
          if (myEarningsModel.errCode == "valid") {

            // emit(state.copyWith(codFetchingCompleted: true));
            emit(MyEarningsSuccessState(myEarningsModel));
          }
          if (myEarningsModel.errCode == "invalid") {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(MyEarningsFailedState());
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
