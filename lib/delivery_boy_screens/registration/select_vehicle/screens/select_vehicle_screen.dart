import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../commons/show_chuk_notification.dart';
import '../../../../commons/url_links.dart';
import '../../../../utility/colors_data.dart';
import '../../../../utility/text_form_field.dart';
import '../../../login/screens/welcome_screen.dart';
import '../../select_city/screens/select_city_screen.dart';
import '../logic/bloc/vehicle_information_bloc.dart';
import '../repository/select_vehicle_repository.dart';

class SelectVehicleScreen extends StatefulWidget {
  final String? type;
  const SelectVehicleScreen({super.key, this.type});

  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  final vehicleDetailsKey = GlobalKey<FormState>();
  TextEditingController bikeNameController = TextEditingController();
  TextEditingController bikeNumberController = TextEditingController();
  TextEditingController bikeValidityController = TextEditingController();
  TextEditingController drivingController = TextEditingController();
  TextEditingController fromController = TextEditingController();

  String selectedbikeType = "Motor Bike";

  String? uploadBikeImagepic;
  String? uploadBikeImagepic2;
  String? rcOne;
  String? rcTwo;

  String? uploadLicenseImagepic;
  String? uploadLicenseImagepicTwo;

  File? bikeImage;
  File? bikeImage2;
  File? rc1;
  File? rc2;

  String? bikeImages;
  File? licenseImage;
  File? licenseImageTwo;
  ImagePicker picker = ImagePicker();

  String fromDate = '';

  Future<File?> getImagfe(ImageSource source, String imageType) async {
    print("selcetd method for image");
    final pickedFile = await picker.pickImage(
      source: source,
      maxHeight: 1200,
      maxWidth: 1200,
      imageQuality: 30,
    );
    File fileimgage = File(pickedFile!.path);
    // if (pickedFile == null)
    // iMAGE CROPING-- if needed
    if (imageType == "bike") {
      setState(() {
        bikeImage = fileimgage;
      });

      return bikeImage;
    }
    if (imageType == "bike2") {
      setState(() {
        bikeImage2 = fileimgage;
      });

      return bikeImage;
    }
    if (imageType == "rc1") {
      setState(() {
        rc1 = fileimgage;
      });

      return bikeImage;
    }
    if (imageType == "rc2") {
      setState(() {
        rc2 = fileimgage;
      });

      return bikeImage;
    }
    if (imageType == "license") {
      setState(() {
        licenseImage = fileimgage;
      });

      return licenseImage;
    }
    return null;
  }

  Future<File?> pickDocument(ImageSource source, String imageType) async {
    // try {
    // if (await Permission.storage.isGranted) {
    final pickedRawDoc = await picker.pickImage(
      source: source,
      imageQuality: 30,
      maxHeight: 1200,
      maxWidth: 1200,
    );
    //  await FilePicker.platform.pickFiles(
    //     type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);
    if (pickedRawDoc == null) {
      return null;
    } else {
      //Handle the file
      return File(pickedRawDoc.path);
    }
    // } else {
    //   await Permission.storage.request();
    // }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(e.toString()),
    //     ),
    //   );
    //   return null;
    // }
  }

