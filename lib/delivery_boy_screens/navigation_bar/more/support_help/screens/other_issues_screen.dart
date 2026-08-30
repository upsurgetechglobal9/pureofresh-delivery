import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dotted_border/dotted_border.dart';
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
import '../logic/bloc/support_help_bloc.dart';

class OtherIssueScreen extends StatefulWidget {
  const OtherIssueScreen({super.key});

  @override
  State<OtherIssueScreen> createState() => _OtherIssueScreenState();
}

class _OtherIssueScreenState extends State<OtherIssueScreen> {
  final otherKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  File? attachOne;
  String uploadAttachOne = '';

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
          ConvertText.getTitle("Other Issues"),
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
          child: Form(
            key: otherKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DeliveryBoyTextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    isDense: true,
                    hint: ConvertText.getTitle("Describe the Issue"),
                    hintStyle:
                        GoogleFonts.manrope(color: Colors.grey, fontSize: 12),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9a-zA-Z\s@#%&+/!?.,;:-]')),
                      FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                    ],
                    validator: (text) {
                      if (text!.isEmpty) {
                        return ConvertText.getTitle("Please enter Order Id");
                      }
                      return null;
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    ConvertText.getTitle("Attachment"),
                    style: GoogleFonts.manrope(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickingImage();
                      },
                      child: Center(
                          child: attachOne == null
                              ? DottedBorder(
                                  dashPattern: const [7, 3],
                                  color: Colors.grey,
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  padding: const EdgeInsets.all(6),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 70,
                                      width: 150,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.cloud_upload,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            ConvertText.getTitle("Upload"),
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
                                  attachOne!,
                                  height: 150,
                                  fit: BoxFit.contain,
                                )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<SupportHelpBloc, SupportHelpState>(
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
                            onPressed: () {
                              final FormState? form = otherKey.currentState;
                              if (form!.validate()) {
                                print("form valid");
                                context.read<SupportHelpBloc>().add(
                                    AnyOtherIssueEvent(
                                        description: descriptionController.text
                                            .toString(),
                                        image: uploadAttachOne));
                                Navigator.pop(context);
                              } else {
                                print("form invalid");
                              }
                            },
                            child: Text(
                              "Upload",
                              style: GoogleFonts.manrope(
                                letterSpacing: 0.8,
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickingImage() {
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
