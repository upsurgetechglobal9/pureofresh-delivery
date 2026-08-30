part of 'vehicle_information_bloc.dart';

abstract class VehicleInformationEvent extends Equatable {
  const VehicleInformationEvent();

  @override
  List<Object> get props => [];
}

class AddVehicleDetailsEvent extends VehicleInformationEvent {
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleValidity;
  final String drivingLicenseNumber;
  final String drivingLicensePhoto;
  final String vehiclePhoto;
  final String vehiclePhoto2;
  final String rc1;
  final String rc2;

  final String vehicleName;
  final String drivingLicensePhotoTwo;

  const AddVehicleDetailsEvent({
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleValidity,
    required this.drivingLicenseNumber,
    required this.drivingLicensePhoto,
    required this.vehiclePhoto,
    required this.vehiclePhoto2,
    required this.rc1,
    required this.rc2,

    required this.vehicleName,
    required this.drivingLicensePhotoTwo,
  });
  @override
  List<Object> get props => [
        vehicleType,
        vehicleNumber,
        vehicleValidity,
        drivingLicenseNumber,
        drivingLicensePhoto,
        vehiclePhoto,
        vehiclePhoto2,
        rc1,
        rc2,

        vehicleName,
        drivingLicensePhotoTwo
      ];
}
