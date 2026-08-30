class DeliveryPreferencesResponseModel {
  final List<InterestData> data;

  DeliveryPreferencesResponseModel({
    required this.data,
  });

  factory DeliveryPreferencesResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<InterestData> interestDataList =
        dataList.map((data) => InterestData.fromJson(data)).toList();

    return DeliveryPreferencesResponseModel(
      data: interestDataList,
    );
  }

   // Define the copyWith method
  DeliveryPreferencesResponseModel copyWith({
    List<InterestData>? data,
  }) {
    return DeliveryPreferencesResponseModel(
      data: data ?? this.data,
    );
  }
}

class InterestData {
  final String id;
  final String title;
  final String image;
     bool? status;

  InterestData({
    required this.id,
    required this.title,
    required this.image,
  this.status,
  });

  factory InterestData.fromJson(Map<String, dynamic> json) {
    return InterestData(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      status: json['status'] as bool?,
    );
  }
}
