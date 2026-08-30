import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/models/nitifications_list_data_model.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/models/page_nation_model.dart';

class NotificationsDataNewResponseModel {
  final List<NotificationsDataNewDataModel> results;
  PaginationTestModel paginationTestModel;

  NotificationsDataNewResponseModel({
    required this.results,
    required this.paginationTestModel,
  });

  factory NotificationsDataNewResponseModel.emptyModel() =>
      NotificationsDataNewResponseModel(
          results: [], paginationTestModel: PaginationTestModel.initial());
  factory NotificationsDataNewResponseModel.fromJson(
          Map<String, dynamic> json) =>
      NotificationsDataNewResponseModel(
        results: List<NotificationsDataNewDataModel>.from(json["results"]
            .map((x) => NotificationsDataNewDataModel.fromJson(x))),
        paginationTestModel: PaginationTestModel.fromMap(json),
      );

  //Use for pagination
  NotificationsDataNewResponseModel paginationCopyWith(
      {required NotificationsDataNewResponseModel newData}) {
    results.addAll(newData.results);
    paginationTestModel = newData.paginationTestModel;
    return NotificationsDataNewResponseModel(
        results: results, paginationTestModel: paginationTestModel);
  }
}
