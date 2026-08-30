import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../logic/cubit/cod_wallet_data_cubit.dart';
import 'cod_wallet.dart';

class AddWaletPaymentScreen extends StatefulWidget {
  final int paymentId;
  const AddWaletPaymentScreen({super.key, required this.paymentId});

  @override
  State<AddWaletPaymentScreen> createState() => _AddWaletPaymentScreenState();
}

class _AddWaletPaymentScreenState extends State<AddWaletPaymentScreen> {
  late InAppWebViewController _webViewController;

  String url = "";
  double progress = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          titleSpacing: 23,
          title: const Text('Pure O Fresh Payment')),
      body: Column(children: <Widget>[
        // Text('https://trimmit.in/api/customer/addwallet/paymentview/${widget.accesstoken}/${widget.amount}'),
        Container(
            padding: const EdgeInsets.all(10.0),
            child: progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container()),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                    "https://trimmit.in/api/delivery_persons/cod_wallet/do_payment/${widget.paymentId}"),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStart: (InAppWebViewController controller, Uri? url) {
                setState(() {
                  this.url = url.toString();
                });
              },
              onLoadStop: (InAppWebViewController controller, Uri? url) async {
                setState(() {
                  this.url = url.toString();
                });

                if (this.url.contains('payment_success')) {
                  context.read<CodWalletDataCubit>().featchWalletHisto(
                        loadMoreData: true,
                      );

                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const CashOnDeliveryWallet(),
                    ),
                  );
                } else if (this.url.contains('payment_fail')) {
                  context.read<CodWalletDataCubit>().featchWalletHisto(
                        loadMoreData: true,
                      );
                  Navigator.pop(context);
                  Navigator.pop(context);
                }

                // if (this.url ==
                //     'https://fintaxfilings.com/api/user/Stripe_payment/payment_success') {}
                // if (this.url ==
                //     "https://fintaxfilings.com/Stripe_payment/payment_fail") {}
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
          ),
        ),
      ]),
    );
  }
}
