import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/profile_details_model.dart';
import '../../repository/profile_details_repository.dart';

part 'profile_details_event.dart';
part 'profile_details_state.dart';

class ProfileDetailsBloc
    extends Bloc<ProfileDetailsEvent, ProfileDetailsState> {
  final ProfileDetailsReposotory profileDetailsReposotory;

  ProfileDetailsBloc({required this.profileDetailsReposotory})
      : super(ProfileDetailsInitial()) {
    on<ProfileDetailsEvent>((event, emit) async {
      if (event is ProfileDetailsFetchingEvent) {
        try {
          emit(ProfileLoadingState());
          ProfileDetailsModel profileDetailsModel =
              await profileDetailsReposotory.profileDetails(
            accessToken: event.accessToken,
          );
          if (profileDetailsModel.errCode == 'valid') {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(ProfileDetailsLoadedState(profileDetailsModel));
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
