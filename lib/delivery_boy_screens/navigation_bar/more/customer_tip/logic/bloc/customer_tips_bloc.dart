import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/customer_tips_model.dart';
import '../../repository/customer_tips_repository.dart';

part 'customer_tips_event.dart';
part 'customer_tips_state.dart';

class CustomerTipsBloc extends Bloc<CustomerTipsEvent, CustomerTipsState> {
  final CustomerTipsRepository customerTipsRepository;

  CustomerTipsBloc({required this.customerTipsRepository})
      : super(CustomerTipsInitial()) {
    on<CustomerTipsEvent>((event, emit) async {
      if (event is CustomerTipsFetching) {
        try {
          CustomerTipsModel costomerTipsModel =
              await customerTipsRepository.customerTips(
            accessToken: event.accessToken,
          );
          if (costomerTipsModel.data.totalAmount != null) {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(TipsLoadedState(costomerTipsModel));
          }
        } catch (e) {
          emit(TipsErrorState(e.toString()));
        }
      }
    });
  }
}
