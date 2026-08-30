class DeliveryServiceResponse {
  final DeliveryServiceData data;

  DeliveryServiceResponse({
    required this.data,
  });

  factory DeliveryServiceResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryServiceResponse(
      data: DeliveryServiceData.fromJson(json['data']),
    );
  }
}

class DeliveryServiceData {
  final bool isFood;
  final bool isCab;
  final bool isPickupAndDrop;

  DeliveryServiceData({
    required this.isFood,
    required this.isCab,
    required this.isPickupAndDrop,
  });

  factory DeliveryServiceData.fromJson(Map<String, dynamic> json) {
    return DeliveryServiceData(
      isFood: json['isFood']??false,
      isCab: json['isCab']??false,
      isPickupAndDrop: json['isPickupAndDrop']??false,
    );
  }
}
