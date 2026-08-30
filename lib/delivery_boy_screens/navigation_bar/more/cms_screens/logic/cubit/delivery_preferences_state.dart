part of 'delivery_preferences_cubit.dart';

class DeliveryPreferencesState extends Equatable {
  final bool dataLoading;
  final bool prefdataLoading;

  final bool typeLoad;

  final bool statusUpdateLoading;
  final bool isVehicleDropdownLoading;

  final bool statusUpdated;
  final String? error;
  final String? typeId;
  final String? selectedVehicleData;

  final String? statusUpdateerror;
  final List<PreferVehicleData> preferVehicleData;

  final DeliveryPreferencesResponseModel? deliveryPreferencesResponseModel;
  const DeliveryPreferencesState(
      {this.dataLoading = false,
      this.prefdataLoading = false,
      this.typeLoad = false,
      this.statusUpdateLoading = false,
      this.isVehicleDropdownLoading = false,
      this.statusUpdated = false,
      this.error,
      this.typeId,
      this.statusUpdateerror,
      this.deliveryPreferencesResponseModel,
      required this.preferVehicleData,
      this.selectedVehicleData});

  @override
  List<Object?> get props => [
        dataLoading,
        prefdataLoading,
        typeLoad,
        error,
        typeId,
        statusUpdateerror,
        statusUpdateLoading,
        isVehicleDropdownLoading,
        statusUpdated,
        deliveryPreferencesResponseModel,
        preferVehicleData,
        selectedVehicleData
      ];

  DeliveryPreferencesState copyWith(
      {bool? dataLoading,
      bool? prefdataLoading,
      bool? typeLoad,
      bool? statusUpdateLoading,
      bool? statusUpdated,
      bool? isVehicleDropdownLoading,
      String? error,
      String? typeId,
      String? statusUpdateerror,
      List<PreferVehicleData>? preferVehicleData,
      DeliveryPreferencesResponseModel? deliveryPreferencesResponseModel,
      String? selectedVehicleData}) {
    return DeliveryPreferencesState(
        dataLoading: dataLoading ?? false,
        prefdataLoading: prefdataLoading ?? false,
        typeLoad: typeLoad ?? false,
        statusUpdateLoading: statusUpdateLoading ?? false,
        isVehicleDropdownLoading: isVehicleDropdownLoading ?? false,
        statusUpdated: statusUpdated ?? false,
        error: error,
        typeId: typeId ?? this.typeId,
        statusUpdateerror: statusUpdateerror,
        preferVehicleData: preferVehicleData ?? this.preferVehicleData,
        deliveryPreferencesResponseModel: deliveryPreferencesResponseModel ??
            this.deliveryPreferencesResponseModel,
        selectedVehicleData: selectedVehicleData ?? this.selectedVehicleData);
  }
}
