// To parse this JSON data, do
//
//     final payoutHistoryModel = payoutHistoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PayoutHistoryModel payoutHistoryModelFromJson(String str) =>
    PayoutHistoryModel.fromJson(json.decode(str));

String payoutHistoryModelToJson(PayoutHistoryModel data) =>
    json.encode(data.toJson());

class PayoutHistoryModel {
  String errCode;
  String title;
  String message;
  Data data;

  PayoutHistoryModel({
    required this.errCode,
    required this.title,
    required this.message,
    required this.data,
  });

  factory PayoutHistoryModel.fromJson(Map<String, dynamic> json) =>
      PayoutHistoryModel(
        errCode: json["err_code"],
        title: json["title"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode,
        "title": title,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Results results;

  Data({
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: Results.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "results": results.toJson(),
      };
}

class Results {
  int totalResultsFound;
  int totalPages;
  List<PayoutHistory> payoutHistory;

  Results({
    required this.totalResultsFound,
    required this.totalPages,
    required this.payoutHistory,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        totalResultsFound: json["total_results_found"],
        totalPages: json["total_pages"],
        payoutHistory: List<PayoutHistory>.from(
            json["payout_history"].map((x) => PayoutHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_results_found": totalResultsFound,
        "total_pages": totalPages,
        "payout_history":
            List<dynamic>.from(payoutHistory.map((x) => x.toJson())),
      };
}

class PayoutHistory {
  String id;
  String payoutRefId;
  String requestType;
  String requestedAmount;
  String createdDateTime;
  String requestStatus;
  String deliveryPersonComment;
  String adminComment;
  String responseActionDate;
  String deliveryPersonsId;
  String accountName;
  String accountNumber;
  String bankName;
  String branch;
  String ifscCode;
  String utrRefNo;
  String fromDate;
  String toDate;
  String transactionStatus;
  String remark;
  String payoutDeliveryPersonTransactionsIds;
  String paymentMode;
  String narration;
  String requestedTime;
  String requestStatusBootstrapClass;
  String adminRefId;

  PayoutHistory({
    required this.id,
    required this.payoutRefId,
    required this.requestType,
    required this.requestedAmount,
    required this.createdDateTime,
    required this.requestStatus,
    required this.deliveryPersonComment,
    required this.adminComment,
    required this.responseActionDate,
    required this.deliveryPersonsId,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.branch,
    required this.ifscCode,
    required this.utrRefNo,
    required this.fromDate,
    required this.toDate,
    required this.transactionStatus,
    required this.remark,
    required this.payoutDeliveryPersonTransactionsIds,
    required this.paymentMode,
    required this.narration,
    required this.requestedTime,
    required this.requestStatusBootstrapClass,
    required this.adminRefId,
  });

  factory PayoutHistory.fromJson(Map<String, dynamic> json) => PayoutHistory(
        id: json["id"],
        payoutRefId: json["payout_ref_id"],
        requestType: json["request_type"],
        requestedAmount: json["requested_amount"],
        createdDateTime: json["created_date_time"],
        requestStatus: json["request_status"],
        deliveryPersonComment: json["delivery_person_comment"],
        adminComment: json["admin_comment"],
        responseActionDate: json["response_action_date"],
        deliveryPersonsId: json["delivery_persons_id"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        bankName: json["bank_name"],
        branch: json["branch"],
        ifscCode: json["ifsc_code"],
        utrRefNo: json["utr_ref_no"],
        fromDate: json["from_date"],
        toDate: json["to_date"],
        transactionStatus: json["transaction_status"],
        remark: json["remark"],
        payoutDeliveryPersonTransactionsIds:
            json["payout_delivery_person_transactions_ids"],
        paymentMode: json["payment_mode"],
        narration: json["narration"],
        requestedTime: json["requested_time"],
        requestStatusBootstrapClass: json["request_status_bootstrap_class"],
        adminRefId: json["admin_ref_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payout_ref_id": payoutRefId,
        "request_type": requestType,
        "requested_amount": requestedAmount,
        "created_date_time": createdDateTime,
        "request_status": requestStatus,
        "delivery_person_comment": deliveryPersonComment,
        "admin_comment": adminComment,
        "response_action_date": responseActionDate,
        "delivery_persons_id": deliveryPersonsId,
        "account_name": accountName,
        "account_number": accountNumber,
        "bank_name": bankName,
        "branch": branch,
        "ifsc_code": ifscCode,
        "utr_ref_no": utrRefNo,
        "from_date": fromDate,
        "to_date": toDate,
        "transaction_status": transactionStatus,
        "remark": remark,
        "payout_delivery_person_transactions_ids":
            payoutDeliveryPersonTransactionsIds,
        "payment_mode": paymentMode,
        "narration": narration,
        "requested_time": requestedTime,
        "request_status_bootstrap_class": requestStatusBootstrapClass,
        "admin_ref_id": adminRefId,
      };
}
