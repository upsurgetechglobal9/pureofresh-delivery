import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../logic/bloc/profile_details_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileDetailsBloc>().add(ProfileDetailsFetchingEvent(
        accessToken: (Constants.prefs!.getString("token"))!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          ConvertText.getTitle("Profile"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            if (state is ProfileDetailsLoadedState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.profileDetailsModeldata.deliveryPersonDetails
                          .profilePhoto ==
                      '')
                    InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             const UpdatePersonalDetails(),
                      //       ));
                      // },
                      child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: ColorsData.themeColor,
                          )),
                    )
                  else
                    InkWell(
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             const UpdatePersonalDetails(),
                      //       ));
                      // },
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(state.profileDetailsModeldata
                              .deliveryPersonDetails.profilePhoto),
                          // height: 40,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ConvertText.getTitle("Rider Details"),
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${state.profileDetailsModeldata.deliveryPersonDetails.personName} - ${state.profileDetailsModeldata.deliveryPersonDetails.accessToken}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  "${ConvertText.getTitle("Zone")}:  ${state.profileDetailsModeldata.deliveryPersonDetails.locationName}",
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  "${ConvertText.getTitle("City")}: ${state.profileDetailsModeldata.deliveryPersonDetails.cityName}",
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  "${ConvertText.getTitle("Delivery Type")}: ${state.profileDetailsModeldata.deliveryPersonDetails.deliveryType}",
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          ConvertText.getTitle("Personal Details"),
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Full Name"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state.profileDetailsModeldata
                                          .deliveryPersonDetails.personName,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Age"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state.profileDetailsModeldata
                                          .deliveryPersonDetails.age,
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Gender"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state.profileDetailsModeldata
                                          .deliveryPersonDetails.gender,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Phone Number"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state.profileDetailsModeldata
                                          .deliveryPersonDetails.mobileNumber,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Mail ID"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state.profileDetailsModeldata
                                          .deliveryPersonDetails.email,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Row(
                                //       children: [
                                //         Text(
                                //           "Preferred Language",
                                //           style: GoogleFonts.manrope(
                                //             fontSize: 12,
                                //             color: Colors.grey,
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           width: 4,
                                //         ),
                                //         Text(
                                //           "EDIT",
                                //           style: GoogleFonts.manrope(
                                //             fontSize: 12,
                                //             color: ColorsData.themeColor,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //     Text(
                                //       "${state.profileDetailsModeldata.deliveryPersonDetails.languagesKnown}",
                                //       style: GoogleFonts.manrope(
                                //         fontSize: 12,
                                //         color: Colors.grey,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          ConvertText.getTitle(
                                              "Languages Known"),
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 4,
                                        // ),
                                        // Text(
                                        //   "EDIT",
                                        //   style: GoogleFonts.manrope(
                                        //     fontSize: 12,
                                        //     color: ColorsData.themeColor,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Text(
                                      state.profileDetailsModeldata
                                          .deliveryPersonDetails.languagesKnown,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          ConvertText.getTitle("Additional Details"),
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Vehicle Name"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state.profileDetailsModeldata
                                          .deliveryPersonDetails.vehicleName,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Vehicle Number"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state.profileDetailsModeldata
                                          .deliveryPersonDetails.vehicleNumber,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Driving License"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state
                                          .profileDetailsModeldata
                                          .deliveryPersonDetails
                                          .drivingLicenseNumber,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Validity"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state
                                          .profileDetailsModeldata
                                          .deliveryPersonDetails
                                          .vehicleValidity,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ConvertText.getTitle("Aadhaar Number"),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      state
                                          .profileDetailsModeldata
                                          .deliveryPersonDetails
                                          .aadharCardNumber,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
