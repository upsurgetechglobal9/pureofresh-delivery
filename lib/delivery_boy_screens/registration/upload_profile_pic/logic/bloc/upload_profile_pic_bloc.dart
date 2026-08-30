import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/profile_pic_repository.dart';

part 'upload_profile_pic_event.dart';
part 'upload_profile_pic_state.dart';

// class UploadProfilePicBloc extends Bloc<UploadProfilePicEvent, UploadProfilePicState> {
//   UploadProfilePicBloc() : super(UploadProfilePicInitial());

//   @override
//   Stream<UploadProfilePicState> mapEventToState(
//     UploadProfilePicEvent event,
//   ) async* {
//     // TODO: implement mapEventToState
//   }
// }

class UploadProfilePicBloc
    extends Bloc<UploadProfilePicEvent, UploadProfilePicState> {
  final UploadImageRepository uploadImageRepository;

  UploadProfilePicBloc({required this.uploadImageRepository})
      : super(UploadProfilePicInitial()) {
    on<UploadProfilePicEvent>((event, emit) async {
      if (event is UploadImageSendingEvent) {
        try {
          emit(LoadingState());
          await uploadImageRepository.uploadImageApi(image: event.image);
          emit(UploadProfilePicSuccessState());
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
