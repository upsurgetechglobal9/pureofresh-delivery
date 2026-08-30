class OngoingRidesDataModel {
  final String id;
  final String pickupDistance;
  final String orderId;
  final String grandTotal;
  final String droppingDistance;
  final String pickupFrom;
  final List<LatLngAddressModel> destinationLatLngAr;

  final String note;
  final String status;
  final String type;

  OngoingRidesDataModel(
      {required this.id,
      required this.pickupDistance,
      required this.orderId,
      required this.grandTotal,
      required this.droppingDistance,
      required this.pickupFrom,
      required this.destinationLatLngAr,
      required this.note,
      required this.status,
      required this.type});

  factory OngoingRidesDataModel.fromJson(Map<String, dynamic> json) {
    return OngoingRidesDataModel(
        id: json["id"],
        pickupDistance: json['pickup_distance'] ?? "N/A",
        orderId: json["order_id"] ?? 'N/A',
        grandTotal: json["grand_total"] ?? 'N/A',
        droppingDistance: json["dropping_distance"] ?? 'N/A',
        pickupFrom: json["pickup_from"] ?? 'N/A',
        destinationLatLngAr: List<LatLngAddressModel>.from(
            json['dropping_locations']
                .map((x) => LatLngAddressModel.fromJson(x))),
        note: json["note"] ?? 'N/A',
        status: json["status"] ?? 'N/A',
        type: json['type'] ?? '');
  }
}

class LatLngAddressModel {
  final String lat;
  final String lng;
  final String address;
  final String personName;
  final String personNumber;

  LatLngAddressModel({
    required this.lat,
    required this.lng,
    required this.address,
    required this.personName,
    required this.personNumber,
  });

  factory LatLngAddressModel.fromJson(Map<String, dynamic> json) {
    return LatLngAddressModel(
      lat: json['lat'],
      lng: json['lng'],
      address: json['address'],
      personName: json['person_name'] ?? '',
      personNumber: json['person_number'] ?? '',
    );
  }
}
