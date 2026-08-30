import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/models/on_going_rides_data_model.dart';

class OngoingRidesResponseModel {
  final String errCode;
  final List<OngoingRidesDataModel> data;

  OngoingRidesResponseModel({required this.data, required this.errCode});

  factory OngoingRidesResponseModel.fromJson(Map<String, dynamic> json) =>
      OngoingRidesResponseModel(
        errCode: json['err_code'] ?? '',
        data: json["data"] != null
            ? List<OngoingRidesDataModel>.from(
                json["data"].map((x) => OngoingRidesDataModel.fromJson(x)))
            : [],
      );
}
