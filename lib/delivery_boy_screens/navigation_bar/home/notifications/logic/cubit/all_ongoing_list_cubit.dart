// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// import '../../models/single_ongoing_order_model.dart';
// import '../../repository/all_ongoing_order_repository.dart';

// part 'all_ongoing_list_state.dart';

// class AllOngoingListCubit extends Cubit<AllOngoingListState> {
//   AllOngoingListCubit() : super(const AllOngoingListState());

 
//   Future<void> fetchSingleOrderList({bool showLoading = false}) async {
//     try {
//       if (showLoading) {
// emit(state.copyWith(
//             dataLoading: true,
//             type: '',
//             ridesList: SingleOngoingOrderModel(data: [], errCode: '')));
//       }
      
//       SingleOngoingOrderModel ongoingRidesResponseModel =
//           await AllOngoingListRepository().fetchSingleOrderList();
//       if (ongoingRidesResponseModel.errCode == 'valid') {
//         emit(state.copyWith(
//             ridesList: ongoingRidesResponseModel,
//             dataLoading: false,
//             type: ongoingRidesResponseModel.data[0].type));
//       }
//       if (ongoingRidesResponseModel.errCode == 'invalid') {
//         emit(state.copyWith(
//             ridesList: SingleOngoingOrderModel(data: [], errCode: 'invalid'),
//             dataLoading: false));
//       }
//     } catch (e) {
//       // Record the error in Firebase Crashlytics
//       if (isClosed) {
//         return;
//       }
//       emit(state.copyWith(error: e.toString()));
//     }
//   }
// }
