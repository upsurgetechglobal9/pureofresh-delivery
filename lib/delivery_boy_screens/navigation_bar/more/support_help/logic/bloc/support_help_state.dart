part of 'support_help_bloc.dart';

abstract class SupportHelpState extends Equatable {
  const SupportHelpState();

  @override
  List<Object> get props => [];
}

class SupportHelpInitial extends SupportHelpState {}

class ProfileDetailsLoadingState extends SupportHelpState {}

class ProfileAddedSuccessState extends SupportHelpState {}

class ProfileDetailsSuccessState extends SupportHelpState {
  final MyProfileDetailsModel myProfileDetailsModel;

  const ProfileDetailsSuccessState(this.myProfileDetailsModel);

  @override
  List<Object> get props => [myProfileDetailsModel];
}

class OrderIssueSuccessState extends SupportHelpState {}

class IncentivesIssueSuccessState extends SupportHelpState {}

class CodCashIssueSuccessState extends SupportHelpState {}
