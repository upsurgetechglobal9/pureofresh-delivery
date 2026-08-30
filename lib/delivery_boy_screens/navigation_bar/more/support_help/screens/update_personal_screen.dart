import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../../../../../commons/show_chuk_notification.dart';
import '../../../../../commons/url_links.dart';
import '../../../../../utility/colors_data.dart';
import '../../../../../utility/text_form_field.dart';
import '../../../home/logic/bloc/dashboard_home_bloc.dart';
import '../logic/bloc/support_help_bloc.dart';

class UpdatePersonalDetails extends StatefulWidget {
  const UpdatePersonalDetails({super.key});

  @override
  State<UpdatePersonalDetails> createState() => _UpdatePersonalDetailsState();
}

class _UpdatePersonalDetailsState extends State<UpdatePersonalDetails> {
  final profileKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController languageController = TextEditingController();

  File? attachOne;
  String uploadAttachOne = '';

  File? bikeImage;
  String? bikeImages;
  File? licenseImage;
  ImagePicker picker = ImagePicker();

  Future<File?> pickDocument(ImageSource source) async {
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

  Future<void> getImage(
    ImageSource source,
  ) async {
    final pickedDocument = await pickDocument(source);
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
      print("Rab ka AAA");
      print(request.data);
      if (request.data['err_code'] == "valid") {
        // print("AAA KKK BBB ${request.data['data']['uploaded_pic_path']}");
        if (mounted) {
          // attachpic = request.data['data']['uploaded_pic_path'];

          setState(() {
            attachOne = pickedDocument;
            uploadAttachOne = request.data['data'];
          });
          print("attcHH $uploadAttachOne");
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SupportHelpBloc>().add(ProfileDetailsFetchingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportHelpBloc, SupportHelpState>(
      listener: (context, state) {
        if (state is ProfileDetailsSuccessState) {
          nameController.text = state
              .myProfileDetailsModel.deliveryPersonDetails.personName
              .toString();
          languageController.text = state
              .myProfileDetailsModel.deliveryPersonDetails.languagesKnown
              .toString();
          uploadAttachOne = state
              .myProfileDetailsModel.deliveryPersonDetails.profilePhoto
              .toString();
        }
        if (state is ProfileAddedSuccessState) {
          context.read<DashboardHomeBloc>().add(DashBoardDetailsFetchingEvent(
              accessToken: (Constants.prefs!.getString("token"))!));
          Navigator.pop(context);
        }

        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ProfileDetailsSuccessState) {
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
                ConvertText.getTitle("Update Personal Details"),
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (state is ProfileDetailsLoadingState)
                      const Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),

                    Center(
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        // color: Colors.amber,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            attachOne == null
                                ? state
                                            .myProfileDetailsModel
                                            .deliveryPersonDetails
                                            .profilePhoto ==
                                        ''
                                    ? const CircleAvatar(
                                        radius: 68,
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 68,
                                        backgroundImage: NetworkImage(state
                                            .myProfileDetailsModel
                                            .deliveryPersonDetails
                                            .profilePhoto),
                                      )
                                : CircleAvatar(
                                    radius: 68,
                                    backgroundImage: FileImage(attachOne!)),
                            Align(
                                alignment: const Alignment(0.9, 0.6),
                                child: InkWell(
                                  onTap: () {
                                    _pickingImageAS();
                                  },
                                  child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: ColorsData.themeColor,
                                      child: const Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.white,
                                      )),
                                )),
                          ],
                        ),
                      ),
                    ),

                    Form(
                      key: profileKey,
                      child: Column(
                        children: [
                          DeliveryBoyTextFormField(
                              controller: nameController,
                              isDense: true,
                              hint: ConvertText.getTitle("Enter name"),
                              hintStyle: GoogleFonts.manrope(
                                  color: Colors.grey, fontSize: 12),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s+')),
                              ],
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return ConvertText.getTitle(
                                      "Please enter name");
                                }
                                return null;
                              }),
                          DeliveryBoyTextFormField(
                              controller: languageController,
                              isDense: true,
                              hint:
                                  ConvertText.getTitle("Enter known languages"),
                              hintStyle: GoogleFonts.manrope(
                                  color: Colors.black, fontSize: 12),
                              inputFormatters: [
                                // FilteringTextInputFormatter.allow(
                                //     RegExp(r'[0-9a-zA-Z\s]')),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^\s+')),
                              ],
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return ConvertText.getTitle(
                                      "Please enter known languages");
                                }
                                return null;
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // BlocConsumer<SupportHelpBloc, SupportHelpState>(
                    //   listener: (context, state) {
                    //     // if (state is VehicleDetailsSuccessState) {
                    //     //   Navigator.push(
                    //     //       context,
                    //     //       MaterialPageRoute(
                    //     //         builder: (context) => SelectCityScreen(),
                    //     //       ));
                    //     // }
                    //   },
                    //   builder: (context, state) {
                    //     return

                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        child: SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF000000),
                            ),
                            onPressed: () {
                              final FormState? form = profileKey.currentState;
                              if (form!.validate()) {
                                context.read<SupportHelpBloc>().add(
                                    ProfileAddDetailsEvent(
                                        image: attachOne == null
                                            ? ''
                                            : uploadAttachOne,
                                        name: nameController.text.toString(),
                                        languages: languageController.text
                                            .toString()));

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => const SelectCityScreen(),
                                //     ));
                              } else {
                                print("form invalid");
                              }
                            },
                            child: Text(
                              ConvertText.getTitle("UPDATE"),
                              style: GoogleFonts.manrope(
                                letterSpacing: 0.8,
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              // BlocBuilder<VehicleInformationBloc,
                              //     VehicleInformationState>(
                              //   builder: (context, state) {
                              //     if (state is VehicleDetailsLoadingState) {
                              //       return CircularProgressIndicator();
                              //     }
                              //     return Text(
                              //       "Next",
                              //       style: GoogleFonts.manrope(
                              //         letterSpacing: 0.8,
                              //         color: Colors.white,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     );
                              //   },
                              // ),
                            ),
                          ),
                        ))
                    //   },
                    // )
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickingImageAS() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            ConvertText.getTitle('Choose Pic From'),
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
                      ConvertText.getTitle('Camera'),
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
                      ConvertText.getTitle('Gallery'),
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
