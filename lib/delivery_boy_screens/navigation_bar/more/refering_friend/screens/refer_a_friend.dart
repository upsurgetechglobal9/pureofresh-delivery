import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/text_form_field.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../../../../../utility/colors_data.dart';
import '../../../navigationbar_screen.dart';
import '../logic/bloc/referrals_data_bloc.dart';
import '../logic_for_friend/bloc/friend_refer_bloc_bloc.dart';

class ReferAFriend extends StatefulWidget {
  const ReferAFriend({super.key});

  @override
  State<ReferAFriend> createState() => _ReferAFriendState();
}

class _ReferAFriendState extends State<ReferAFriend> {
  final referKey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  String? selectedValue;
  String? selectedTimeValue;

  @override
  void initState() {
    super.initState();
    context.read<FriendReferBlocBloc>().add(ReferralBannerTextFetching());
  }

  @override
  Widget build(BuildContext context) {
    // context.read<ReferralsDataBloc>().add(ReferralBannerTextFetching());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          ConvertText.getTitle("Refer a Friend"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
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
      ),
      body: BlocConsumer<FriendReferBlocBloc, FriendReferBlocState>(
        listener: (context, state) {
          if (state is ReferAFriendLoadedState) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomsNaviScreen(index: 3),
                  // builder: (context) => BottomsNaviScreen(index: 3),
                ));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: referKey,
                child: Column(
                  children: [
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BlocBuilder<FriendReferBlocBloc,
                                      FriendReferBlocState>(
                                    builder: (context, state) {
                                      if (state
                                          is ReferralsBaneereLoadedState) {
                                        return Text(
                                          state.bannerText,
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        );
                                      }
                                      return Shimmer.fromColors(
                                          baseColor: const Color.fromARGB(
                                              95, 224, 224, 224),
                                          highlightColor: Colors.white,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    121, 255, 255, 255),
                                                borderRadius:
                                                    BorderRadius.circular(24)),
                                            height: 30,
                                            width: 80,
                                          ));
                                    },
                                  ),
                                  Text(
                                    ConvertText.getTitle("T & C apply*"),
                                    style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 7,
                                        height: 3),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, right: 5),
                            child: Image.asset(
                              "assets/images/Refer and Earn.png",
                              height: 60,
                            ),
                          )
                        ],
                      ),
                    ),
                    DeliveryBoyTextFormField(
                        controller: numberController,
                        hint: ConvertText.getTitle("Mobile Number"),
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w400,
                        ),
                        isDense: true,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                          LengthLimitingTextInputFormatter(10)
                        ],
                        validator: (text) {
                          if (text!.isEmpty) {
                            return ConvertText.getTitle(
                                "Please enter Mobile Number");
                          }
                          return null;
                        }),
                    DeliveryBoyTextFormField(
                        hint: ConvertText.getTitle("Name"),
                        controller: nameController,
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w400,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
                        validator: (text) {
                          if (text!.isEmpty) {
                            return ConvertText.getTitle("Please enter Name");
                          }
                          return null;
                        }),
                    DeliveryBoyTextFormField(
                      controller: ageController,
                      hint: ConvertText.getTitle("Age"),
                      hintStyle: GoogleFonts.manrope(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                      ),
                      validator: (text) {
                        if (text!.isEmpty) {
                          return ConvertText.getTitle("Please enter Age");
                        }
                        return null;
                      },
                      isDense: true,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                        LengthLimitingTextInputFormatter(2)
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      hint: Text(
                        ConvertText.getTitle("Vehicle Type"),
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey.shade400),
                      ),
                      isDense: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 28,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        isDense: true,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Motorbike',
                          child: Text(
                            'Motorbike',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Electric Bike',
                          child: Text(
                            'Electric Bike',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (droppedItemValue) {
                        print(droppedItemValue);

                        setState(() {
                          selectedValue = droppedItemValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'field required' : null,
                    ),
                    DeliveryBoyTextFormField(
                        controller: cityController,
                        hint: ConvertText.getTitle("City"),
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w400,
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter valid details";
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 13,
                    ),
                    DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      hint: CommonProximaNovaTextWidget(
                        text: 'Work Time',
                        color: Colors.grey.shade400,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      isDense: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 28,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        isDense: true,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Part Time',
                          child: CommonProximaNovaTextWidget(
                            text: 'Part Time',
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Full Time',
                          child: CommonProximaNovaTextWidget(
                            text: 'Full Time',
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                      onChanged: (droppedItemValue) {
                        setState(() {
                          selectedTimeValue = droppedItemValue;
                        });
                        print(selectedTimeValue);
                      },
                      validator: (value) =>
                          value == null ? 'field required' : null,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 0),
                        child:
                            BlocBuilder<ReferralsDataBloc, ReferralsDataState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsData.themeColor,
                              ),
                              onPressed: () {
                                final FormState? form = referKey.currentState;
                                if (form!.validate()) {
                                  print("form valid");
                                  context
                                      .read<FriendReferBlocBloc>()
                                      .add(AddReferAFriendEvent(
                                        accessToken: (Constants.prefs!
                                            .getString("token"))!,
                                        mobileNumber:
                                            numberController.text.toString(),
                                        name: nameController.text.toString(),
                                        age: ageController.text.toString(),
                                        vehicleType: selectedValue.toString(),
                                        city: cityController.text.toString(),
                                        workTime: selectedTimeValue.toString(),
                                      ));
                                } else {
                                  print("form invalid");
                                }
                              },
                              child: const CommonProximaNovaTextWidget(
                                text: 'REFER NOW',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              // child: Text(
                              //   ConvertText.getTitle(""),
                              //   style: GoogleFonts.manrope(
                              //     // letterSpacing: 0.6,
                              //     color: Colors.white,
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
