import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/notifications_model.dart';
import '../../repository/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository notificationsRepository;

  NotificationsBloc({required this.notificationsRepository})
      : super(NotificationsLoadingState()) {
    on<NotificationsEvent>((event, emit) async {
      if (event is NotificationsFetchingEvent) {
        try {
          if (event.from == 'init') {
            emit(NotificationsLoadingState());
            event.existingNotificationsList.clear();
          }
          
          NotificationsModel notificationsModel =
              await notificationsRepository.notificationsDetails(
            start: event.start,
            seenStatus: event.seenstatus,
          );

          if (notificationsModel.errCode == 'valid') {
            for (var element in notificationsModel.data.results) {
              event.existingNotificationsList.add(element);
            }
            emit(NotificationsSuccessState(
                notificationsList: event.existingNotificationsList,
                startPage: event.start,
                totalCount: notificationsModel.data.totalPages.toString()));
          }
        } catch (e) {
          print(e.toString());
        }
      }

      if (event is NotificationSeenEvent) {
        try {
          var respons = await notificationsRepository.notificationSeen(
            id: event.id,
          );

          if (respons == 'valid') {
            emit(NotificationsSeenSuccesState());
          }
        } catch (e) {
          print(e.toString());
        }
      }

      if (event is NotificationsMarkAllEvent) {
        try {
          var respons = await notificationsRepository.notificationMarkAllSeen();

          if (respons == 'valid') {
            emit(NotificationsSeenSuccesState());
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
