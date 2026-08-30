class FaqsResponseModel {
  final List<Data> data;

  FaqsResponseModel({
    required this.data,
  });

  factory FaqsResponseModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<Data> data = dataList.map((item) => Data.fromJson(item)).toList();

    return FaqsResponseModel(
      data: data,
    );
  }
}

class Data {
  final String question;
  final String answer;

  Data({
    required this.question,
    required this.answer,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      question: json['question'],
      answer: json['answer'],
    );
  }
}
