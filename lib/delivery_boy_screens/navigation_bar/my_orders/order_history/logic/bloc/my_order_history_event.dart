part of 'my_order_history_bloc.dart';

abstract class MyOrderHistoryEvent extends Equatable {
  const MyOrderHistoryEvent();

  @override
  List<Object> get props => [];
}



class MyHistoryFetchingEvent extends MyOrderHistoryEvent {
  final String date;
  final String searchType;


  const MyHistoryFetchingEvent({
    required this.date,
    required this.searchType,

  });
  @override
  List<Object> get props => [date, searchType];
}
