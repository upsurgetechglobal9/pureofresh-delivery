import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/razorpay_payment_model.dart';
import '../../models/wallet_history_data_model.dart';
import '../../repository/cod_wallet_repository.dart';

part 'cod_wallet_data_state.dart';

class CodWalletDataCubit extends Cubit<CodWalletDataState> {
  final WalletRepository walletRepository;
  CodWalletDataCubit(this.walletRepository) : super(const CodWalletDataState());

  Future<void> addMonetTowallet({required String amount}) async {
    try {
      emit(state.copyWith(addmoneyLoad: true));
      final int orderId = await walletRepository.genarateOrderid();
      emit(state.copyWith(isSuccess: true));
      if (state.isSuccess == true) {
        try {
          walletRepository
              .initiatePayment(orderId: orderId, amount: amount)
              .then((razorpayPaymentModel) {
            emit(state.copyWith(
                isPaymentInititeSuccess: true,
                paymentId: razorpayPaymentModel.orderId.toString(),
                razorpayPaymentModel: razorpayPaymentModel));
          });
        } catch (error) {
          Fluttertoast.showToast(
            msg: error.toString(),
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.pinkAccent[100],
            textColor: Colors.white,
          );
          if (isClosed) {
            return;
          }
        }
        emit(state.copyWith(addmoneyLoad: false));
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.pinkAccent[100],
        textColor: Colors.white,
      );
      if (isClosed) {
        return;
      }
    }
  }

  Future<void> featchWalletHisto({bool loadMoreData = false}) async {
    try {
      // Loading indicator when data is being fetched
      emit(state.copyWith(dataLoadingHistory: !loadMoreData));
      if (loadMoreData && state.walletHistoryDataModel != null) {
        // Run the fetch connection API if it's not the last page.
        if (!state.walletHistoryDataModel!.paginationModel.isLastPage) {
          // Increase the current page counter
          state.walletHistoryDataModel!.paginationModel.currentPage += 1;
          final moreData = await walletRepository.loadMoreWalletHistory(
            page: state.walletHistoryDataModel!.paginationModel.currentPage,
          );
          // Update the state with the new data.
          emit(
            state.copyWith(
              // Check if the items are already in the list to avoid duplicates.
              walletHistoryDataModel: state.walletHistoryDataModel!
                  .paginationCopyWith(newData: moreData),
            ),
          );
          return;
        }
      } else {
        // Refreshing or loading initial data
        final restoList = await walletRepository.loadMoreWalletHistory();
        // Update the state with the new data.
        emit(state.copyWith(walletHistoryDataModel: restoList));
      }

      return;
    } catch (e) {
      // Error handling
      if (isClosed) {
        return;
      }
      if (state.walletListNotAvailable) {
        emit(state.copyWith(
            errorHistory: e.toString(), dataLoadingHistory: false));
        return;
      } else {
        emit(state.copyWith(dataLoadingHistory: false));
        return;
      }
    }
  }

  Future<void> confirmPaymentSuccess({
    required String orderId,
    required String paymentId,
  }) async {
    try {
      await walletRepository.confirmPaymentSuccess(
        orderId: orderId,
        paymentId: paymentId,
      );
      emit(state.copyWith(
          isSuccess: false,
          isPaymentInititeSuccess: false,
          finalSuccess: true));
      // Optionally, you can refresh the wallet history after a successful payment
      featchWalletHisto();
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.pinkAccent[100],
        textColor: Colors.white,
      );
      if (isClosed) {
        return;
      }
    }
  }

  Future<void> confirmPaymentFail({
    required String orderId,
  }) async {
    try {
      await walletRepository.confirmPaymentFail(
        orderId: orderId,
      );
      emit(state.copyWith(isSuccess: false, isPaymentInititeSuccess: false));
      // Optionally, you can refresh the wallet history after a successful payment
      featchWalletHisto();
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.pinkAccent[100],
        textColor: Colors.white,
      );
      if (isClosed) {
        return;
      }
    }
  }
}
