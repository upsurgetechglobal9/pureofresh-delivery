part of 'ongoing_rides_data_cubit.dart';

 class OngoingRidesDataState extends Equatable {
  final bool dataLoading;
  final bool deliveryServiceLoad;

  

  final String? error;
  final String? deliveryServiceerror;

  final bool singleOrderdataLoading;
  final String? singleOrdererror;



  final OngoingRidesResponseModel ongoingRidesResponseModel;
  final DeliveryServiceResponse deliveryServiceResponse;
  final SingleOngoingOrderModel singleOngoingOrderModel;

 

  const OngoingRidesDataState({
    this.dataLoading = false,
    this.singleOrderdataLoading = false,
    this.deliveryServiceLoad = false,

    this.error,
    this.singleOrdererror,

    this.deliveryServiceerror,
   required this.ongoingRidesResponseModel,
   required this.deliveryServiceResponse,
   required this.singleOngoingOrderModel,


  });

  @override
  List<Object?> get props => [
        dataLoading,
        singleOrderdataLoading,
        deliveryServiceLoad,
        error,
        singleOrdererror,
        deliveryServiceerror,
        ongoingRidesResponseModel,
        deliveryServiceResponse,
        singleOngoingOrderModel,
      ];

   OngoingRidesDataState copyWith({
    bool? dataLoading,
    bool? singleOrderdataLoading,

    bool? deliveryServiceLoad,

    String? error,
    String? singleOrdererror,
    String? deliveryServiceerror,
    OngoingRidesResponseModel? ongoingRidesResponseModel,
   DeliveryServiceResponse? deliveryServiceResponse,
   SingleOngoingOrderModel?singleOngoingOrderModel,

  }) {
    return OngoingRidesDataState(
      dataLoading: dataLoading ?? false,
      singleOrderdataLoading: singleOrderdataLoading ?? false,

      deliveryServiceLoad:deliveryServiceLoad??false,
      error: error,
      singleOrdererror: singleOrdererror,

      deliveryServiceerror:deliveryServiceerror,
      ongoingRidesResponseModel:
          ongoingRidesResponseModel ?? this.ongoingRidesResponseModel,
          deliveryServiceResponse:
          deliveryServiceResponse ?? this.deliveryServiceResponse,
          singleOngoingOrderModel:
          singleOngoingOrderModel ?? this.singleOngoingOrderModel,
     
    );
  }
}

