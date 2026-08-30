import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../logic/cubit/cod_wallet_data_cubit.dart';
import '../models/razorpay_payment_model.dart';
import 'cod_wallet.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  final RazorpayPaymentModel paymentModel;

  const RazorpayPaymentScreen({
    super.key,
    required this.paymentModel,
  });

  @override
  State<RazorpayPaymentScreen> createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Start payment immediately when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPayment();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _startPayment() {
    var options = {
      'key': widget.paymentModel.razorpayDetails.paymentGatewayAccessKey,
      'amount': (double.parse(widget.paymentModel.razorpayDetails.amount) * 100)
          .toInt(), // Amount in paise
      'name': 'Pure O Fresh',
      'description': 'Wallet Recharge',
      'order_id': widget.paymentModel.razorpayDetails.razorpayOrderId,
      'prefill': {
        'contact': widget.paymentModel.razorpayDetails.customerMobile,
        'email': widget.paymentModel.razorpayDetails.customerEmail,
      },
      'theme': {'color': '#F37254'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      Navigator.pop(context);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Call the payment success API with order_id and payment_id
    context.read<CodWalletDataCubit>().confirmPaymentSuccess(
          orderId: widget.paymentModel.orderId,
          paymentId: response.paymentId ?? '',
        );
    print(widget.paymentModel.orderId);
    print(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    context.read<CodWalletDataCubit>().confirmPaymentFail(
          orderId: widget.paymentModel.orderId,
        );
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.message}",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet: ${response.walletName}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocListener<CodWalletDataCubit, CodWalletDataState>(
        listener: (context, state) {
          if (state.finalSuccess == true) {
            Navigator.pop(context);
            // Navigator.pushAndRemoveUntil<void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (BuildContext context) => const CashOnDeliveryWallet(),
            //   ),
            //       (Route<dynamic> route) => false,
            // );
          }
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Initiating Payment...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please wait while we redirect you to payment gateway',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
