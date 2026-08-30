part of 'referrals_data_bloc.dart';

abstract class ReferralsDataEvent extends Equatable {
  const ReferralsDataEvent();

  @override
  List<Object> get props => [];
}

class ReferralsFetching extends ReferralsDataEvent {
  final String accessToken;

  const ReferralsFetching({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}

// class ReferralBannerTextFetching extends ReferralsDataEvent {
//   @override
//   List<Object> get props => [];
// }

// class AddReferAFriendEvent extends ReferralsDataEvent {
//   final String accessToken;
//   final String mobileNumber;
//   final String name;
//   final String age;
//   final String vehicleType;
//   final String city;
//   final String workTime;

//   const AddReferAFriendEvent({
//     required this.accessToken,
//     required this.mobileNumber,
//     required this.name,
//     required this.age,
//     required this.vehicleType,
//     required this.city,
//     required this.workTime,
//   });
//   @override
//   List<Object> get props =>
//       [accessToken, mobileNumber, name, age, vehicleType, city, workTime];
// }
