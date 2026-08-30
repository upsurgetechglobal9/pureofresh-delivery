part of 'dashboard_home_bloc.dart';

abstract class DashboardHomeState extends Equatable {
  const DashboardHomeState();

  @override
  List<Object> get props => [];
}

class DashboardHomeInitial extends DashboardHomeState {}
class DashboardLoadingState extends DashboardHomeState {}


class DashBoardDetailsLoadedState extends DashboardHomeState {
  final DashBoardDetailsModel dashBoardDetailsModeldata;

  const DashBoardDetailsLoadedState(this.dashBoardDetailsModeldata);

  @override
  List<Object> get props => [dashBoardDetailsModeldata];
}

class OnlineOfflineUpdateStatusState extends DashboardHomeState {
  final String response;
  const OnlineOfflineUpdateStatusState(this.response);

  @override
  List<Object> get props => [response];
}


