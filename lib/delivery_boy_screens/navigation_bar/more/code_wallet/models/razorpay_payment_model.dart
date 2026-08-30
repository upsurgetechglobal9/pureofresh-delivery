class RazorpayPaymentModel {
  final String errCode;
  final String message;
  final String orderId;
  final RazorpayDetails razorpayDetails;

  RazorpayPaymentModel({
    required this.errCode,
    required this.message,
    required this.orderId,
    required this.razorpayDetails,
  });

  factory RazorpayPaymentModel.fromJson(Map<String, dynamic> json) {
    return RazorpayPaymentModel(
      errCode: json['err_code'],
      message: json['message'],
      orderId: json['order_id'],
      razorpayDetails: RazorpayDetails.fromJson(json['razerpay_details']),
    );
  }
}

class RazorpayDetails {
  final String amount;
  final String customerMobile;
  final String customerEmail;
  final String paymentGatewayAccessKey;
  final String paymentGatewaySecret;
  final String razorpayOrderId;
  final String refId;

  RazorpayDetails({
    required this.amount,
    required this.customerMobile,
    required this.customerEmail,
    required this.paymentGatewayAccessKey,
    required this.paymentGatewaySecret,
    required this.razorpayOrderId,
    required this.refId,
  });

  factory RazorpayDetails.fromJson(Map<String, dynamic> json) {
    return RazorpayDetails(
      amount: json['amount'],
      customerMobile: json['customer_mobile'],
      customerEmail: json['customer_email'],
      paymentGatewayAccessKey: json['payment_gateway_access_key'],
      paymentGatewaySecret: json['payment_gateway_secret'],
      razorpayOrderId: json['razorpay_order_id'],
      refId: json['ref_id'],
    );
  }
}
