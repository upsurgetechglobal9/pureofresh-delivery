import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

import '../../../../../utility/widgets/theme_spinner.dart';
import '../../../../registration/upload_profile_pic/screens/upload_profile_image_screen.dart';
import '../logic/cubit/delivery_preferences_cubit.dart';
import '../models/vehicles_as_per_preferences_model.dart';
import '../widgets/drop_down_widget.dart';
import '../widgets/grid_shimmer.dart';

class DeliveryPrefDropDownScreen extends StatefulWidget {
  final String typeId;
  const DeliveryPrefDropDownScreen({super.key, required this.typeId});

  @override
  State<DeliveryPrefDropDownScreen> createState() =>
      _DeliveryPrefDropDownScreenState();
}

class _DeliveryPrefDropDownScreenState
    extends State<DeliveryPrefDropDownScreen> {
  PreferVehicleData? preferVehicleData;

  @override
  void initState() {
    context.read<DeliveryPreferencesCubit>().fetchVechilesStates(widget.typeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return  Align(
    //   alignment: Alignment.center,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Image.asset('assets/images/nodata.png',height: MediaQuery.of(context).size.height * 0.3,width: 130,),
    //       const SizedBox(height: 10,),
    //       const CommonProximaNovaTextWidget(text: 'Delivery Preferences Already Updated',color: Colors.black,fontWeight: FontWeight.w500,)
    //      ],
    //   ),
    // );
    return BlocBuilder<DeliveryPreferencesCubit, DeliveryPreferencesState>(
      builder: (context, deliveryPreferencesState) {
        if (deliveryPreferencesState.dataLoading) {
          return const GirdShimmierWidget();
        } else if (deliveryPreferencesState.error != null) {
          return CommonProximaNovaTextWidget(
              text: deliveryPreferencesState.error!);
        } else {
          if (deliveryPreferencesState.preferVehicleData.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ThemeTextFormFieldDropDown<PreferVehicleData>(
                    value: preferVehicleData,
                    suffixIcon:
                        deliveryPreferencesState.isVehicleDropdownLoading
                            ? const ThemeSpinner(
                                size: 30,
                                color: Colors.black,
                              )
                            : const Icon(Icons.keyboard_arrow_down_outlined),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    items: deliveryPreferencesState.preferVehicleData
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.typeStateName),
                          ),
                        )
                        .toList(),
                    hint: "Select Vechile Data",
                    onChanged: (value) async {
                      preferVehicleData = value;
                      if (preferVehicleData != null) {
                        await context
                            .read<DeliveryPreferencesCubit>()
                            .selectedDataVechile(
                              ctiyName: preferVehicleData!.typeStateName,
                            );
                      }
                    },
                    // validator: (value) {
                    //   if (value == null) {
                    //     return "Field can't be empty";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<DeliveryPreferencesCubit,
                      DeliveryPreferencesState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000000),
                          ),
                          onPressed: () {
                            if (preferVehicleData != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileImageScreen(),
                                  ));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please Select Vechile Type");
                            }
                          },
                          child:
                              const CommonProximaNovaTextWidget(text: 'Submit'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const GirdShimmierWidget();
          }
        }
      },
    );
  }
}
