class OrderFromModel {
  OrderFromModel({
    required this.id,
    required this.amount,
    required this.time,
    required this.orderFrom,
    required this.date,
  });

  OrderFromModel.fromJson(dynamic json) {
    id = json['id'];
    amount = json['amount'];
    time = json['time'];
    orderFrom = json['orderFrom'];
    date = json['date'];
  }

  @override
  String toString() {
    return 'LoginModel{id: $id, amount: $amount, date: $date}, time: $time}, orderFrom: $orderFrom}';
  }

  String? id;
  String? amount;
  String? time;
  String? orderFrom;
  String? date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['time'] = time;
    map['orderFrom'] = orderFrom;
    map['date'] = date;
    return map;
  }
}
