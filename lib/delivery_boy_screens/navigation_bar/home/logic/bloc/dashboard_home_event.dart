part of 'dashboard_home_bloc.dart';

abstract class DashboardHomeEvent extends Equatable {
  const DashboardHomeEvent();

  @override
  List<Object> get props => [];
}

class DashBoardDetailsFetchingEvent extends DashboardHomeEvent {
  final String accessToken;

  const DashBoardDetailsFetchingEvent({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}



class UpdatingFirebaseKeyEvent extends DashboardHomeEvent {
  final String accessToken;
  final String pushNotificationFireKey;
  final String deviceId;

  const UpdatingFirebaseKeyEvent({
    required this.accessToken,
    required this.pushNotificationFireKey,
    required this.deviceId,
  });
  @override
  List<Object> get props => [accessToken];
}

class BackgroundLoactionEvent extends DashboardHomeEvent {
  final String accessToken;
  final String latitude;
  final String longitude;

  const BackgroundLoactionEvent({
    required this.accessToken,
    required this.latitude,
    required this.longitude,
  });
  @override
  List<Object> get props => [accessToken, latitude, longitude];
}
