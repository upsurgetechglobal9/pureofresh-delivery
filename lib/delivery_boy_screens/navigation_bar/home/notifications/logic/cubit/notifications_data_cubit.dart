import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/models/notifications_data_model.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/repository/notifications_repository.dart';

part 'notifications_data_state.dart';

class NotificationsDataCubit extends Cubit<NotificationsDataState> {
  final NotificationsRepository notificationsRepository;
  NotificationsDataCubit(this.notificationsRepository)
      : super(const NotificationsDataState());

  Future<void> featchNotifications({
    bool loadMoreData = false,
    required String seenStatus,
  }) async {
    try {
      // Loading indicator when data is being fetched
      emit(state.copyWith(dataLoading: !loadMoreData));
      if (loadMoreData && state.notificationsDataNewResponseModel != null) {
        // Run the fetch connection API if it's not the last page.
        if (!state.notificationsDataNewResponseModel!.paginationTestModel
            .isLastPage) {
          // Increase the current page counter
          state.notificationsDataNewResponseModel!.paginationTestModel
              .currentPage += 1;
          final moreData =
              await notificationsRepository.notificationsDetailsNew(
                  page: state.notificationsDataNewResponseModel!
                      .paginationTestModel.currentPage,
                  seenStatus: seenStatus);
          // Update the state with the new data.
          emit(
            state.copyWith(
              // Check if the items are already in the list to avoid duplicates.
              notificationsDataNewResponseModel: state
                  .notificationsDataNewResponseModel!
                  .paginationCopyWith(newData: moreData),
            ),
          );
          return;
        }
      } else {
        // Refreshing or loading initial data
        final restoList = await notificationsRepository.notificationsDetailsNew(
          seenStatus: seenStatus,
        );
        // Update the state with the new data.
        emit(state.copyWith(notificationsDataNewResponseModel: restoList));
      }

      return;
    } catch (e) {
      // Error handling
      if (isClosed) {
        return;
      }
      if (state.moreNotificationsListNotAvailable) {
        emit(state.copyWith(error: e.toString(), dataLoading: false));
        return;
      } else {
        emit(state.copyWith(dataLoading: false));
        return;
      }
    }
  }

  Future<void> singleNotificationRead(String id, String status) async {
    try {
      emit(state.copyWith(singleTickLoad: true));
      final isRead =
          await notificationsRepository.singleViewNotifications(id: id);
      featchNotifications(seenStatus: status);
      emit(state.copyWith(isRead: isRead));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> markAsReadNotificationRead() async {
    try {
      emit(state.copyWith(mardAsReadLoad: true));
      final isMarkAsRead =
          await notificationsRepository.markAsReasAllNotifications();
      featchNotifications(seenStatus: '');
      emit(state.copyWith(isMarkAsRead: isMarkAsRead));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
