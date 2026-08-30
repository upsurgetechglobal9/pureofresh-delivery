part of 'my_orders_bloc.dart';

abstract class MyOrdersEvent extends Equatable {
  const MyOrdersEvent();

  @override
  List<Object> get props => [];
}

class MyOrdersdetailsFetchingEvent extends MyOrdersEvent {
  final String type;
  final String searchType;


  const MyOrdersdetailsFetchingEvent({
    required this.type,
    required this.searchType,

  });
  @override
  List<Object> get props => [type, searchType];
}

class MyCustomOrdersdetailsFetchingEvent extends MyOrdersEvent {
  final String type;
  final String searchType;

  final String fromDate;
  final String toDate;

  const MyCustomOrdersdetailsFetchingEvent({
    required this.type,
    required this.searchType,

    required this.fromDate,
    required this.toDate,
  });
  @override
  List<Object> get props => [type,searchType, fromDate, toDate];
}
