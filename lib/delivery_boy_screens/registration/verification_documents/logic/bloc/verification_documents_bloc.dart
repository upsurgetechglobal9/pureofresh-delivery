import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/verification_documents_repository.dart';

part 'verification_documents_event.dart';
part 'verification_documents_state.dart';


class VerificationDocumentsBloc
    extends Bloc<VerificationDocumentsEvent, VerificationDocumentsState> {
  final VerificationDocumentsRepository verificationDocumentsRepository;

  VerificationDocumentsBloc({required this.verificationDocumentsRepository})
      : super(VerificationDocumentsInitial()) {
    on<VerificationDocumentsEvent>((event, emit) async {
      if (event is AddDocmentsDetailsEvent) {
        try {
          emit(DocumentsDetailsLoadingState());
          final registerResponce =
              await verificationDocumentsRepository.documentDetailsUploading(
                  panNumber: event.panNumber,
                  panName: event.panName,
                  panGender: event.panGender,
                  panFather: event.panFather,
                  adharPic: event.adharPic,
                  panPic: event.panPic,
                  adharName: event.adharName,
                  adharNumber: event.adharNumber,adharBack: event.aadharBack);
                  if(registerResponce == 'valid'){
                  emit(DocumentsDetailsSuccessState());

                  }else{
                    emit(DocumentsDetailsFailedState());
                  }
          // if (referAFriendModel.message != null) {
          //   print("emit${referAFriendModel.message}");
          //   // emit(state.copyWith(codFetchingCompleted: true));
          // emit(VerifyOtp(res));
          // }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
