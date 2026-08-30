import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

import '../../../../../utility/common_text.dart';
import '../../../../registration/upload_profile_pic/screens/upload_profile_image_screen.dart';
import '../logic/cubit/delivery_preferences_cubit.dart';
import '../widgets/grid_shimmer.dart';

class DeliveryPreferTypeOneScreen extends StatefulWidget {
  final bool isFromProfile;
  const DeliveryPreferTypeOneScreen({super.key, required this.isFromProfile});

  @override
  State<DeliveryPreferTypeOneScreen> createState() =>
      _DeliveryPreferTypeOneScreenState();
}

class _DeliveryPreferTypeOneScreenState
    extends State<DeliveryPreferTypeOneScreen> {
  @override
  void initState() {
    context.read<DeliveryPreferencesCubit>().featchDeliveryPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryPreferencesCubit, DeliveryPreferencesState>(
      builder: (context, deliveryPreferencesState) {
        if (deliveryPreferencesState.dataLoading) {
          return const GirdShimmierWidget();
        } else if (deliveryPreferencesState.error != null) {
          return CommonProximaNovaTextWidget(
              text: deliveryPreferencesState.error!);
        } else {
          if (deliveryPreferencesState.deliveryPreferencesResponseModel !=
              null) {
            final deliveryPreferences =
                deliveryPreferencesState.deliveryPreferencesResponseModel!.data;
            return deliveryPreferences.isEmpty
                ? Center(
                    child: Text(
                        'For your profile preferences not availble please contunue${deliveryPreferencesState.typeId}'),
                  )
                : BlocConsumer<DeliveryPreferencesCubit,
                    DeliveryPreferencesState>(listener: (context, state) {
                    if (state.statusUpdated) {
                      if (widget.isFromProfile == true) {
                        print('Profile');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileImageScreen(),
                            ));
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  }, builder: (context, state) {
                    return Scaffold(
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerDocked,
                      floatingActionButton: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF000000),
                            ),
                            onPressed: () {
                              print('OOOOOO)))))');
                              state.statusUpdateLoading == true
                                  ? null
                                  : context
                                      .read<DeliveryPreferencesCubit>()
                                      .updateApi();
                            },
                            child: CommonProximaNovaTextWidget(
                                text: state.statusUpdateLoading == true
                                    ? 'Wait..'
                                    : 'Submit'),
                          ),
                        ),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                            child: StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: List.generate(
                            deliveryPreferences.length,
                            (index) {
                              if (index == 2) {
                                // For the third item, set crossAxisCellCount to 4
                                return StaggeredGridTile.count(
                                  crossAxisCellCount: 4,
                                  mainAxisCellCount: 2,
                                  child: Container(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 150,
                                                  child:
                                                      CommonProximaNovaTextWidget(
                                                    text: deliveryPreferences[
                                                            index]
                                                        .title,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        ColorsData.themeColor,
                                                    maxLines: 4,
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Transform.scale(
                                                  scale: 0.7,
                                                  child: CupertinoSwitch(
                                                    trackColor: Colors
                                                        .red, // **INACTIVE STATE COLOR**
                                                    activeColor: Colors
                                                        .green, // **ACTIVE STATE COLOR**
                                                    value: deliveryPreferences[
                                                            index]
                                                        .status!,
                                                    onChanged: (bool value) {
                                                      context
                                                          .read<
                                                              DeliveryPreferencesCubit>()
                                                          .toggleStatus(
                                                              index,
                                                              deliveryPreferences[
                                                                      index]
                                                                  .id);
                                                    },
                                                  ),
                                                ),
                                                //  Switch.adaptive(
                                                //    // Don't use the ambient CupertinoThemeData to style this switch.
                                                //                                         applyCupertinoTheme: true,
                                                //    value: deliveryPreferences[index].status!,
                                                //     activeTrackColor: Colors.green,
                                                //    inactiveTrackColor: Colors.red,
                                                //    activeColor: Colors
                                                //        .white, // Color of the inside circle when switch is ON
                                                //    inactiveThumbColor: Colors
                                                //        .white, // Color of the inside circle when switch is OFF
                                                //    // overlayColor:
                                                //    //     const MaterialStatePropertyAll<Color>(
                                                //    //   Colors.red,
                                                //    // ),
                                                //    // trackColor:
                                                //    //     const MaterialStatePropertyAll<Color>(
                                                //    //   Colors.yellow,
                                                //    // ),
                                                //    // thumbColor:
                                                //    //     const MaterialStatePropertyAll<Color>(
                                                //    //   Colors.black,
                                                //    // ),
                                                //    onChanged: (bool value) {
                                                //                            context.read<DeliveryPreferencesCubit>().toggleStatus(index,
                                                //              deliveryPreferences[index]
                                                //                  .id);
                                                //      // setState(() {
                                                //      //   preference.status = value;
                                                //      // });
                                                //    },
                                                //  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 90,
                                            width: 90,
                                            child: Image.network(
                                              deliveryPreferences[index].image,
                                              // Ensure the image is visible
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // For other items, set crossAxisCellCount to 2
                                return StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: 2,
                                  child: Container(
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                height: 50,
                                                child:
                                                    CommonProximaNovaTextWidget(
                                                  text:
                                                      deliveryPreferences[index]
                                                          .title,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorsData.themeColor,
                                                  maxLines: 4,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),

                                              Transform.scale(
                                                scale: 0.7,
                                                child: CupertinoSwitch(
                                                  trackColor: Colors
                                                      .red, // **INACTIVE STATE COLOR**
                                                  activeColor: Colors
                                                      .green, // **ACTIVE STATE COLOR**
                                                  value:
                                                      deliveryPreferences[index]
                                                          .status!,
                                                  onChanged: (bool value) {
                                                    context
                                                        .read<
                                                            DeliveryPreferencesCubit>()
                                                        .toggleStatus(
                                                            index,
                                                            deliveryPreferences[
                                                                    index]
                                                                .id);
                                                  },
                                                ),
                                              ),
                                              // Switch.adaptive(
                                              //   // Don't use the ambient CupertinoThemeData to style this switch.
                                              //   applyCupertinoTheme: false,
                                              //   value: deliveryPreferences[index].status!,
                                              //   activeTrackColor: Colors.green,
                                              //   inactiveTrackColor: Colors.red,
                                              //   activeColor: Colors
                                              //       .white, // Color of the inside circle when switch is ON
                                              //   inactiveThumbColor: Colors
                                              //       .white, // Color of the inside circle when switch is OFF
                                              //   // overlayColor:
                                              //   //     const MaterialStatePropertyAll<Color>(
                                              //   //   Colors.red,
                                              //   // ),
                                              //   // trackColor:
                                              //   //     const MaterialStatePropertyAll<Color>(
                                              //   //   Colors.yellow,
                                              //   // ),
                                              //   // thumbColor:
                                              //   //     const MaterialStatePropertyAll<Color>(
                                              //   //   Colors.black,
                                              //   // ),
                                              //   onChanged: (bool value) {
                                              //   context
                                              //         .read<
                                              //             DeliveryPreferencesCubit>()
                                              //         .toggleStatus(index,
                                              //             deliveryPreferences[index]
                                              //                 .id);
                                              //   },
                                              // ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Image.network(
                                                deliveryPreferences[index]
                                                    .image,
                                                width: 100,
                                                height: index == 0
                                                    ? 47
                                                    : 55, // specify the desired height
                                                fit: BoxFit
                                                    .fill // specify the desired width
                                                // Ensure the image is visible
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        )),
                      ),
                    );
                  });
          } else {
            return const GirdShimmierWidget();
          }
        }
      },
    );
  }
}
