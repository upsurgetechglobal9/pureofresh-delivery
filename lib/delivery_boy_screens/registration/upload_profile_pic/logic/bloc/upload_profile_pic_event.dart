part of 'upload_profile_pic_bloc.dart';

abstract class UploadProfilePicEvent extends Equatable {
  const UploadProfilePicEvent();

  @override
  List<Object> get props => [];
}

class UploadImageSendingEvent extends UploadProfilePicEvent {
  final String image;

  const UploadImageSendingEvent({
    required this.image,
  });

  @override
  List<Object> get props => [image];
}
