part of 'profile_details_bloc.dart';

abstract class ProfileDetailsEvent extends Equatable {
  const ProfileDetailsEvent();

  @override
  List<Object> get props => [];
}

class ProfileDetailsFetchingEvent extends ProfileDetailsEvent {
  final String accessToken;

  const ProfileDetailsFetchingEvent({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}
