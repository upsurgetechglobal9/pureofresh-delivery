import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as geo;
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../commons/ConvertText.dart';
import '../../../commons/shared_prefs.dart';
import '../../../utility/colors_data.dart';
import '../../../utility/common_text.dart';
import '../../../utility/text_form_field.dart';
import '../../../utility/widgets/theme_spinner.dart';
import '../../location_popup.dart';
import '../../navigation_bar/more/cms_screens/logic/cubit/delivery_preferences_cubit.dart';
import '../../navigation_bar/more/cms_screens/models/vehicles_as_per_preferences_model.dart';
import '../../navigation_bar/more/cms_screens/screens/cms_typewise_screens.dart';
import '../../navigation_bar/more/cms_screens/widgets/drop_down_widget.dart';
import '../logic/bloc/basic_details_bloc.dart';
import '../logic/cubit/register_data_cubit.dart';
import 'otp_verify_screen.dart';

class EnterMobileNumberScreen extends StatefulWidget {
  final String selectedType;
  final String selectedTypeId;

  const EnterMobileNumberScreen(
      {super.key, required this.selectedType, required this.selectedTypeId});

  @override
  State<EnterMobileNumberScreen> createState() =>
      _EnterMobileNumberScreenState();
}

class _EnterMobileNumberScreenState extends State<EnterMobileNumberScreen> {
  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();
  TextEditingController pincodeController = TextEditingController();
  final basicInfoKey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  //TextEditingController referalCode = TextEditingController();
////
  String currentText = "";
  bool hasError = false;
  String? selectedValue;
  String gender = "Male";
  bool isSecure = true;
  Position? currentLocation;
  PreferVehicleData? preferVehicleData;
  String vechileType = "";

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    geo.Location location = geo.Location();

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (Constants.prefs!.getString("bglocation") == 'agree') {
        await location.requestService();
      }
      if (!serviceEnabled) {
        if (Constants.prefs!.getString("bglocation") == 'agree') {
          await location.requestService();
        }
        if (!serviceEnabled) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const LocationPopUp(gps: 'gps', screen: 'register'),
              ),
            );
          }
        }
      }

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (Constants.prefs!.getString("bglocation") == 'agree') {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void didChangeDependencies() async {
    context
        .read<DeliveryPreferencesCubit>()
        .fetchVechilesStates(widget.selectedTypeId);
    var d = await _determinePosition();
    setState(() {
      setState(() {
        currentLocation = d;
      });
    });
    super.didChangeDependencies();
  }

  bool _acceptTerms = false;

  void _registerUser() async {
    //
    if (currentLocation != null) {
      context.read<RegisterDataCubit>().doregisterData(
          selectedTypeId: widget.selectedTypeId,
          vechileTypeId: vechileType,
          name: nameController.text.toString(),
          email: emailController.text.toString(),
          mobileNumber: numberController.text.toString(),
          gender: selectedValue.toString(),
          age: ageController.text.toString(),
          laguages: languageController.text.toString(),
          latitude: currentLocation != null
              ? currentLocation!.latitude.toString()
              : "",
          longitude: currentLocation != null
              ? currentLocation!.longitude.toString()
              : "");
    } else {
      print("location permission");
      if (Constants.prefs!.getString("bglocation") == 'agree') {
        var d = await _determinePosition();
        if (mounted) {
          setState(() {
            currentLocation = d;
          });
        }
      }
      //ignore: use_build_context_synchronously
      context.read<RegisterDataCubit>().doregisterData(
          selectedTypeId: widget.selectedTypeId,
          vechileTypeId: vechileType,
          name: nameController.text.toString(),
          email: emailController.text.toString(),
          mobileNumber: numberController.text.toString(),
          gender: selectedValue.toString(),
          age: ageController.text.toString(),
          laguages: languageController.text.toString(),
          latitude: currentLocation != null
              ? currentLocation!.latitude.toString()
              : '',
          longitude: currentLocation != null
              ? currentLocation!.longitude.toString()
              : "");
    }
  }

  @override
  void dispose() {
    pincodeController.dispose();
    numberController.dispose();
    nameController.dispose();
    ageController.dispose();
    cityController.dispose();
    emailController.dispose();
    languageController.dispose();
    genderController.dispose();
    // referalCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BasicDetailsBloc, BasicDetailsState>(
      listener: (context, state) {
        // if (state is ShowVerifyOtpState) {
        //   otpVerify();
        // }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ConvertText.getTitle('Personal Information'),
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      color: ColorsData.themeColor,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                    ConvertText.getTitle(
                        'Please Complete Personal Details to\n Complete Pure o Fresh deliveryboy'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    )),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Form(
                    key: basicInfoKey,
                    child: Column(
                      children: [
                        DeliveryBoyTextFormField(
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            controller: nameController,
                            hint: ConvertText.getTitle('Full Name'),
                            isDense: true,
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                              FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                            ],
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Please enter full name";
                              }
                              return null;
                            }),
                        DeliveryBoyTextFormField(
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            controller: ageController,
                            hint: ConvertText.getTitle('Age'),
                            textInputAction: TextInputAction.next,
                            isDense: true,
                            autofocus: true,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                              LengthLimitingTextInputFormatter(2)
                            ],
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Please enter age";
                              } else if (int.parse(text) < 18) {
                                return "Please enter valid age 18+";
                              }
                              return null;
                            }),
                        DeliveryBoyTextFormField(
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            controller: numberController,
                            hint: ConvertText.getTitle('Mobile Number'),
                            textInputAction: TextInputAction.next,
                            isDense: true,
                            autofocus: true,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                              LengthLimitingTextInputFormatter(10)
                            ],
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Please enter mobile number";
                              }
                              if (text.length < 10) {
                                return "Please enter 10 digit valid mobile number";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          child: DropdownButtonFormField(
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            hint: Text(
                              ConvertText.getTitle('Select Gender'),
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey.shade400),
                            ),
                            isDense: true,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 28,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                                selectedValue = droppedItemValue;
                              });
                            },
                            validator: (value) =>
                            value == null ? 'Please select gender' : null,
                          ),
                        ),
                        widget.selectedTypeId == '1'
                            ? const SizedBox(
                          height: 0,
                          width: 0,
                        )
                            : BlocBuilder<DeliveryPreferencesCubit,
                            DeliveryPreferencesState>(
                          builder: (context, deliveryPreferencesState) {
                            if (deliveryPreferencesState.dataLoading) {
                              return const ThemeSpinner();
                            } else if (deliveryPreferencesState.error !=
                                null) {
                              return CommonProximaNovaTextWidget(
                                  text: deliveryPreferencesState.error!);
                            } else {
                              if (deliveryPreferencesState
                                  .preferVehicleData.isNotEmpty) {
                                return ThemeTextFormFieldDropDown<
                                    PreferVehicleData>(
                                  value: preferVehicleData,
                                  suffixIcon: deliveryPreferencesState
                                      .isVehicleDropdownLoading
                                      ? const ThemeSpinner(
                                    size: 30,
                                    color: Colors.black,
                                  )
                                      : const Icon(Icons
                                      .keyboard_arrow_down_outlined),
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  items: deliveryPreferencesState
                                      .preferVehicleData
                                      .map(
                                        (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.typeStateName),
                                    ),
                                  )
                                      .toList(),
                                  hint: "Select Vechile Data",
                                  onChanged: (value) async {
                                    preferVehicleData = value;
                                    if (preferVehicleData != null) {
                                      await context
                                          .read<
                                          DeliveryPreferencesCubit>()
                                          .selectedDataVechile(
                                        ctiyName: preferVehicleData!
                                            .typeStateName,
                                      );
                                      if (mounted) {
                                        setState(() {
                                          vechileType =
                                              preferVehicleData!.id;
                                        });
                                      }
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Field can't be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                );
                              } else {
                                return const ThemeSpinner();
                              }
                            }
                          },
                        ),
                        DeliveryBoyTextFormField(
                          controller: emailController,
                          hint: "Email ID",
                          textInputAction: TextInputAction.next,
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          isDense: true,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(' ')),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email ID is required';
                            }
                            if (!RegExp(
                                r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
                                .hasMatch(value)) {
                              return 'Enter a valid email id';
                            }
                            return null;
                          },
                          // validator: (value) {
                          //   String pattern =
                          //       r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          //       r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          //       r"{0,253}[a-zA-Z0-9])?)*$";
                          //   RegExp regex = RegExp(pattern);
                          //   if (value!.isEmpty) {
                          //     return "Enter your email";
                          //   } else if (!regex
                          //       .hasMatch(emailController.text)) {
                          //     return "Please enter proper Email";
                          //   } else {
                          //     return null;
                          //   }
                          // }
                          // validator: (value) {
                          //   String pattern =
                          //       r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          //       r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          //       r"{0,253}[a-zA-Z0-9])?)*$";
                          //   RegExp regex = RegExp(pattern);
                          //   RegExp comRegex = RegExp(r'\.com$');
                          //   if (value == null || value.isEmpty) {
                          //     return "Field can't be empty";
                          //   } else if (!regex.hasMatch(value)) {
                          //     return 'Enter a valid email address';
                          //   } else if (!comRegex.hasMatch(value)) {
                          //     return 'Email address should end with .com';
                          //   } else if (value.trim().isEmpty) {
                          //     return "Invalid entry";
                          //   } else {
                          //     return null;
                          //   }
                          // },
                          // validator: (text) {
                          //   if (text!.isEmpty) {
                          //     return "Please add valid details";
                          //   }
                          //   return null;
                          // }
                        ),
                        DeliveryBoyTextFormField(
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            controller: languageController,
                            textInputAction: TextInputAction.done,
                            hint: ConvertText.getTitle('Languages Known'),
                            isDense: true,
                            autofocus: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s,]')),
                              FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                              FilteringTextInputFormatter.deny(RegExp(r'^\,+')),
                            ],
                            validator: (text) {
                              if (text!.isEmpty) {
                                return " languages";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.black,
                              hoverColor: Colors.black,
                              checkColor: Colors.white,
                              value:
                              _acceptTerms, // _acceptTerms is a boolean variable to track the state of the checkbox
                              onChanged: (bool? value) {
                                if (mounted) {
                                  setState(() {
                                    _acceptTerms = value ??
                                        false; // Update the state when the checkbox value changes
                                  });
                                }
                              },
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'While Registering I accept all ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontFamily:
                                        'ProximaNova' // You can change the color as desired
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms and\n Conditions',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontFamily:
                                        'ProximaNova' // You can change the color as desired
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CMsTypeWiseScreen(
                                                apiType: "pages/terms",
                                                titleType: ConvertText.getTitle(
                                                    'Terms and Conditions')),
                                          ),
                                        );
                                      },
                                  ),
                                  const TextSpan(
                                    text: ' ',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                BlocConsumer<RegisterDataCubit, RegisterDataState>(
                  listener: (context, registerDataState) {
                    if (registerDataState.isRegisterSucess) {
                      if (mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpVerifyScreen(
                                  mobileNumber:
                                  numberController.text.toString(),
                                  type: 'register'),
                            ));
                        // showRegisterOtpBottomSheet(
                        //     context, numberController.text.toString());
                      }
                    }
                  },
                  builder: (context, registerDataState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: registerDataState.dataLoading
                            ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsData.themeColor,
                          ),
                          onPressed: () async {},
                          child: const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsData.themeColor,
                          ),
                          onPressed: () {
                            final FormState? form =
                                basicInfoKey.currentState;
                            if (form!.validate()) {
                              if (_acceptTerms == true) {
                                _registerUser();
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                    "Please accept terms and conditions");
                              }

                              // context.read<BasicDetailsBloc>().add(
                              //     AddBasicInformation(
                              //         mobileNumber:
                              //             numberController.text.toString(),
                              //         name: nameController.text.toString(),
                              //         age: ageController.text.toString(),
                              //         emailId: emailController.text.toString(),
                              //         laguage: languageController.text.toString(),
                              //         gender: selectedValue.toString(),
                              //         latitude:
                              //             currentLocation!.latitude.toString() ??
                              //                 '0',
                              //         longitude:
                              //             currentLocation!.longitude.toString() ??
                              //                 '0'));
                              // otpVerify();
                            } else {
                              if (kDebugMode) {
                                print("form invalid");
                              }
                            }
                          },
                          child: Text(
                            ConvertText.getTitle('Register Now'),
                            style: GoogleFonts.manrope(
                              letterSpacing: 0.8,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
