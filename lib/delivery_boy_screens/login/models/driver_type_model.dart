class RiderTypeResponseModel {
  final List<ServiceData> data;

  RiderTypeResponseModel({
    required this.data,
  });

  factory RiderTypeResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<ServiceData> serviceDataList =
        dataList.map((data) => ServiceData.fromJson(data)).toList();

    return RiderTypeResponseModel(
      data: serviceDataList,
    );
  }
}

class ServiceData {
  final String id;
  final String title;
  final String description;
  final String image;

  ServiceData({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }
}
