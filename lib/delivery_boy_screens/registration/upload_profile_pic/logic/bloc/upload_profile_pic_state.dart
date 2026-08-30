part of 'upload_profile_pic_bloc.dart';

abstract class UploadProfilePicState extends Equatable {
  const UploadProfilePicState();

  @override
  List<Object> get props => [];
}

class UploadProfilePicInitial extends UploadProfilePicState {}

class LoadingState extends UploadProfilePicState {}


class UploadProfilePicSuccessState extends UploadProfilePicState {}
