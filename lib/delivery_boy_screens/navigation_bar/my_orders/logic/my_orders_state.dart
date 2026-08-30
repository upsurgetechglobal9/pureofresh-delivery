part of 'my_orders_bloc.dart';

abstract class MyOrdersState extends Equatable {
  const MyOrdersState();

  @override
  List<Object> get props => [];
}

class MyOrdersInitial extends MyOrdersState {}

class LoadingState extends MyOrdersState {}

class MyOrdersDetailsLoadedState extends MyOrdersState {
  final MyOrdersDetailsModel myOrdersDetailsModeldata;

  const MyOrdersDetailsLoadedState(this.myOrdersDetailsModeldata);

  @override
  List<Object> get props => [myOrdersDetailsModeldata];
}



class MyOrdersCustomDetailsLoadedState extends MyOrdersState {
  final MyOrdersDetailsModel myOrdersCustomDetailsModeldata;

  const MyOrdersCustomDetailsLoadedState(this.myOrdersCustomDetailsModeldata);

  @override
  List<Object> get props => [myOrdersCustomDetailsModeldata];
}

class FailedState extends MyOrdersState {
  final String errorData;

  const FailedState(this.errorData);

  @override
  List<Object> get props => [errorData];
}

class FailedCustomState extends MyOrdersState {
  final String errorData;

  const FailedCustomState(this.errorData);

  @override
  List<Object> get props => [errorData];
}
