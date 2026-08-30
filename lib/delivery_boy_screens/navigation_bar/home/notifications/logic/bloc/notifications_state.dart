part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

// class NotificationsInitial extends NotificationsState {}

class NotificationsSuccessState extends NotificationsState {
  final List<Result> notificationsList;
  final String totalCount;
  final String startPage;

  const NotificationsSuccessState(
      {required this.notificationsList,
      required this.totalCount,
      required this.startPage});

  @override
  List<Object> get props => [notificationsList, totalCount, startPage];
}

class NotificationsLoadingState extends NotificationsState {}

class NotificationsSeenSuccesState extends NotificationsState {}
