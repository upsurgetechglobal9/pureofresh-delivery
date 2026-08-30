import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../../../../../commons/show_chuk_notification.dart';
import '../../../../../commons/url_links.dart';
import '../../../../../utility/text_form_field.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final bankKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  String add = "";

  getBankDetails() async {
    final formData = FormData.fromMap({
      'access_token': Constants.prefs!.getString("token"),
    });
    final dio = Dio();
    addChuck(dio);
    final response = await dio.post(
        UrlLinksData.serverUrl + UrlLinksData.getBankDetailsUrl,
        data: formData);
    print(response.data);
    if (response.data['err_code'] == 'valid') {
      // startTimer();
      setState(() {
        add = response.data['data']['id'];
        nameController.text = response.data['data']['account_name'];
        bankNameController.text = response.data['data']['bank_name'];
        accountNumberController.text = response.data['data']['account_number'];
        branchController.text = response.data['data']['branch'];
        ifscController.text = response.data['data']['ifsc_code'];
      });
    }
  }

  addUpdateBankDetails() async {
    final FormState? form = bankKey.currentState;
    if (form!.validate()) {
      final formData = FormData.fromMap({
        'access_token': Constants.prefs!.getString("token"),
        "account_name": nameController.text,
        "account_number": accountNumberController.text,
        "bank_name": bankNameController.text,
        "branch": branchController.text,
        "ifsc_code": ifscController.text,
      });
      final dio = Dio();
      addChuck(dio);
      final response = await dio.post(
          UrlLinksData.serverUrl + UrlLinksData.addUpdateBankDetailsUrl,
          data: formData);
      print(response.data);
      if (response.data['err_code'] == 'valid') {
        Fluttertoast.showToast(
            msg: "${response.data['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green.shade100,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pop(context);
      } else if (response.data['err_code'] == 'invalid') {
        Fluttertoast.showToast(
            msg: "${response.data['message']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: const Color.fromARGB(255, 248, 227, 227),
            fontSize: 16.0);
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBankDetails();
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
          ConvertText.getTitle("Bank Details"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: bankKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 14,
                ),
                Text(
                  ConvertText.getTitle("Account Holder Name"),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                DeliveryBoyTextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  bottomPadding: 10,
                  topPadding: 7,
                  hint: ConvertText.getTitle("Enter Account Holder Name"),
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                  ],
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
                  },
                ),
                Text(
                  ConvertText.getTitle("Account Number"),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                DeliveryBoyTextFormField(
                  textInputAction: TextInputAction.next,
                  controller: accountNumberController,
                  bottomPadding: 10,
                  topPadding: 7,
                  hint: ConvertText.getTitle("Enter Account Number"),
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
                    FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+'), //users can't type 0 at 1st position
                    ),
                    LengthLimitingTextInputFormatter(20)
                  ],
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
                  },
                ),
                Text(
                  ConvertText.getTitle("Bank Name"),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                DeliveryBoyTextFormField(
                  controller: bankNameController,
                  bottomPadding: 10,
                  topPadding: 7,
                  hint: ConvertText.getTitle("Enter Bank Name"),
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z\s]')),
                    FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                  ],
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
                  },
                ),
                Text(
                  ConvertText.getTitle("Branch"),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                DeliveryBoyTextFormField(
                  textInputAction: TextInputAction.next,
                  controller: branchController,
                  bottomPadding: 10,
                  topPadding: 7,
                  hint: ConvertText.getTitle("Enter Branch"),
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                  ],
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
                  },
                ),
                Text(
                  ConvertText.getTitle("IFSC Code"),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                DeliveryBoyTextFormField(
                  textInputAction: TextInputAction.next,
                  controller: ifscController,
                  bottomPadding: 10,
                  topPadding: 7,
                  hint: ConvertText.getTitle("Enter IFSC Code"),
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z\s]')),
                    FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                    LengthLimitingTextInputFormatter(11)
                  ],
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                    ),
                    onPressed: () {
                      addUpdateBankDetails();
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12),
                        child: add == ''
                            ? Text(
                                ConvertText.getTitle("ADD DETAILS"),
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Text(
                                ConvertText.getTitle("UPDATE DETAILS"),
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
