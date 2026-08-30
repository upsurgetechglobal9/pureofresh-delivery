import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/payout_history_model.dart';
import '../../repository/payouts_repository.dart';

part 'payout_history_event.dart';
part 'payout_history_state.dart';

class PayoutHistoryBloc extends Bloc<PayoutHistoryEvent, PayoutHistoryState> {
  final PayoutHistorysRepository payoutHistorysRepository;
  PayoutHistoryBloc({required this.payoutHistorysRepository})
      : super(PayoutHistoryInitial()) {
    on<PayoutHistoryEvent>((event, emit) async {
      if (event is PayoutFetchingEvent) {
        try {
          PayoutHistoryModel payoutHistoryModel =
              await payoutHistorysRepository.PayoutHistoryApiCall(
            fromDate: event.fromDate,
            toDate: event.toDate,
          );
          print("object  ${payoutHistoryModel.errCode} SS");
          if (payoutHistoryModel.errCode == "valid") {
            print("emit ${payoutHistoryModel.message} dataa");

            // emit(state.copyWith(codFetchingCompleted: true));
            emit(PayoutHistorySuccessState(payoutHistoryModel));
          }
          if (payoutHistoryModel.errCode == "invalid") {
            print("emit  r ${payoutHistoryModel.data}");

            // emit(state.copyWith(codFetchingCompleted: true));
            emit(PayoutHistoryInavalidState());
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
