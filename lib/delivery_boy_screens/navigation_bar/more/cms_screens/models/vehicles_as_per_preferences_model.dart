
class VehicleAsPerPrefernceModelResponse {
  final List<PreferVehicleData> statesPreferVechileList;

  VehicleAsPerPrefernceModelResponse({required this.statesPreferVechileList});

  factory VehicleAsPerPrefernceModelResponse.emptyList() {
    return VehicleAsPerPrefernceModelResponse(statesPreferVechileList: []);
  }

  factory VehicleAsPerPrefernceModelResponse.fromMap(Map<String, dynamic> map) {
    return VehicleAsPerPrefernceModelResponse(
      statesPreferVechileList: List<PreferVehicleData>.from(
        (map['data']).map<PreferVehicleData>(
          (x) => PreferVehicleData.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}



class PreferVehicleData {
  final String id;
  final String typeStateName;
  bool isSelected;

  PreferVehicleData({
    required this.id,
    required this.typeStateName,
    this.isSelected = false,
  });

  factory PreferVehicleData.fromMap(Map<String, dynamic> map) {
    return PreferVehicleData(
      id: map['id'].toString(),
      typeStateName: map['name'].toString(),
    );
  }

  factory PreferVehicleData.emptyModel() {
    return PreferVehicleData(
      id: '',
      typeStateName: '',
    );
  }
}



