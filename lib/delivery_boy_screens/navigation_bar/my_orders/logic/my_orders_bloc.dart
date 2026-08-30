import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/my_orders_model.dart';
import '../repository/my_orders_repository.dart';

part 'my_orders_event.dart';
part 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  final MyOrdersRepository myOrdersRepository;

  MyOrdersBloc({required this.myOrdersRepository}) : super(MyOrdersInitial()) {
    on<MyOrdersEvent>((event, emit) async {
      if (event is MyOrdersdetailsFetchingEvent) {
         try {
          emit(MyOrdersInitial());
          MyOrdersDetailsModel myOrdersDetailsModel =
              await myOrdersRepository.myOrderDetailsApiCall(
            type: event.type,
            searchType: event.searchType,
          );
          print("emit${myOrdersDetailsModel.data}");
          if (myOrdersDetailsModel.errCode == 'valid') {
            print("emit asggd ${myOrdersDetailsModel.message}");
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(MyOrdersDetailsLoadedState(myOrdersDetailsModel));
          }
          if (myOrdersDetailsModel.errCode == 'invalid') {
            print("22222222");
            // Fluttertoast.showToast(msg: myOrdersDetailsModel.message);
            emit(FailedState(myOrdersDetailsModel.message));
          }
        } catch (e) {
          emit(FailedState(e.toString()));
          print(e.toString());
        }
      }

      if (event is MyCustomOrdersdetailsFetchingEvent) {
        print("object");
        try {
          emit(LoadingState());
          MyOrdersDetailsModel myOrdersDetailsModel =
              await myOrdersRepository.myCustomOrderDetailsApiCall(
            type: event.type,
            fromdate: event.fromDate,
            todate: event.toDate,
            searchType: event.searchType,
          );
          print("emit${myOrdersDetailsModel.message}");
          if (myOrdersDetailsModel.errCode == 'valid') {
            print("emit asd ${myOrdersDetailsModel.message}");
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(MyOrdersCustomDetailsLoadedState(myOrdersDetailsModel));
          }
        } catch (e) {
          emit(FailedCustomState(e.toString()));
          print(e.toString());
        }
      }
    });
  }
}
