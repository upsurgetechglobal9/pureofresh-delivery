part of 'profile_details_bloc.dart';

abstract class ProfileDetailsState extends Equatable {
  const ProfileDetailsState();

  @override
  List<Object> get props => [];
}

class ProfileDetailsInitial extends ProfileDetailsState {}

class ProfileLoadingState extends ProfileDetailsState {}


class ProfileDetailsLoadedState extends ProfileDetailsState {
  final ProfileDetailsModel profileDetailsModeldata;

  const ProfileDetailsLoadedState(this.profileDetailsModeldata);

  @override
  List<Object> get props => [profileDetailsModeldata];
}
