import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/incentive_business_model.dart';
import '../repository/incentives_repository.dart';

part 'incentives_business_event.dart';
part 'incentives_business_state.dart';

class IncentivesBusinessBloc
    extends Bloc<IncentivesBusinessEvent, IncentivesBusinessState> {
  final IncentivesReposotory incentivesReposotory;
  IncentivesBusinessBloc({required this.incentivesReposotory})
      : super(IncentivesBusinessState(
            incentivesDataList: IncentivesDataModel(
                errCode: '', title: '', message: '', data: []))) {
    on<IncentivesBusinessEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is IncentivesFetchingEvent) {
        try {
          emit(state.copyWith(incentivesLoading: true));
          final incentivesModel = await incentivesReposotory.incentivesApiCall(
            type: event.timeType,
          );
          emit(state.copyWith(incentivesDataList: incentivesModel));
        } catch (e) {
          emit(state.copyWith(incentivesError: true));

          print(e.toString());
        }
      }
    });
  }
}
