part of 'referrals_data_bloc.dart';

abstract class ReferralsDataState extends Equatable {
  const ReferralsDataState();

  @override
  List<Object> get props => [];
}

class ReferralsDataInitial extends ReferralsDataState {}

class ReferralsLoadedState extends ReferralsDataState {
  final ReferralsDataModel referralsModel;

  const ReferralsLoadedState(this.referralsModel);

  @override
  List<Object> get props => [referralsModel];
}

// class ReferralsBaneereLoadedState extends ReferralsDataState {
//   final String bannerText;

//   const ReferralsBaneereLoadedState(this.bannerText);

//   @override
//   List<Object> get props => [bannerText];
// }

// class ReferAFriendLoadedState extends ReferralsDataState {
//   final ReferAFriendModel referAFriendModel;

//   const ReferAFriendLoadedState(this.referAFriendModel);

//   @override
//   List<Object> get props => [referAFriendModel];
// }
