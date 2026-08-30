import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/refer_a_friend_model.dart';
import '../../models/referral_data_model.dart';
import '../../repository/referrals_repository.dart';

part 'referrals_data_event.dart';
part 'referrals_data_state.dart';

class ReferralsDataBloc extends Bloc<ReferralsDataEvent, ReferralsDataState> {
  final RefferalRepository refferalRepository;

  ReferralsDataBloc({required this.refferalRepository})
      : super(ReferralsDataInitial()) 
      {
    on<ReferralsDataEvent>((event, emit) async {
      if (event is ReferralsFetching) {
        try {
          print("event.accessToken${event.accessToken}");
          ReferralsDataModel referralsDataModel =
              await refferalRepository.referralData(
            accessToken: event.accessToken,
          );
          print("emit${referralsDataModel.message}");
          if (referralsDataModel.message != null) {
            print("emit${referralsDataModel.message}");
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ReferralsLoadedState(referralsDataModel));
          }
        } catch (e) {
          print(e.toString());
        }
      }

      // if (event is AddReferAFriendEvent) {
      //   try {
      //     ReferAFriendModel referAFriendModel =
      //         await refferalRepository.referAFriend(
      //       accessToken: event.accessToken,
      //       mobileNumber: event.mobileNumber,
      //       name: event.name,
      //       age: event.age,
      //       vehicleType: event.vehicleType,
      //       city: event.city,
      //       workTime: event.workTime,
      //     );
      //     print("emit${referAFriendModel.message}");
      //     if (referAFriendModel.message != null) {
      //       print("emit${referAFriendModel.message}");
      //       // emit(state.copyWith(codFetchingCompleted: true));
      //       emit(ReferAFriendLoadedState(referAFriendModel));
      //     }
      //   } catch (e) {
      //     print(e.toString());
      //   }
      // }
      // if (event is ReferralBannerTextFetching) {
      //   print("ReferralBannerTextFetchin");
      //   try {
      //     String bannerData = await refferalRepository.getBannerData();
      //     emit(ReferralsBaneereLoadedState(bannerData));
      //   } catch (e) {
      //     print(e.toString());
      //   }
      // }
    });
  }
}
