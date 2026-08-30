part of 'verification_documents_bloc.dart';

abstract class VerificationDocumentsState extends Equatable {
  const VerificationDocumentsState();

  @override
  List<Object> get props => [];
}

class VerificationDocumentsInitial extends VerificationDocumentsState {}

class DocumentsDetailsLoadingState extends VerificationDocumentsState {}

class DocumentsDetailsSuccessState extends VerificationDocumentsState {}
class DocumentsDetailsFailedState extends VerificationDocumentsState {}

