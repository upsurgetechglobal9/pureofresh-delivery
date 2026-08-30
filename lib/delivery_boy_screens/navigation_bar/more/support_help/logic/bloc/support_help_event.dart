part of 'support_help_bloc.dart';

abstract class SupportHelpEvent extends Equatable {
  const SupportHelpEvent();

  @override
  List<Object> get props => [];
}

class ProfileDetailsFetchingEvent extends SupportHelpEvent {
  @override
  List<Object> get props => [];
}

class ProfileAddDetailsEvent extends SupportHelpEvent {
  final String image;
  final String name;
  final String languages;

  const ProfileAddDetailsEvent({
    required this.image,
    required this.name,
    required this.languages,
  });
  @override
  List<Object> get props => [image, name, languages];
}

class OrderEarningIssueEvent extends SupportHelpEvent {
  final String description;
  final String orderId;
  final String image;

  const OrderEarningIssueEvent({
    required this.description,
    required this.orderId,
    required this.image,
  });
  @override
  List<Object> get props => [description, orderId, image];
}

class IncentivesnPayoutIssueEvent extends SupportHelpEvent {
  final String description;
  final String transId;
  final String image;

  const IncentivesnPayoutIssueEvent({
    required this.description,
    required this.transId,
    required this.image,
  });
  @override
  List<Object> get props => [description, transId, image];
}

class CodCashIssueEvent extends SupportHelpEvent {
  final String description;
  final String transId;
  final String image;

  const CodCashIssueEvent({
    required this.description,
    required this.transId,
    required this.image,
  });
  @override
  List<Object> get props => [description, transId, image];
}

class AnyOtherIssueEvent extends SupportHelpEvent {
  final String description;
  final String image;

  const AnyOtherIssueEvent({
    required this.description,
    required this.image,
  });
  @override
  List<Object> get props => [description, image];
}
