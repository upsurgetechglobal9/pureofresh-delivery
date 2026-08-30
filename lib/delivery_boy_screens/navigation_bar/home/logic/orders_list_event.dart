part of 'orders_list_bloc.dart';

abstract class OrdersListEvent extends Equatable {
  const OrdersListEvent();

  @override
  List<Object> get props => [];
}

class OrdersListFetchingEvent extends OrdersListEvent {
  final String latitude;
  final String longitude;

  const OrdersListFetchingEvent({
    required this.latitude,
    required this.longitude,
  });
  @override
  List<Object> get props => [latitude, longitude];
}