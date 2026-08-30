part of 'friend_refer_bloc_bloc.dart';

abstract class FriendReferBlocEvent extends Equatable {
  const FriendReferBlocEvent();

  @override
  List<Object> get props => [];
}

class ReferralBannerTextFetching extends FriendReferBlocEvent {
  @override
  List<Object> get props => [];
}
class AddReferAFriendEvent extends FriendReferBlocEvent {
  final String accessToken;
  final String mobileNumber;
  final String name;
  final String age;
  final String vehicleType;
  final String city;
  final String workTime;

  const AddReferAFriendEvent({
    required this.accessToken,
    required this.mobileNumber,
    required this.name,
    required this.age,
    required this.vehicleType,
    required this.city,
    required this.workTime,
  });
  @override
  List<Object> get props =>
      [accessToken, mobileNumber, name, age, vehicleType, city, workTime];
}