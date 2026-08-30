import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/commons/ConvertText.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/basic_information.dart/screens/enter_mobile_number_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/login/logic/cubit/rider_type_selected_data_cubit.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/login/repository/driver_type_repository.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../utility/internet_handler/logic/internet/internet_cubit.dart';
import '../../../utility/internet_handler/screen/no_internet_screen.dart';

class SelectRiderTypeScreen extends StatefulWidget {
  const SelectRiderTypeScreen({super.key});

  @override
  State<SelectRiderTypeScreen> createState() => _SelectRiderTypeScreenState();
}

class _SelectRiderTypeScreenState extends State<SelectRiderTypeScreen> {
  int selectedIndex = 0; // Added to track the selected
  late String selectedType = 'Bike Rider';
  late String selectedId = '1';

  late RiderTypeSelectedDataCubit riderTypeSelectedDataCubit;

  @override
  void initState() {
    super.initState();
    riderTypeSelectedDataCubit =
        RiderTypeSelectedDataCubit(RiderTypeRepository());
    riderTypeSelectedDataCubit.featchRiderTypes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, internetState) {
        if (internetState.connected) {
          return BlocProvider.value(
            value: riderTypeSelectedDataCubit,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                    child: Center(
                        child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorsData.themeColor,
                      size: 15,
                    )),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Register Now!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'ProximaNova',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Select What Type of Delivery You\n are Interested!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'ProximaNova',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<RiderTypeSelectedDataCubit,
                        RiderTypeSelectedDataState>(
                      builder: (context, state) {
                        if (state.dataLoading) {
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: const Color(0xffF8F8FF),
                                highlightColor: const Color(0xcae7e7ee),
                                child: Container(
                                  height: 70,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey
                                        .shade200, // Highlight selected item
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state.error != null) {
                          return CommonProximaNovaTextWidget(
                              text: state.error!);
                        } else {
                          if (state.riderTypeResponseModel != null) {
                            final typedata = state.riderTypeResponseModel!.data;
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: typedata.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex =
                                          index; // Update the selected index
                                      selectedType = typedata[index].title;
                                      selectedId = typedata[index].id;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: index == selectedIndex
                                              ? Colors.black
                                              : Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(8),
                                      color: index == selectedIndex
                                          ? Colors.grey.shade200
                                          : Colors
                                              .white, // Highlight selected item
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          typedata[index].image,
                                          height: 60,
                                          width: 50,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              CommonProximaNovaTextWidget(
                                                text: typedata[index]
                                                    .title
                                                    .toString(),
                                                color: ColorsData.themeColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              CommonProximaNovaTextWidget(
                                                text: typedata[index]
                                                    .description
                                                    .toString(),
                                                color: ColorsData.themeColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 18,
                                          width: 18,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: index == selectedIndex
                                                ? Colors.black
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: index == selectedIndex
                                                    ? Colors.black
                                                    : Colors.grey.shade400),
                                          ),
                                          child: index == selectedIndex
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 14,
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade300,
                                  child: Container(
                                    height: 70,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey
                                          .shade200, // Highlight selected item
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsData.themeColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnterMobileNumberScreen(
                                  selectedType: selectedType,
                                  selectedTypeId: selectedId,
                                ),
                              ));
                        },
                        child: Text(
                          ConvertText.getTitle("Next"),
                          style: GoogleFonts.manrope(
                            letterSpacing: 0.8,
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (internetState.disconnected) {
          return const NoInternetScreen();
        }
        return const Center(child: ThemeSpinner());
      },
    );
  }
}
