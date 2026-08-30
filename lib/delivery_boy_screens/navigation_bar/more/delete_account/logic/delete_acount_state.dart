part of 'delete_acount_cubit.dart';

abstract class DeleteAcountState extends Equatable {
  const DeleteAcountState();

  @override
  List<Object> get props => [];
}

class DeleteAcountInitial extends DeleteAcountState {}

class DeleteAcountSuccessState extends DeleteAcountState {}

class DeleteAcountFailedState extends DeleteAcountState {}
