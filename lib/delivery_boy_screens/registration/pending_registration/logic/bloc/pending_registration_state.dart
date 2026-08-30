part of 'pending_registration_bloc.dart';

abstract class PendingRegistrationState extends Equatable {
  const PendingRegistrationState();

  @override
  List<Object> get props => [];
}

class PendingRegistrationInitial extends PendingRegistrationState {}

class PendingRegisterSuccssState extends PendingRegistrationState {
  final RegistrationPendingModel registrationPendingModel;

  const PendingRegisterSuccssState(this.registrationPendingModel);

  @override
  List<Object> get props => [registrationPendingModel];
}
