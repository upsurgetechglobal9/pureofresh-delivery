part of 'vesion_control_cubit.dart';

abstract class VesionControlState extends Equatable {
  const VesionControlState();

  @override
  List<Object> get props => [];
}

class VesionControlInitial extends VesionControlState {}

class UpdateNeededState extends VesionControlState {
  final VersionCheckModel versionCheckModel;
  const UpdateNeededState({required this.versionCheckModel});
  @override
  List<Object> get props => [versionCheckModel];
}

class VersionUpdateNotNeedSate extends VesionControlState {
  final VersionCheckModel versionCheckModel;
  const VersionUpdateNotNeedSate({required this.versionCheckModel});
  @override
  List<Object> get props => [versionCheckModel];
}

class VersionCheckError extends VesionControlState {
  final String error;

  const VersionCheckError({required this.error});

  @override
  List<Object> get props => [error];
}

class UnderMaintenanceSate extends VesionControlState {
  final UnderMaintenanceModel underMaintenanceModel;
  const UnderMaintenanceSate({required this.underMaintenanceModel});
  @override
  List<Object> get props => [underMaintenanceModel];
}

class PrimaryCheckInSate extends VesionControlState {
  final PrimaryCheckInModel primaryCheckInModel;
  const PrimaryCheckInSate({required this.primaryCheckInModel});
  @override
  List<Object> get props => [primaryCheckInModel];
}

class WorkingFineSate extends VesionControlState {}
