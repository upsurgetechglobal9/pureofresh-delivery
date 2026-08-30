part of 'cod_wallet_data_cubit.dart';

class CodWalletDataState extends Equatable {
  final bool dataLoading;
  final bool addmoneyLoad;
  final String? error;
  final bool isSuccess;
  final bool finalSuccess;
  final bool isPaymentInititeSuccess;
  final String? paymentId;
  final RazorpayPaymentModel? razorpayPaymentModel;
  //loadmore history
  final bool dataLoadingHistory;
  final String? errorHistory;
  final WalletHistoryDataModel? walletHistoryDataModel;

  const CodWalletDataState({
    this.dataLoading = false,
    this.addmoneyLoad = false,
    this.error,
    this.isSuccess = false,
    this.finalSuccess = false,
    this.isPaymentInititeSuccess = false,
    this.paymentId,
    this.razorpayPaymentModel,
    this.dataLoadingHistory = false,
    this.errorHistory,
    this.walletHistoryDataModel,
  });

  bool get walletListNotAvailable =>
      walletHistoryDataModel == null || walletHistoryDataModel!.results.isEmpty;

  @override
  List<Object?> get props => [
        dataLoading,
        addmoneyLoad,
        error,
        isSuccess,
        finalSuccess,
        isPaymentInititeSuccess,
        paymentId,
        razorpayPaymentModel,
        dataLoadingHistory,
        errorHistory,
        walletHistoryDataModel,
      ];

  CodWalletDataState copyWith({
    bool? dataLoading,
    bool? addmoneyLoad,
    String? error,
    bool? isSuccess,
    bool? finalSuccess,
    bool? isPaymentInititeSuccess,
    String? paymentId,
    RazorpayPaymentModel? razorpayPaymentModel,
    bool? dataLoadingHistory,
    String? errorHistory,
    WalletHistoryDataModel? walletHistoryDataModel,
  }) {
    return CodWalletDataState(
      dataLoading: dataLoading ?? false,
      addmoneyLoad: addmoneyLoad ?? false,
      error: error,
      isSuccess: isSuccess ?? false,
      finalSuccess: finalSuccess ?? false,
      isPaymentInititeSuccess: isPaymentInititeSuccess ?? false,
      paymentId: paymentId,
      razorpayPaymentModel: razorpayPaymentModel,
      dataLoadingHistory: dataLoading ?? false,
      errorHistory: errorHistory,
      walletHistoryDataModel:
          walletHistoryDataModel ?? this.walletHistoryDataModel,
    );
  }
}
