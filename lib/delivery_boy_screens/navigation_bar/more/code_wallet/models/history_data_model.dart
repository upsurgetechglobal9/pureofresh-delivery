class HistoryDataModel {
  final String id;
  final String orderId;
  final String amount;
  final String createdAt;
  final String status;
 

  HistoryDataModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.createdAt,
    required this.status,
   
  });

  factory HistoryDataModel.fromJson(Map<String, dynamic> json) {
    return HistoryDataModel(
      id: json["id"] ?? '',
      orderId: json["order_id"] ?? '',
      amount: json["amount"] ?? '',
      createdAt: json["created_at"] ?? '',
      status: json["status"] ?? '',
      
    );
  }
}


