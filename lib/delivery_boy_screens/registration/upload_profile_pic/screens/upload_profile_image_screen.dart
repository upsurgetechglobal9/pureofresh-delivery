// import 'dart:io';

import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../commons/shared_prefs.dart';
import '../../../../commons/show_chuk_notification.dart';
import '../../../../commons/url_links.dart';
import '../../registration_successful/screens/registration_successful_screen.dart';
import '../logic/bloc/upload_profile_pic_bloc.dart';

class ProfileImageScreen extends StatefulWidget {
  const ProfileImageScreen({
    super.key,
  });

  @override
  State<ProfileImageScreen> createState() => _ProfileImageScreenState();
}

class _ProfileImageScreenState extends State<ProfileImageScreen> {
  String? uploadprofilePic;
  File? checkImage;
  ImagePicker picker = ImagePicker();

  Future<File?> pickDocument(ImageSource source) async {
    final pickedRawDoc = await picker.pickImage(
      source: source,
      imageQuality: 30,
      maxHeight: 1200,
      maxWidth: 1200,
    );
    if (pickedRawDoc == null) {
      return null;
    } else {
      return File(pickedRawDoc.path);
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedDocument = await pickDocument(source);
    if (pickedDocument == null) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No file selected")));
      }
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

      if (request.data['err_code'] == "valid") {
        if (mounted) {
          setState(() {
            checkImage = pickedDocument;
            uploadprofilePic = request.data['data'];
          });
          print("ready to upload data of image  $uploadprofilePic");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          ConvertText.getTitle("Upload Photo"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<UploadProfilePicBloc, UploadProfilePicState>(
        listener: (context, state) {
          if (state is UploadProfilePicSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegistrationSuccessScreen(),
                ),
                (route) => false);
          }
        },
        builder: (context, state) {
          return Center(
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
                              size: 28,
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
                          ConvertText.getTitle("to Complete your Profile"),
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
                                backgroundColor: const Color(0xFF000000),
                              ),
                              onPressed: () {
                                getImage(ImageSource.camera);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12),
                                child: Text(
                                  ConvertText.getTitle("CAMERA"),
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
                                backgroundColor: const Color(0xFF000000),
                              ),
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12),
                                child: Text(
                                  ConvertText.getTitle("GALLERY"),
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
                  : Column(
                      children: [
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
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          ConvertText.getTitle("Your Photo has been uploaded"),
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
                                backgroundColor: Colors.grey.shade400,
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileImageScreen(),
                                    ));
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
                            BlocBuilder<UploadProfilePicBloc, UploadProfilePicState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: (state is LoadingState) ?(){

                                  }:() {
                                    
                                    context.read<UploadProfilePicBloc>().add(
                                        UploadImageSendingEvent(
                                            image: uploadprofilePic!));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 12),
                                    child: Text(
                                      ConvertText.getTitle(state is LoadingState?"WAIT..":"UPLOAD"),
                                      style: GoogleFonts.manrope(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    )
            ],
          ));
        },
      ),
    );
  }
}
