part of 'vehicle_information_bloc.dart';

abstract class VehicleInformationState extends Equatable {
  const VehicleInformationState();

  @override
  List<Object> get props => [];
}

class VehicleInformationInitial extends VehicleInformationState {}

class VehicleDetailsLoadingState extends VehicleInformationState {}

class VehicleDetailsSuccessState extends VehicleInformationState {}

class VehicleDetailsFaildeState extends VehicleInformationState {}
