import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/logic/cubit/delivery_preferences_cubit.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/registration/upload_profile_pic/screens/upload_profile_image_screen.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import 'delivery_prefer_dropdown_screen.dart';
import 'delivery_prefer_type_screen.dart';

class DeliveryPreferencesScreen extends StatefulWidget {
  final bool isFromProfile;
  const DeliveryPreferencesScreen({super.key, required this.isFromProfile});

  @override
  State<DeliveryPreferencesScreen> createState() =>
      _DeliveryPreferencesScreenState();
}

class _DeliveryPreferencesScreenState extends State<DeliveryPreferencesScreen> {
  @override
  void initState() {
    context.read<DeliveryPreferencesCubit>().featchDeliveryType();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryPreferencesCubit, DeliveryPreferencesState>(
      builder: (context, state) {
        return PopScope(
          canPop: state.statusUpdateLoading == true ? false : true,
          child:
              BlocConsumer<DeliveryPreferencesCubit, DeliveryPreferencesState>(
            listener: (context, state) {
              if (state.statusUpdated) {
                if (widget.isFromProfile == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileImageScreen(),
                      ));
                } else {
                  Navigator.pop(context);
                }
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  // backgroundColor: Colors.transparent,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  titleSpacing: 4,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // leading: null,
                  title: CommonProximaNovaTextWidget(
                    text: "Select Delivery Preferences",
                    fontSize: 14,
                    color: ColorsData.themeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                body: BlocBuilder<DeliveryPreferencesCubit,
                    DeliveryPreferencesState>(
                  builder: (context, deliveryPreferencesState) {
                    if (deliveryPreferencesState.typeLoad) {
                      return const ThemeSpinner(
                        size: 50,
                      );
                    } else {
                      if (deliveryPreferencesState.typeId != null) {
                        if (deliveryPreferencesState.typeId == '1') {
                          return DeliveryPreferTypeOneScreen(
                              isFromProfile: widget.isFromProfile);
                        } else if (deliveryPreferencesState.typeId == '2') {
                          return DeliveryPrefDropDownScreen(
                              typeId:
                                  deliveryPreferencesState.typeId.toString());
                        } else {
                          return DeliveryPrefDropDownScreen(
                              typeId:
                                  deliveryPreferencesState.typeId.toString());
                        }
                      } else {
                        return const ThemeSpinner();
                      }
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
