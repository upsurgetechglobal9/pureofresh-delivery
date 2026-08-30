part of 'payout_history_bloc.dart';

abstract class PayoutHistoryEvent extends Equatable {
  const PayoutHistoryEvent();

  @override
  List<Object> get props => [];
}

class PayoutFetchingEvent extends PayoutHistoryEvent {
  final String fromDate;
  final String toDate;

  const PayoutFetchingEvent({
    required this.fromDate,
    required this.toDate,
  });
  @override
  List<Object> get props => [fromDate, toDate];
}
