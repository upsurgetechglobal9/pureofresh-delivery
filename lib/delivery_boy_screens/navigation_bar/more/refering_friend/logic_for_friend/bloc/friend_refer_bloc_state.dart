part of 'friend_refer_bloc_bloc.dart';

abstract class FriendReferBlocState extends Equatable {
  const FriendReferBlocState();

  @override
  List<Object> get props => [];
}

class FriendReferBlocInitial extends FriendReferBlocState {}

class ReferralsBaneereLoadedState extends FriendReferBlocState {
  final String bannerText;

  const ReferralsBaneereLoadedState(this.bannerText);

  @override
  List<Object> get props => [bannerText];
}

class ReferAFriendLoadedState extends FriendReferBlocState {
  final ReferAFriendModel referAFriendModel;

  const ReferAFriendLoadedState(this.referAFriendModel);

  @override
  List<Object> get props => [referAFriendModel];
}
