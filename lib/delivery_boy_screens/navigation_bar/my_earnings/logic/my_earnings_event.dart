part of 'my_earnings_bloc.dart';

abstract class MyEarningsEvent extends Equatable {
  const MyEarningsEvent();

  @override
  List<Object> get props => [];
}

class MyEarningsFetchingEvent extends MyEarningsEvent {
  final String fromDate;
  final String toDate;

  const MyEarningsFetchingEvent({
    required this.fromDate,
    required this.toDate,
  });
  @override
  List<Object> get props => [fromDate, toDate];
}
