part of 'raised_issues_bloc.dart';

abstract class RaisedIssuesEvent extends Equatable {
  const RaisedIssuesEvent();

  @override
  List<Object> get props => [];
}

class AllTypeIssuesEvent extends RaisedIssuesEvent {
  final String issueType;

  const AllTypeIssuesEvent({
    required this.issueType,
  });
  @override
  List<Object> get props => [issueType];
}
