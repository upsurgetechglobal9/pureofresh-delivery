
import 'history_data_model.dart';
import 'pagination_model.dart';

class WalletHistoryDataModel {
  final String walletAmount;
  final List<HistoryDataModel> results;
  PaginationTestModel paginationModel;

  WalletHistoryDataModel({
    required this.walletAmount,
    required this.results,
    required this.paginationModel,
  });

  factory WalletHistoryDataModel.emptyModel() => WalletHistoryDataModel(
      walletAmount: '0',
      results: [], paginationModel: PaginationTestModel.initial());
  factory WalletHistoryDataModel.fromJson(Map<String, dynamic> json) =>
      WalletHistoryDataModel(
        walletAmount: json["cod_cash_wallet"]??'0',
        results: List<HistoryDataModel>.from(
            json["results"].map((x) => HistoryDataModel.fromJson(x))),
        paginationModel: PaginationTestModel.fromMap(json),
      );

  //Use for pagination
  WalletHistoryDataModel paginationCopyWith({required WalletHistoryDataModel newData}) {
    results.addAll(newData.results);
    paginationModel = newData.paginationModel;
    return WalletHistoryDataModel(
      walletAmount: '0',
        results: results, paginationModel: paginationModel);
  }
}
