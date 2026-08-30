part of 'verification_documents_bloc.dart';

abstract class VerificationDocumentsEvent extends Equatable {
  const VerificationDocumentsEvent();

  @override
  List<Object> get props => [];
}

class AddDocmentsDetailsEvent extends VerificationDocumentsEvent {
  final String panName;
  final String panNumber;
  final String panFather;
  final String panGender;
  final String adharName;
  final String adharNumber;
  final String adharPic;
  final String panPic;
  final String aadharBack;


  const AddDocmentsDetailsEvent({
    required this.panName,
    required this.panNumber,
    required this.panFather,
    required this.panGender,
    required this.adharName,
    required this.adharNumber,
    required this.adharPic,
    required this.panPic,
    required this.aadharBack,

  });
  @override
  List<Object> get props => [
        panName,
        panNumber,
        panFather,
        panGender,
        adharName,
        adharNumber,
        adharPic,
        panPic,
        aadharBack,
      ];
}