  Future<void> getImage(ImageSource source, String imageType) async {
    final pickedDocument = await pickDocument(
      source,
      imageType,
    );
    if (pickedDocument == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No file selected")));
    } else {
      // print(pickedDocument);
      final fileName = pickedDocument.path.split('/').last;
      // print("FILNAME");
      // print(fileName);
      final data = dio.FormData.fromMap({
        "access_token": Constants.prefs!.getString("token"),
        "image": await dio.MultipartFile.fromFile(
          pickedDocument.path,
          filename: fileName,
        )
      });
      // print("Saleem bhai--- $data");
      final dioInstance = dio.Dio();
      addChuck(dioInstance);
      var request = await dioInstance.post(
        UrlLinksData.serverUrl + UrlLinksData.imageUploadService,
        data: data,
      );
      if (request.data['err_code'] == "invalid") {
        Fluttertoast.showToast(msg: request.data['message']);
      }
      if (request.data['err_code'] == "valid") {
        if (mounted) {
          setState(() {
            // attachpic = request.data['data']['uploaded_pic_path'];
            if (imageType == "bike") {
              setState(() {
                bikeImage = pickedDocument;
                uploadBikeImagepic = request.data['data'];
              });
            }
            if (imageType == "bike2") {
              setState(() {
                bikeImage2 = pickedDocument;
                uploadBikeImagepic2 = request.data['data'];
              });
            }
            if (imageType == "rc1") {
              setState(() {
                rc1 = pickedDocument;
                rcOne = request.data['data'];
              });
            }
            if (imageType == "rc2") {
              setState(() {
                rc2 = pickedDocument;
                rcTwo = request.data['data'];
              });
            }
            if (imageType == "license") {
              setState(() {
                licenseImage = pickedDocument;
                uploadLicenseImagepic = request.data['data'];
              });
            }
            if (imageType == "licenseTwo") {
              setState(() {
                licenseImageTwo = pickedDocument;
                uploadLicenseImagepicTwo = request.data['data'];
              });
            }
          });
        }
        // _textController.text = '';
        // await _taskChatController.postChatData(
        //     widget.taskId, texte!, attachpic!);
        // texte = "";
        // attachpic = '';
      }
    }
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
            if (widget.type == 'pending') {
              Constants.prefs!.setString("token", '');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ));
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          ConvertText.getTitle("Select Vehicle"),
          style: GoogleFonts.manrope(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocProvider(
        create: (context) => VehicleInformationBloc(
            selectVehicleRepository: SelectVehicleRepository()),
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: vehicleDetailsKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     SizedBox(
                    //       width: MediaQuery.of(context).size.width * 0.46,
                    //       child: RadioListTile(
                    //         shape: RoundedRectangleBorder(
                    //             side: BorderSide(
                    //                 color: selectedbikeType == "Motor Bike"
                    //                     ? Colors.black
                    //                     : Colors.grey),
                    //             borderRadius: BorderRadius.circular(8)),
                    //         dense: true,
                    //         activeColor: Colors.black,
                    //         controlAffinity: ListTileControlAffinity.trailing,
                    //         contentPadding: const EdgeInsets.only(left: 8),
                    //         toggleable: true,
                    //         title: Text(
                    //           'Motor Bike',
                    //           style: GoogleFonts.manrope(
                    //               color: selectedbikeType == "Motor Bike"
                    //                   ? Colors.black
                    //                   : Colors.grey),
                    //         ),
                    //         value: "Motor Bike",
                    //         groupValue: selectedbikeType,
                    //         onChanged: (v) {
                    //           setState(() {
                    //             selectedbikeType = v.toString();
                    //           });
                    //           print(selectedbikeType);
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: MediaQuery.of(context).size.width * 0.47,
                    //       child: RadioListTile(
                    //         shape: RoundedRectangleBorder(
                    //             side: BorderSide(
                    //                 color: selectedbikeType == 'Electric Bike'
                    //                     ? Colors.black
                    //                     : Colors.grey),
                    //             borderRadius: BorderRadius.circular(8)),
                    //         dense: true,
                    //         contentPadding: const EdgeInsets.only(left: 8),
                    //         activeColor: Colors.black,
                    //         controlAffinity: ListTileControlAffinity.trailing,
                    //         toggleable: true,
                    //         title: Text(
                    //           'Electric Bike',
                    //           style: GoogleFonts.manrope(
                    //               color: selectedbikeType == 'Electric Bike'
                    //                   ? Colors.black
                    //                   : Colors.grey),
                    //         ),
                    //         value: "Electric Bike",
                    //         groupValue: selectedbikeType,
                    //         onChanged: (v) {
                    //           setState(() {
                    //             selectedbikeType = v.toString();
                    //           });
                    //           print(selectedbikeType);
                    //         },
                    //       ),
                    //     )
                    //   ],
                    // ),

                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      ConvertText.getTitle("Vehicle Details"),
                    ),
                    DeliveryBoyTextFormField(
                        controller: bikeNameController,
                        isDense: true,
                        hint: ConvertText.getTitle("Enter Vehicle Name"),
                        hintStyle: GoogleFonts.manrope(
                            color: Colors.grey, fontSize: 12),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9a-zA-Z\s]')),
                          FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                        ],
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter vehicle name";
                          }
                          return null;
                        }),
                    DeliveryBoyTextFormField(
                        controller: bikeNumberController,
                        isDense: true,
                        hint: ConvertText.getTitle("Enter Vehicle Number"),
                        hintStyle: GoogleFonts.manrope(
                            color: Colors.grey, fontSize: 12),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9a-zA-Z\s]')),
                          FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                          FilteringTextInputFormatter.deny(RegExp('^0+')),
                          FilteringTextInputFormatter.deny(RegExp(r' ')),
                          LengthLimitingTextInputFormatter(10)
                        ],
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter vehicle number";
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 14,
                    ),
                    TextFormField(
                      controller: bikeValidityController,
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 8),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8)),
                        hintText: "Enter Vehicle Validity",
                        hintStyle: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        )),
                        suffixIcon: Icon(
                          Icons.calendar_month_rounded,
                          size: 20,
                          color: ColorsData.themeColor,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        ).then(
                          (value) => value != null
                              ? fromDate =
                                  DateFormat('dd-MM-yyyy').format(value)
                              : null,
                        );
                        print("object fdf $fromDate");
                        bikeValidityController.text = fromDate;
                      },
                      onChanged: (val) {
                        setState(() {
                          // selectedToDate = val;
                          fromDate = val;
                        });
                        print("object $fromDate");
                      },
                      onSaved: (val) => print(val),
                    ),
                    // DeliveryBoyTextFormField(
                    //   controller: bikeValidityController,
                    //   isDense: true,
                    //   hint: ConvertText.getTitle("Enter Bike validity"),
                    //   hintStyle:
                    //       GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                    //   inputFormatters: [
                    //     FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
                    //     FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                    //   ],
                    //   validator: (text) {
                    //     if (text!.isEmpty) {
                    //       return " valid details";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    DeliveryBoyTextFormField(
                        controller: drivingController,
                        isDense: true,
                        hint: ConvertText.getTitle(
                            "Enter Driving License Number"),
                        hintStyle: GoogleFonts.manrope(
                            color: Colors.grey, fontSize: 12),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9a-zA-Z\s]')),
                          FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                          FilteringTextInputFormatter.deny(RegExp(r' ')),
                          FilteringTextInputFormatter.deny(RegExp('^0+')),
                          LengthLimitingTextInputFormatter(16)
                        ],
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter driving license number";
                          }
                          return null;
                        }),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          ConvertText.getTitle("Upload Vehicle Photos"),
                        )),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _pickingImage(context, "bike");
                          },
                          child: Center(
                              child: bikeImage == null
                                  ? DottedBorder(
                                      color: Colors.grey,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      padding: const EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.photo,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                ConvertText.getTitle(
                                                    "Upload Photo"),
                                                style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      bikeImage!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.contain,
                                    )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _pickingImage(context, "bike2");
                          },
                          child: Center(
                              child: bikeImage2 == null
                                  ? DottedBorder(
                                      color: Colors.grey,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      padding: const EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.photo,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                ConvertText.getTitle(
                                                    "Upload Photo"),
                                                style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      bikeImage2!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.contain,
                                    )),
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          ConvertText.getTitle("Upload RC Photos"),
                        )),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _pickingImage(context, "rc1");
                          },
                          child: Center(
                              child: rc1 == null
                                  ? DottedBorder(
                                      color: Colors.grey,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      padding: const EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.photo,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                ConvertText.getTitle("Front"),
                                                style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      rc1!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.contain,
                                    )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _pickingImage(context, "rc2");
                          },
                          child: Center(
                              child: rc2 == null
                                  ? DottedBorder(
                                      color: Colors.grey,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      padding: const EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.photo,
                                                color: Colors.grey,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                ConvertText.getTitle("Back"),
                                                style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      rc2!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.contain,
                                    )),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child:
                          Text(ConvertText.getTitle("Upload Driving License")),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickingImage(context, "license");
                            },
                            child: Center(
                                child: licenseImage == null
                                    ? DottedBorder(
                                        color: Colors.grey,
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(12),
                                        padding: const EdgeInsets.all(6),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 60,
                                            width: 150,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.photo,
                                                  color: Colors.grey,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  ConvertText.getTitle(
                                                      "Upload Photo"),
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Image.file(
                                        licenseImage!,
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.contain,
                                      )),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              _pickingImage(context, "licenseTwo");
                            },
                            child: Center(
                                child: licenseImageTwo == null
                                    ? DottedBorder(
                                        color: Colors.grey,
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(12),
                                        padding: const EdgeInsets.all(6),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 60,
                                            width: 150,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.photo,
                                                  color: Colors.grey,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  ConvertText.getTitle(
                                                      "Upload Photo"),
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Image.file(
                                        licenseImageTwo!,
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.contain,
                                      )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocConsumer<VehicleInformationBloc,
                        VehicleInformationState>(
                      listener: (context, state) {
                        if (state is VehicleDetailsSuccessState) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SelectCityScreen(),
                              ));
                        } else if (state is VehicleDetailsFaildeState) {
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 0),
                          child: SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsData.themeColor,
                              ),
                              onPressed: (state is VehicleDetailsLoadingState)
                                  ? () {}
                                  : () {
                                      final FormState? form =
                                          vehicleDetailsKey.currentState;
                                      if (form!.validate()) {
                                        print("form valid");

                                        if (uploadLicenseImagepic != null &&
                                            uploadBikeImagepic != null &&
                                            uploadBikeImagepic2 != null &&
                                            rcOne != null &&
                                            rcTwo != null &&
                                            uploadLicenseImagepicTwo != null) {
                                          if (fromDate.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please update vehicle validity');
                                          } else {
                                            context
                                                .read<VehicleInformationBloc>()
                                                .add(AddVehicleDetailsEvent(
                                                  vehicleType: selectedbikeType,
                                                  vehicleNumber:
                                                      bikeNumberController.text
                                                          .toString(),
                                                  vehicleValidity:
                                                      bikeValidityController
                                                          .text
                                                          .toString(),
                                                  drivingLicenseNumber:
                                                      drivingController.text
                                                          .toString(),
                                                  drivingLicensePhoto:
                                                      uploadLicenseImagepic!,
                                                  vehiclePhoto:
                                                      uploadBikeImagepic!,
                                                  vehiclePhoto2:
                                                      uploadBikeImagepic2!,
                                                  rc1: rcOne!,
                                                  rc2: rcTwo!,
                                                  vehicleName:
                                                      bikeNameController.text
                                                          .toString(),
                                                  drivingLicensePhotoTwo:
                                                      uploadLicenseImagepicTwo!,
                                                ));
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Please upload all images');
                                        }

                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => const SelectCityScreen(),
                                        //     ));
                                      } else {
                                        print("form invalid");
                                      }
                                    },
                              child: BlocBuilder<VehicleInformationBloc,
                                  VehicleInformationState>(
                                builder: (context, state) {
                                  return state is VehicleDetailsLoadingState
                                      ? const ThemeSpinner(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          ConvertText.getTitle("Next"),
                                          style: GoogleFonts.manrope(
                                            letterSpacing: 0.8,
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickingImage(BuildContext context, String picktype) {
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

                  await getImage(ImageSource.camera, picktype);
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

                  await getImage(ImageSource.gallery, picktype);
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
