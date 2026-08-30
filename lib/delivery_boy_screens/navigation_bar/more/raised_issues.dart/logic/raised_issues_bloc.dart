import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/raised_issues_model.dart';
import '../repository/raised_issues_repository.dart';

part 'raised_issues_event.dart';
part 'raised_issues_state.dart';

class RaisedIssuesBloc extends Bloc<RaisedIssuesEvent, RaisedIssuesState> {
  final RaisedIssuesRepository raisedIssuesRepository;

  RaisedIssuesBloc({required this.raisedIssuesRepository})
      : super(RaisedIssuesInitial()) {
    on<RaisedIssuesEvent>((event, emit) async {
      // TODO: implement event handler

      if (event is AllTypeIssuesEvent) {
        try {
          emit(LoadingState());
          RaisedIssuesModel raisedIssuesModel = await raisedIssuesRepository
              .raisedIssuesDetails(type: event.issueType);
          if (raisedIssuesModel.errCode == "valid") {
            emit(RaisedDetailsSuccessState(raisedIssuesModel));
          }
          if (raisedIssuesModel.errCode == "invalid") {
            emit(FailState());
          }
        } catch (e) {
          emit(ErrorState(error: e.toString()));
        }
      }
    });
  }
}
