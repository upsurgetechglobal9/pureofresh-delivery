part of 'notifications_data_cubit.dart';

 class NotificationsDataState extends Equatable {
     final bool dataLoading;
  final bool singleTickLoad;
  final bool mardAsReadLoad;
  final bool isRead;
  final bool isMarkAsRead;
  final String? error;
  final NotificationsDataNewResponseModel? notificationsDataNewResponseModel;
  const NotificationsDataState({
    this.dataLoading = false,
    this.singleTickLoad = false,
    this.mardAsReadLoad = false,
    this.isMarkAsRead = false,
    this.isRead = false,
    this.error,
    this.notificationsDataNewResponseModel,
  });

    bool get moreNotificationsListNotAvailable =>
      notificationsDataNewResponseModel == null ||
      notificationsDataNewResponseModel!.results.isEmpty;

@override
  List<Object?> get props => [
        dataLoading,
        singleTickLoad,
        isRead,
        isMarkAsRead,
        mardAsReadLoad,
        error,
        notificationsDataNewResponseModel
      ];

         NotificationsDataState copyWith({
    bool? dataLoading,
    bool? singleTickLoad,
    bool? mardAsReadLoad,
    bool? isRead,
    bool? isMarkAsRead,
    String? error,
    NotificationsDataNewResponseModel? notificationsDataNewResponseModel,
  }) {
    return NotificationsDataState(
      dataLoading: dataLoading ?? false,
      singleTickLoad: singleTickLoad ?? false,
      mardAsReadLoad: mardAsReadLoad ?? false,
      isRead: isRead ?? false,
      isMarkAsRead: isMarkAsRead ?? false,
      error: error,
      notificationsDataNewResponseModel: notificationsDataNewResponseModel ??
          this.notificationsDataNewResponseModel,
    );
  }
}

