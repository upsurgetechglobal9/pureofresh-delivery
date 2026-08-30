import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/screens/delivery_preferences.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../commons/shared_prefs.dart';
import '../../../../commons/show_chuk_notification.dart';
import '../../../../commons/url_links.dart';
import '../../../../utility/colors_data.dart';
import '../../../../utility/text_form_field.dart';
import '../../../login/screens/welcome_screen.dart';
import '../../../navigation_bar/navigationbar_screen.dart';
import '../logic/bloc/verification_documents_bloc.dart';

class DocumentVerificationScreen extends StatefulWidget {
  final String? type;
  const DocumentVerificationScreen({super.key, this.type});

  @override
  State<DocumentVerificationScreen> createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  final docsKey = GlobalKey<FormState>();
  TextEditingController panNameController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController panFatherController = TextEditingController();
  // TextEditingController genderController = TextEditingController();
  TextEditingController adharNumberController = TextEditingController();
  TextEditingController adharNameController = TextEditingController();
  String? uploadpanImagepic;
  String? uploadAdharImagepic;
  String? uploadAdharBackImagepic;
  String? selectedGenderValue;
  File? panImage;
  File? adharImage;
  File? adharBackImage;

  ImagePicker picker = ImagePicker();

  Future<File?> pickDocument(ImageSource source, String imageType) async {
    // try {
    // if (await Permission.storage.isGranted) {
    final pickedRawDoc = await picker.pickImage(
      source: source,
      imageQuality: 30,
      maxHeight: 1200,
      maxWidth: 1200,
    );
    // await FilePicker.platform.pickFiles(
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
    final pickedDocument = await pickDocument(source, imageType);
    if (pickedDocument == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No file selected")));
    } else {
      final fileName = pickedDocument.path.split('/').last;
      final data = dio.FormData.fromMap({
        "access_token": Constants.prefs!.getString("token"),
        "image": await dio.MultipartFile.fromFile(
          pickedDocument.path,
          filename: fileName,
        )
      });
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
            if (imageType == "pan") {
              setState(() {
                panImage = pickedDocument;
                uploadpanImagepic = request.data['data'];
              });
            } else if (imageType == "adhar") {
              setState(() {
                adharImage = pickedDocument;
                uploadAdharImagepic = request.data['data'];
              });
            } else if (imageType == "adhar_back") {
              setState(() {
                adharBackImage = pickedDocument;
                uploadAdharBackImagepic = request.data['data'];
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

//   Future<void> getImage(ImageSource source, String imageType) async {
//     final pickedFile = await picker.pickImage(source: source, imageQuality: 30);
//     File fileimgage = File(pickedFile!.path);

//      final data = dio.FormData.fromMap({
//         "access_token": Constants.prefs!.getString("token"),
//         "image": await dio.MultipartFile.fromFile(
//           pickedFile.path,
//           filename: fileName,
//         )
//       });
//  var request = await dio.Dio().post(
//         UrlLinksData.serverUrl + UrlLinksData.imageUploadService,
//         data: data,
//       );
//     // iMAGE CROPING-- if needed
//     if (imageType == "pan") {
//       setState(() {
//         panImage = fileimgage;
//       });
//     }
//     if (imageType == "adhar") {
//       setState(() {
//         adharImage = fileimgage;
//       });
//     }
//   }

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
          ConvertText.getTitle("Verification"),
          style: GoogleFonts.manrope(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: docsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ConvertText.getTitle("Pan Card Details"),
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  DeliveryBoyTextFormField(
                      controller: panNumberController,
                      isDense: true,
                      hint: ConvertText.getTitle("Pan Number"),
                      hintStyle:
                          GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9a-zA-Z\s]')),
                        FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                        FilteringTextInputFormatter.deny(
                          RegExp(r'^0+'), //users can't type 0 at 1st position
                        ),
                        FilteringTextInputFormatter.deny(
                          RegExp(r' '), //users can't type 0 at 1st position
                        ),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Please enter valid details";
                        }
                        if (text.length < 10) {
                          return "Please enter 10 digit valid number";
                        }
                        return null;
                      }),
                  DeliveryBoyTextFormField(
                      controller: panNameController,
                      isDense: true,
                      hint: ConvertText.getTitle("Name as per Pan Card"),
                      hintStyle:
                          GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                        FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                      ],
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Please enter valid details";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    hint: Text(
                      ConvertText.getTitle("Select Gender"),
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey.shade400),
                    ),
                    isDense: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 28,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Male',
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'Female',
                        child: Text('Female'),
                      ),
                    ],
                    onChanged: (droppedItemValue) {
                      setState(() {
                        selectedGenderValue = droppedItemValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select gender' : null,
                  ),
                  // DeliveryBoyTextFormField(
                  //     controller: genderController,
                  //     isDense: true,
                  //     hint: "Gender",
                  //     hintStyle:
                  //         GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                  //     inputFormatters: [
                  //       FilteringTextInputFormatter.allow(
                  //           RegExp(r'[a-zA-Z\s]')),
                  //       FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                  //     ],
                  //     validator: (text) {
                  //       if (text!.isEmpty) {
                  //         return "Please enter valid details";
                  //       }
                  //       return null;
                  //     }),

                  DeliveryBoyTextFormField(
                      controller: panFatherController,
                      isDense: true,
                      hint: ConvertText.getTitle("Father Name"),
                      hintStyle:
                          GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                        FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                      ],
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Please enter valid details";
                        }
                        return null;
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      ConvertText.getTitle("Upload Pan Card Photo"),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _pickingImage(context, "pan");
                      },
                      child: panImage == null
                          ? DottedBorder(
                              dashPattern: const [7, 3],
                              color: Colors.grey,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 70,
                                  // width: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        ConvertText.getTitle("Upload Photo"),
                                        style: GoogleFonts.manrope(
                                            fontSize: 12, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Image.file(
                              panImage!,
                              height: 150,
                              fit: BoxFit.contain,
                            )),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    ConvertText.getTitle("Aadhar Card Details"),
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  DeliveryBoyTextFormField(
                      keyboardType: TextInputType.number,
                      controller: adharNumberController,
                      isDense: true,
                      hint: ConvertText.getTitle("Aadhar Number"),
                      hintStyle:
                          GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                        LengthLimitingTextInputFormatter(12)
                      ],
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Please enter valid details";
                        }
                        if (text.length < 12) {
                          return "Please enter 12 digit valid number";
                        }
                        return null;
                      }),
                  DeliveryBoyTextFormField(
                      controller: adharNameController,
                      isDense: true,
                      hint: ConvertText.getTitle("Name as per Aadhar Card"),
                      hintStyle:
                          GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                        FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                        FilteringTextInputFormatter.deny(RegExp('^0+')),
                      ],
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "Please enter valid details";
                        }
                        return null;
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(ConvertText.getTitle("Upload Aadhar Photo")),
                  ),
                  GestureDetector(
                      onTap: () {
                        _pickingImage(context, "adhar");
                      },
                      child: adharImage == null
                          ? DottedBorder(
                              dashPattern: const [7, 3],
                              color: Colors.grey,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 70,
                                  // width: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        ConvertText.getTitle("Upload Photo"),
                                        style: GoogleFonts.manrope(
                                            fontSize: 12, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Image.file(
                              adharImage!,
                              height: 150,
                              fit: BoxFit.contain,
                            )),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child:
                        Text(ConvertText.getTitle("Upload Aadhar Back Photo")),
                  ),
                  GestureDetector(
                      onTap: () {
                        _pickingImage(context, "adhar_back");
                      },
                      child: adharBackImage == null
                          ? DottedBorder(
                              dashPattern: const [7, 3],
                              color: Colors.grey,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 70,
                                  // width: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        ConvertText.getTitle("Upload Photo"),
                                        style: GoogleFonts.manrope(
                                            fontSize: 12, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Image.file(
                              adharBackImage!,
                              height: 150,
                              fit: BoxFit.contain,
                            )),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocConsumer<VerificationDocumentsBloc,
                      VerificationDocumentsState>(
                    listener: (context, state) {
                      if (state is DocumentsDetailsSuccessState) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DeliveryPreferencesScreen(
                              isFromProfile: true,
                            ),
                          ),
                        );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const ProfileImageScreen(),
                        //     ));
                      } else if (state is DocumentsDetailsFailedState) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomsNaviScreen(
                                index: 0,
                              ),
                            ),
                            (route) => false);
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
                              backgroundColor: const Color(0xFF000000),
                            ),
                            onPressed: state is DocumentsDetailsLoadingState
                                ? () {}
                                : () {
                                    final FormState? form =
                                        docsKey.currentState;
                                    if (form!.validate()) {
                                      if (panImage == null) {
                                        Fluttertoast.showToast(
                                            msg: 'Please Upload Pan Card');
                                      } else if (adharImage == null) {
                                        Fluttertoast.showToast(
                                            msg: 'Please Upload Adhar Front');
                                      } else if (adharBackImage == null) {
                                        Fluttertoast.showToast(
                                            msg: 'Please Upload Adhar Back');
                                      } else {
                                        context
                                            .read<VerificationDocumentsBloc>()
                                            .add(AddDocmentsDetailsEvent(
                                                panName: panNameController.text
                                                    .toString(),
                                                panNumber: panNumberController.text
                                                    .toString(),
                                                panFather: panFatherController
                                                    .text
                                                    .toString(),
                                                panGender: selectedGenderValue
                                                    .toString(),
                                                adharName: adharNameController
                                                    .text
                                                    .toString(),
                                                adharNumber:
                                                    adharNumberController.text
                                                        .toString(),
                                                adharPic: uploadAdharImagepic
                                                    .toString(),
                                                panPic: uploadAdharImagepic
                                                    .toString(),
                                                aadharBack:
                                                    uploadAdharBackImagepic
                                                        .toString()));
                                      }
                                    } else {
                                      print("form invalid");
                                    }
                                  },
                            child: BlocBuilder<VerificationDocumentsBloc,
                                VerificationDocumentsState>(
                              builder: (context, state) {
                                return state is DocumentsDetailsLoadingState
                                    ? const ThemeSpinner(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        ConvertText.getTitle("Submit"),
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
