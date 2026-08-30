import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../logic/bloc/referrals_data_bloc.dart';
import '../../models/refer_a_friend_model.dart';
import '../../repository/referrals_repository.dart';

part 'friend_refer_bloc_event.dart';
part 'friend_refer_bloc_state.dart';

class FriendReferBlocBloc
    extends Bloc<FriendReferBlocEvent, FriendReferBlocState> {
  final RefferalRepository refferalRepository;
  FriendReferBlocBloc({required this.refferalRepository})
      : super(FriendReferBlocInitial()) {
    on<FriendReferBlocEvent>((event, emit) async {

      if (event is ReferralBannerTextFetching) {
        print("ReferralBannerTextFetchin");
        try {
          String bannerData = await refferalRepository.getBannerData();
          emit(ReferralsBaneereLoadedState(bannerData));
        } catch (e) {
          print(e.toString());
        }
      }
      
      if (event is AddReferAFriendEvent) {
        try {
          ReferAFriendModel referAFriendModel =
              await refferalRepository.referAFriend(
            accessToken: event.accessToken,
            mobileNumber: event.mobileNumber,
            name: event.name,
            age: event.age,
            vehicleType: event.vehicleType,
            city: event.city,
            workTime: event.workTime,
          );
          print("emit${referAFriendModel.message}");
          if (referAFriendModel.message != null) {
            print("emit${referAFriendModel.message}");
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ReferAFriendLoadedState(referAFriendModel));
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
