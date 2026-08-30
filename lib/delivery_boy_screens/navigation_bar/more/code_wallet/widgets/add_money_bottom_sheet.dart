import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../utility/bottons/theme_button.dart';
import '../../../../../utility/colors_data.dart';
import '../logic/cubit/cod_wallet_data_cubit.dart';
import '../screens/razorpay_payment_screen.dart';

class _AddMoneyBottomSheet extends StatefulWidget {
  const _AddMoneyBottomSheet({
    super.key,
    required this.moneyController,
  });
  final TextEditingController moneyController;

  @override
  State<_AddMoneyBottomSheet> createState() => _AddMoneyBottomShhetState();
}

class _AddMoneyBottomShhetState extends State<_AddMoneyBottomSheet> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ADD AMOUNT',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CLOSE',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                ]),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              'Enter your amount',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                enabled: true,
                keyboardType: TextInputType.number,
                controller: widget.moneyController,
                cursorColor: ColorsData.themeColor,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
                cursorWidth: 1,
                maxLines: 1,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Field Can\'t be empty';
                  } else {
                    return null;
                  }
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  FilteringTextInputFormatter.deny(RegExp('^0+')),
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  isDense: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 1, color: ColorsData.greytimeColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 1, color: ColorsData.greytimeColor)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 1, color: ColorsData.greytimeColor)),

                  //     // contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5),

                  fillColor: Colors.white,

                  errorText: null,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: ColorsData.greytimeColor, width: 1),
                      borderRadius: BorderRadius.circular(10)),

                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          width: 1, color: ColorsData.greytimeColor)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: BlocConsumer<CodWalletDataCubit, CodWalletDataState>(
              listener: (context, state) {
                if (state.isPaymentInititeSuccess == true) {
                  if (state.razorpayPaymentModel != null) {
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RazorpayPaymentScreen(
                            paymentModel: state.razorpayPaymentModel!,
                          ),
                        ));
                  } else {
                    Fluttertoast.showToast(
                      msg: "Something went wrong please try after sometime",
                    );
                    Navigator.pop(context);
                  }

                  print('Open Razorpay Payment Gateway');
                }
              },
              builder: (context, state) {
                return BlocBuilder<CodWalletDataCubit, CodWalletDataState>(
                  builder: (context, codWalletDataState) {
                    if (codWalletDataState.addmoneyLoad) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ThemeElevatedButton(
                        key: const Key("send_button"),
                        showLoadingSpinner: codWalletDataState.addmoneyLoad,
                        buttonName: 'SEND',
                        textFontSize: 16,
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            context.read<CodWalletDataCubit>().addMonetTowallet(
                                amount: widget.moneyController.text);
                            print('0000');
                          }
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void showAddCashBottomSheet(
    BuildContext context, TextEditingController textController) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (_) {
      return _AddMoneyBottomSheet(moneyController: textController);
    },
  );
}
