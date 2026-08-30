// import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '../../../../../../commons/ConvertText.dart';
import '../../../../../../utility/colors_data.dart';
import '../../../../navigationbar_screen.dart';
import '../../screens/attendence_sheet_screen.dart';
import '../logic/bloc/check_in_out_bloc.dart';

class CheckInCheckOutScreen extends StatefulWidget {
  final String type;
  const CheckInCheckOutScreen({super.key, required this.type});

  @override
  State<CheckInCheckOutScreen> createState() => _CheckInCheckOutScreenState();
}

class _CheckInCheckOutScreenState extends State<CheckInCheckOutScreen> {
  String wearTshirt = "0";
  String wearHelmet = "0";
  String wearMask = "0";

  File? checkImage;
  ImagePicker picker = ImagePicker();

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 30,
      maxHeight: 1200,
      maxWidth: 1200,
      preferredCameraDevice: CameraDevice.front,
    );
    File fileimgage = File(pickedFile!.path);

    // iMAGE CROPING-- if needed

    setState(() {
      checkImage = fileimgage;
    });
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
          widget.type,
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            checkImage == null
                ? Column(
                    children: [
                      const CircleAvatar(
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            size: 50,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ConvertText.getTitle("Add your Selfie"),
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${ConvertText.getTitle('to Complete your')} ${widget.type}!",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7ec245),
                        ),
                        onPressed: () {
                          print(Constants.prefs!.getString("token"));
                          _pickingImage(context);
                          // getImage(ImageSource.camera);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 12),
                          child: Text(
                            ConvertText.getTitle("Upload"),
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(1000),
                      //   child: Container(
                      //       height: 150,
                      //       width: 150,
                      //       decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.red, width: 5),
                      //         shape: BoxShape.circle,
                      //       ),
                      //       child: checkImage == null
                      //           ? const Icon(
                      //               Icons.person,
                      //               size: 28,
                      //             )
                      //           : Image.file(
                      //               checkImage!,
                      //               height: 150,
                      //               fit: BoxFit.cover,
                      //             )),
                      // ),
                      checkImage == null
                          ? const CircleAvatar(
                              radius: 70,
                              child: Icon(
                                Icons.person,
                                size: 28,
                              ),
                            )
                          : CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  FileImage(checkImage!, scale: 0.2),
                            ),
                      // child: checkImage == null
                      //     ? const Icon(
                      //         Icons.person,
                      //         size: 28,
                      //       )
                      //     : Image.file(
                      //         checkImage!,
                      //         height: 150,
                      //         fit: BoxFit.cover,
                      //       )
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ConvertText.getTitle("Your Selfie has been uploaded"),
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ConvertText.getTitle("Successfully!"),
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4285f4),
                            ),
                            onPressed: () {
                              _pickingImage(context);
                              // getImage(ImageSource.camera);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 12),
                              child: Text(
                                ConvertText.getTitle("RETAKE"),
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7ec245),
                            ),
                            onPressed: () {
                              rulesNregulations();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 12),
                              child: Text(
                                ConvertText.getTitle("UPLOAD"),
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  void rulesNregulations() {
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // height: 260,
          child: BlocConsumer<CheckInOutBloc, CheckInOutState>(
            listener: (context, state) {
              if (state is CheckInDetailsSuccessState) {
                if (widget.type == 'Check In ') {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BottomsNaviScreen(index: 0)),
                      (route) => false);
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendenceSheetScreen(),
                      ));
                }
              }
              if (state is CheckoutDetailsSuccessState) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendenceSheetScreen(),
                    ));
              }
              // TODO: implement listener
            },
            builder: (context, state) {
              return AnimatedPadding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                duration: const Duration(milliseconds: 150),
                child: Container(
                  constraints:
                      const BoxConstraints(maxHeight: 900, minHeight: 150),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ConvertText.getTitle("Rules and Regulations"),
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  color: ColorsData.themeColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ConvertText.getTitle(
                                    "Did You Follow Below Rules"),
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ConvertText.getTitle("Did you wear Helmet"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GFToggle(
                                    disabledTrackColor: Colors.red,
                                    onChanged: (val) {
                                      if (val == true) {
                                        setState(() {
                                          wearHelmet = '1';
                                        });
                                      } else {
                                        setState(() {
                                          wearHelmet = '0';
                                        });
                                      }
                                    },
                                    value: false,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ConvertText.getTitle(
                                        "Did you wear Flymengo T-shirt"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GFToggle(
                                    disabledTrackColor: Colors.red,
                                    onChanged: (val) {
                                      if (val == true) {
                                        setState(() {
                                          wearTshirt = '1';
                                        });
                                      } else {
                                        setState(() {
                                          wearTshirt = '0';
                                        });
                                      }
                                    },
                                    value: false,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ConvertText.getTitle("Did you wear Mask"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GFToggle(
                                    disabledTrackColor: Colors.red,
                                    onChanged: (val) {
                                      if (val == true) {
                                        setState(() {
                                          wearMask = '1';
                                        });
                                      } else {
                                        setState(() {
                                          wearMask = '0';
                                        });
                                      }
                                    },
                                    value: false,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7ec245),
                                  ),
                                  onPressed: () {
                                    if (widget.type == 'Check In ') {
                                      context.read<CheckInOutBloc>().add(
                                          CheckInDetailsSendingEvent(
                                              checkinWearHelmet: wearHelmet,
                                              checkinWearTshirt: wearTshirt,
                                              checkinWearMask: wearMask,
                                              checkInImage: checkImage!));
                                    }
                                    if (widget.type == 'Check In') {
                                      context.read<CheckInOutBloc>().add(
                                          CheckInDetailsSendingEvent(
                                              checkinWearHelmet: wearHelmet,
                                              checkinWearTshirt: wearTshirt,
                                              checkinWearMask: wearMask,
                                              checkInImage: checkImage!));
                                    }
                                    if (widget.type == 'Check Out') {
                                      context.read<CheckInOutBloc>().add(
                                          CheckOutDetailsSendingEvent(
                                              checkoutWearHelmet: wearHelmet,
                                              checkoutWearTshirt: wearTshirt,
                                              checkoutWearMask: wearMask,
                                              checkoutImage: checkImage!));
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 12),
                                    child: Text(
                                      ConvertText.getTitle("SUBMIT"),
                                      style: GoogleFonts.manrope(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }

  Future<void> _pickingImage(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            ConvertText.getTitle("Choose Pic From"),
            style: GoogleFonts.manrope(),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);

                  await getImage(ImageSource.camera);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 25,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: ColorsData.themeColor,
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        )),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      ConvertText.getTitle("Camera"),
                      style: GoogleFonts.manrope(),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);

                  await getImage(ImageSource.gallery);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 25,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: ColorsData.themeColor,
                        child: const Icon(
                          Icons.photo_library_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      ConvertText.getTitle("Gallery"),
                      style: GoogleFonts.manrope(),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
