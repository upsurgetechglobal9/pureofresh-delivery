part of 'raised_issues_bloc.dart';

abstract class RaisedIssuesState extends Equatable {
  const RaisedIssuesState();

  @override
  List<Object> get props => [];
}
class FailState extends RaisedIssuesState {}

class RaisedIssuesInitial extends RaisedIssuesState {}

class LoadingState extends RaisedIssuesState {}

class ErrorState extends RaisedIssuesState {
  final String? error;
    const ErrorState({this.error});

  @override
  List<Object> get props => [error!];
}

class RaisedDetailsSuccessState extends RaisedIssuesState {
  final RaisedIssuesModel raisedIssuesModel;

  const RaisedDetailsSuccessState(this.raisedIssuesModel);

  @override
  List<Object> get props => [raisedIssuesModel];
}
