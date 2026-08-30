import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../models/orders_list_in_dashboard_model.dart';
import '../repository/dashboard_details_repository.dart';

part 'orders_list_event.dart';
part 'orders_list_state.dart';

class OrdersListBloc extends Bloc<OrdersListEvent, OrdersListState> {
  final DashBoardDetailsReposotory dashBoardDetailsReposotory;

  OrdersListBloc({required this.dashBoardDetailsReposotory})
      : super(OrdersListInitial()) {
    on<OrdersListEvent>((event, emit) async {
      if (event is OrdersListFetchingEvent) {
        try {
          MyOrdersListDashBoardModel myOrdersListDashBoardModel =
              await dashBoardDetailsReposotory.ordersListApiCall(
            latitude: event.latitude,
            longitude: event.longitude,
          );

          if (myOrdersListDashBoardModel.errCode == 'valid') {
            emit(MyOrdersListListLoadedState(myOrdersListDashBoardModel));
          }
          if (myOrdersListDashBoardModel.errCode == 'invalid') {
            emit(MyOrdersListListLoadedState(myOrdersListDashBoardModel));
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
