// class PaginationModel {
//   PaginationModel({
//     required this.currentPage,
//     required this.lastPage,
//   });

//   int currentPage;
//   final int lastPage;

//   bool get isLastPage => currentPage == lastPage;

//   factory PaginationModel.initial() =>
//       PaginationModel(currentPage: 0, lastPage: 0);

//   factory PaginationModel.fromMap(Map<String, dynamic> json) => PaginationModel(
//       currentPage: json["current_page"] ?? 1, lastPage: json["last_page"] ?? 1);
// }

class PaginationTestModel {
  PaginationTestModel({
    required this.currentPage,
    required this.lastPage,
  });

  int currentPage;
  final int lastPage;

  bool get isLastPage => currentPage == lastPage;

  factory PaginationTestModel.initial() =>
      PaginationTestModel(currentPage: 0, lastPage: 0);

  factory PaginationTestModel.fromMap(Map<String, dynamic> json) =>
      PaginationTestModel(
          currentPage: json["current_page"] ?? 1,
          lastPage: json["total_pages"] ?? 1);
}
