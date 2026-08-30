part of 'incentives_business_bloc.dart';

abstract class IncentivesBusinessEvent extends Equatable {
  const IncentivesBusinessEvent();

  @override
  List<Object> get props => [];
}

class IncentivesFetchingEvent extends IncentivesBusinessEvent {
  final String timeType;

  const IncentivesFetchingEvent({
    required this.timeType,
  });
  @override
  List<Object> get props => [timeType];
}
