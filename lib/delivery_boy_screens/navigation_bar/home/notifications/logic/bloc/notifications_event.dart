part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationsFetchingEvent extends NotificationsEvent {
  final String start;
  final String seenstatus;
  final String from;
  final List<Result> existingNotificationsList;

  const NotificationsFetchingEvent({
    required this.start,
    required this.seenstatus,
    required this.from,
    required this.existingNotificationsList,
  });
  @override
  List<Object> get props =>
      [start, seenstatus, from, existingNotificationsList];
}

class NotificationSeenEvent extends NotificationsEvent {
  final String id;

  const NotificationSeenEvent({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}

class NotificationsMarkAllEvent extends NotificationsEvent {
  const NotificationsMarkAllEvent();

  @override
  List<Object> get props => [];
}
