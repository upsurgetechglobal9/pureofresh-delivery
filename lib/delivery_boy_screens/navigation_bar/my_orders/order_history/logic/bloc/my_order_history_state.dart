part of 'my_order_history_bloc.dart';

abstract class MyOrderHistoryState extends Equatable {
  const MyOrderHistoryState();

  @override
  List<Object> get props => [];
}

class LoadingStateHistory extends MyOrderHistoryState {}
class MyOrderHistoryInitial extends MyOrderHistoryState {}


class MyOrdersHistoryLoadedState extends MyOrderHistoryState {
  final MyOrdersHistoryModel MyOrdersHistoryModeldata;

  const MyOrdersHistoryLoadedState(this.MyOrdersHistoryModeldata);

  @override
  List<Object> get props => [MyOrdersHistoryModeldata];
}
