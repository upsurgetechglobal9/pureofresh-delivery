part of 'rider_type_selected_data_cubit.dart';

 class RiderTypeSelectedDataState extends Equatable {
     final bool dataLoading;
  final String? error;
  final RiderTypeResponseModel? riderTypeResponseModel;
  const RiderTypeSelectedDataState({
    this.dataLoading = false,
    this.error,
    this.riderTypeResponseModel,
  });

  @override
  List<Object?> get props => [dataLoading, error, riderTypeResponseModel];

   RiderTypeSelectedDataState copyWith({
    bool? dataLoading,
    String? error,
    RiderTypeResponseModel? riderTypeResponseModel,
  }) {
    return RiderTypeSelectedDataState(
      dataLoading: dataLoading ?? false,
      error: error,
      riderTypeResponseModel: riderTypeResponseModel ??
          this.riderTypeResponseModel,
    );
  }
}

