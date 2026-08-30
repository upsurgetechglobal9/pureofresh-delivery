import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../utility/colors_data.dart';
import '../logic/cubit/cod_wallet_data_cubit.dart';
import '../widgets/add_money_bottom_sheet.dart';
import '../widgets/add_money_widget.dart';

class CashOnDeliveryWallet extends StatefulWidget {
  const CashOnDeliveryWallet({super.key});

  @override
  State<CashOnDeliveryWallet> createState() => _CashOnDeliveryWalletState();
}

class _CashOnDeliveryWalletState extends State<CashOnDeliveryWallet> {
  TextEditingController moneyController = TextEditingController();
  bool isObscureTextOld = false;
  bool isOldPasswordError = false;

  final walletListScrollController = ScrollController();

  DateTime? previousEventTime;
  double previousScrollOffset = 0;

  @override
  void initState() {
    context.read<CodWalletDataCubit>().featchWalletHisto();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      walletListScrollController.addListener(() {
        walletListScrollController.position.isScrollingNotifier.addListener(() {
          //////

          if (walletListScrollController.position.maxScrollExtent ==
              walletListScrollController.offset) {
            context.read<CodWalletDataCubit>().featchWalletHisto(
                  loadMoreData: true,
                );
          }

          //Find the scrolling speed
          final currentScrollOffset =
              walletListScrollController.position.pixels;
          final currentTime = DateTime.now();

          previousEventTime = currentTime;
          previousScrollOffset = currentScrollOffset;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 4,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 16,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // leading: null,
        title: Text(
          ConvertText.getTitle("COD Wallet"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<CodWalletDataCubit, CodWalletDataState>(
        builder: (context, codWalletDataState) {
          if (codWalletDataState.errorHistory != null) {
            return Text(codWalletDataState.errorHistory!);
          } else if (codWalletDataState.dataLoadingHistory) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.red,
                size: 50,
              ),
            );
          } else if (codWalletDataState.walletHistoryDataModel == null) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.red,
                size: 50,
              ),
            );
          } else {
            final logs = codWalletDataState.walletHistoryDataModel;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WalletBalanceCardWidget(
                    balance: codWalletDataState
                        .walletHistoryDataModel!.walletAmount
                        .toString(),
                    onTapFun: () =>
                        //     Fluttertoast.showToast(
                        //   msg: 'Payment Gateway Under Process ',
                        //   gravity: ToastGravity.CENTER,
                        //   backgroundColor: Colors.pinkAccent[100],
                        //   textColor: Colors.white,
                        // ),
                        showAddCashBottomSheet(context, moneyController)),
                // balance: codWalletDataState
                //     .walletHistoryDataModel!.walletAmount
                //     .toString(),
                // onTapFun: () {}
                // showAddCashBottomSheet(context, moneyController),

                const Text(
                  'Transations',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: ColorsData.cardGrey,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transation Id',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          'Status',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          'Cash',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.red,
                    onRefresh: () async {
                      context.read<CodWalletDataCubit>().featchWalletHisto();
                    },
                    child: logs!.results.isEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/images/no_wallet.png',
                                  width: 190,
                                  height: 240,
                                ),
                              ),
                              const CommonProximaNovaTextWidget(
                                text: 'No COD Wallet yet',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )
                            ],
                          ))
                        : ListView.builder(
                            controller: codWalletDataState.dataLoadingHistory
                                ? null
                                : walletListScrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemCount: logs.results.length +
                                (logs.paginationModel.isLastPage ? 0 : 1),
                            itemBuilder: (BuildContext context, int index) {
                              if (index < logs.results.length) {
                                final resto = logs.results[index];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '#${resto.orderId} \n ${resto.createdAt}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                          const Spacer(),
                                          Text(
                                            resto.status,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '₹${resto.amount}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      height: 1,
                                      thickness: 2.0,
                                    ),
                                  ],
                                );
                              } else if (logs.paginationModel.isLastPage) {
                                return const SizedBox.shrink();
                              } else {
                                return const LinearProgressIndicator(
                                  color: Colors.black,
                                  backgroundColor: Colors.green,
                                );
                              }
                            },
                          ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
