import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/models/delivery_preferences_data_model.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/repository/delivery_preferences_repository.dart';

import '../../models/vehicles_as_per_preferences_model.dart';

part 'delivery_preferences_state.dart';

class DeliveryPreferencesCubit extends Cubit<DeliveryPreferencesState> {
  final DeliveryPreferencesRepository deliveryPreferencesRepository;

  List<String> selectedIds = [];
  DeliveryPreferencesCubit(this.deliveryPreferencesRepository)
      : super(const DeliveryPreferencesState(preferVehicleData: []));

//     // Add a method to toggle the status based on index
//  void toggleStatus(int index , String itemId) {
//     final List<InterestData>? currentData =
//         state.deliveryPreferencesResponseModel?.data;
//     if (currentData != null && index >= 0 && index < currentData.length) {
//       currentData[index].status = !currentData[index].status!; // Toggle status
//       emit(state.copyWith(
//           deliveryPreferencesResponseModel: state
//               .deliveryPreferencesResponseModel
//               ?.copyWith(data: currentData)));

//                 // Call your API update method here with the item ID
//       updateApi(itemId, currentData[index].status!);
//     }
//   }

//   // This method should be replaced with your actual API update method
//   void updateApi(String itemId, bool status) {
//     // Your API update logic here
//   }

  void toggleStatus(int index, String itemId) {
    final List<InterestData>? currentData =
        state.deliveryPreferencesResponseModel?.data;
    if (currentData != null && index >= 0 && index < currentData.length) {
      currentData[index].status = !currentData[index].status!; // Toggle status
      if (currentData[index].status!) {
        selectedIds.add(itemId); // Add item ID to selected list
      } else {
        selectedIds.remove(itemId); // Remove item ID from selected list
      }
      emit(state.copyWith(
          deliveryPreferencesResponseModel: state
              .deliveryPreferencesResponseModel
              ?.copyWith(data: currentData)));
      // Call your API update method here with the comma-separated string of selected IDs
      // updateApi(selectedIds.join(','));
    }
  }

  // This method should be replaced with your actual API update method
  void updateApi() async {
    // Your API update logic here

    try {
      String selectedIds = '';
      for (var i = 0;
          i < state.deliveryPreferencesResponseModel!.data.length;
          i++) {
        if (state.deliveryPreferencesResponseModel!.data[i].status == true) {
          if (selectedIds.isNotEmpty) {
            selectedIds += ','; // Add a comma if selectedIds is not empty
          }
          selectedIds += state.deliveryPreferencesResponseModel!.data[i].id
              .toString(); // Append the ID
        }
      }
      emit(state.copyWith(statusUpdateLoading: true));
      final statusUpdated = await deliveryPreferencesRepository
          .updateDeliveryPreferences(selectedIds);
      emit(state.copyWith(statusUpdated: statusUpdated));
    } catch (e) {
      emit(state.copyWith(statusUpdateerror: e.toString()));
    }
  }

  Future<void> featchDeliveryPreferences() async {
    try {
      emit(state.copyWith(dataLoading: true));
      final deliveryPreferencesResponseModel =
          await deliveryPreferencesRepository.featchDeliveryPreferences();
      emit(state.copyWith(
          deliveryPreferencesResponseModel: deliveryPreferencesResponseModel));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), dataLoading: false));
    }
  }

  Future<void> fetchVechilesStates(String typeId) async {
    try {
      emit(state.copyWith(dataLoading: true));
      final allstates =
          await deliveryPreferencesRepository.fetchVechiles(typeId);
      emit(state.copyWith(preferVehicleData: allstates, dataLoading: false));
    } catch (e) {
      emit(state.copyWith(dataLoading: false));
    }
  }

  Future<void> featchDeliveryType() async {
    try {
      emit(state.copyWith(typeLoad: true));
      final typeId = await deliveryPreferencesRepository.featchDeliveryType();
      print('typeId >> sucess$typeId');
      emit(state.copyWith(typeId: typeId, typeLoad: false));
    } catch (e) {
      print('typeId >> fail$e');

      emit(state.copyWith(typeId: '1', typeLoad: false));
    }
  }

  Future<void> selectedDataVechile({
    required String ctiyName,
  }) async {
    try {
      emit(state.copyWith(isVehicleDropdownLoading: true));
      for (var i = 0; i < state.preferVehicleData.length; i++) {
        if (state.preferVehicleData[i].typeStateName == ctiyName) {
          state.preferVehicleData[i].isSelected = true;
        } else {
          state.preferVehicleData[i].isSelected = false;
        }
      }
      emit(state.copyWith(preferVehicleData: state.preferVehicleData));
    } catch (e) {
      emit(state.copyWith());
    }
  }
}
