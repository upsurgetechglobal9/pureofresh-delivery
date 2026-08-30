part of 'orders_list_bloc.dart';

abstract class OrdersListState extends Equatable {
  const OrdersListState();
  
  @override
  List<Object> get props => [];
}

class OrdersListInitial extends OrdersListState {}

class MyOrdersListListLoadedState extends OrdersListState {
  final MyOrdersListDashBoardModel myOrdersListDashBoardModeldata;

  const MyOrdersListListLoadedState(this.myOrdersListDashBoardModeldata);

  @override
  List<Object> get props => [myOrdersListDashBoardModeldata];
}