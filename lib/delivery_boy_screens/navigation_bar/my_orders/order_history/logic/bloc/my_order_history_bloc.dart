import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/my_order_history_model.dart';
import '../../repository/my_orders_history_repository.dart';

part 'my_order_history_event.dart';
part 'my_order_history_state.dart';

// class MyOrderHistoryBloc extends Bloc<MyOrderHistoryEvent, MyOrderHistoryState> {
//   MyOrderHistoryBloc() : super(MyOrderHistoryInitial());

//   Stream<MyOrderHistoryState> mapEventToState(
//     MyOrderHistoryEvent event,
//   ) async* {
//     // TODO: implement mapEventToState
//   }
// }

class MyOrderHistoryBloc
    extends Bloc<MyOrderHistoryEvent, MyOrderHistoryState> {
  final MyOrderHistorRepository myOrderHistorRepository;

  MyOrderHistoryBloc({required this.myOrderHistorRepository})
      : super(MyOrderHistoryInitial()) {
    on<MyOrderHistoryEvent>((event, emit) async {
      if (event is MyHistoryFetchingEvent) {
         emit(LoadingStateHistory());
        try {
          MyOrdersHistoryModel myOrdersHistoryModel =
              await myOrderHistorRepository.myOrderHistoryApiCall(
                  date: event.date,searchType: event.searchType);
          print("emit${myOrdersHistoryModel.errCode}");
          if (myOrdersHistoryModel.errCode == 'valid') {
            print("emit asd ${myOrdersHistoryModel.title}");
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(MyOrdersHistoryLoadedState(myOrdersHistoryModel));
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
