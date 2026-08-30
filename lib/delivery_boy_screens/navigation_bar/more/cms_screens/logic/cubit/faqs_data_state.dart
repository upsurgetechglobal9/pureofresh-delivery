part of 'faqs_data_cubit.dart';

 class FaqsDataState extends Equatable {
  final bool dataLoading;
  final String? error;
   final int currentIndex;
  final FaqsResponseModel? faqsResponseModel;
  const FaqsDataState({
    this.dataLoading = false,
    this.error,
     this.currentIndex = 0,
    this.faqsResponseModel,
  });

  @override
  List<Object?> get props => [
        dataLoading,
        error,currentIndex,
        faqsResponseModel
      ];

       FaqsDataState copyWith({
    bool? dataLoading,
    String? error,
      int? currentIndex,
    FaqsResponseModel? faqsResponseModel,
  }) {
    return FaqsDataState(
      dataLoading: dataLoading ?? false,
      error: error,
      currentIndex: currentIndex ?? 0,
      faqsResponseModel: faqsResponseModel ??
          this.faqsResponseModel,
    );
  }
}


