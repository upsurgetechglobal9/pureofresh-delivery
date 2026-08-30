// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';

// import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/navigationbar_screen.dart';
// import 'package:pure_o_fresh_rider_app/utility/date_picker_text_field.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../../../commons/ConvertText.dart';
// import '../../../../utility/colors_data.dart';
// import '../../../location_popup.dart';
// import '../logic/my_earnings_bloc.dart';
// import 'package:location/location.dart' as geo;

// class MyEarningsScreen extends StatefulWidget {
//   const MyEarningsScreen({super.key});

//   @override
//   State<MyEarningsScreen> createState() => _MyEarningsScreenState();
// }

// class _MyEarningsScreenState extends State<MyEarningsScreen> {
//   TextEditingController fromController = TextEditingController();
//   TextEditingController todatecontroller = TextEditingController();
//   // String? fromDate;
//   DateTime? currentBackPressTime;
//   DateTime fromDate = DateTime.now();

//   int? start;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     context
//         .read<MyEarningsBloc>()
//         .add(const MyEarningsFetchingEvent(fromDate: '', toDate: ''));
//     determinePosition();
//   }

//   Future<Position> determinePosition() async {
//     geo.Location location = geo.Location();

//     bool serviceEnabled;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await location.requestService();
//       if (!serviceEnabled) {
//         await location.requestService();
//         if (!serviceEnabled) {
//           if (mounted) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     const LocationPopUp(gps: 'gps', screen: 'register'),
//               ),
//             );
//           }
//         }
//       }
//       return Future.error('Location services are disabled.');
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   Future<bool> onWillPop() {
//     print("object");
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
//       currentBackPressTime = now;

//       // Fluttertoast.showToast(msg: 'Tap back again to leave');
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BottomsNaviScreen(index: 0),
//           ));

//       return Future.value(false);
//     }
//     // Navigator.pushReplacement(
//     //     context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
//     // Navigator.pop(context, true);
//     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//     return Future.value(true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           // leading: null,
//           title: Text(
//             ConvertText.getTitle("My Incentives"),
//             style: GoogleFonts.manrope(
//               fontSize: 14,
//               color: Colors.black,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         ConvertText.getTitle("From"),
//                         style: GoogleFonts.manrope(
//                           fontSize: 12,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.42,
//                         child: Theme(
//                           data: Theme.of(context).copyWith(
//                               colorScheme: ColorScheme.light(
//                             onBackground: Colors.transparent,
//                             primary: ColorsData.themeColor,
//                           )),
//                           child: TextFormField(
//                             controller: fromController,
//                             readOnly: true,
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.only(left: 8),
//                               fillColor: Colors.white,
//                               filled: true,
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide:
//                                     const BorderSide(color: Colors.grey),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     width: 1, color: Colors.grey.shade400),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       width: 1, color: Colors.grey.shade400),
//                                   borderRadius: BorderRadius.circular(8)),
//                               hintText: "Select Date",
//                               hintStyle: GoogleFonts.montserrat(
//                                   textStyle: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               )),
//                               suffixIcon: Icon(
//                                 Icons.calendar_month_rounded,
//                                 size: 20,
//                                 color: ColorsData.themeColor,
//                               ),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8)),
//                             ),
//                             onTap: () async {
//                               await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime(1970),
//                                 lastDate: DateTime.now(),
//                               ).then(
//                                 (value) =>
//                                     value != null ? fromDate = value : null,
//                               );
//                               setState(() {
//                                 DateTime now = fromDate;
//                                 String formattedDate =
//                                     DateFormat('dd-MM-yyyy').format(now);
//                                 // // selectedToDate = val;
//                                 fromController.text = formattedDate;
//                               });
//                               print("object fdft ${fromController.text}");
//                             },
//                             onChanged: (val) {
//                               setState(() {
//                                 // selectedToDate = val;
//                                 fromController.text = val;
//                               });
//                               print("object $fromDate");
//                             },
//                             onSaved: (val) => print(val),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         ConvertText.getTitle("To"),
//                         style: GoogleFonts.manrope(
//                           fontSize: 12,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 4,
//                       ),
//                       BlocConsumer<MyEarningsBloc, MyEarningsState>(
//                         listener: (context, state) {
//                           // TODO: implement listener
//                         },
//                         builder: (context, state) {
//                           return SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.42,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   /**safedoor theme wrape theme widget */
//                                   Theme(
//                                       data: Theme.of(context).copyWith(
//                                           colorScheme: ColorScheme.light(
//                                         onBackground: Colors.transparent,
//                                         primary: ColorsData.themeColor,
//                                       )),
//                                       child: TextFormField(
//                                         controller: todatecontroller,
//                                         readOnly: true,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.only(left: 8),
//                                           fillColor: Colors.white,
//                                           filled: true,
//                                           focusedBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             borderSide: const BorderSide(
//                                                 color: Colors.grey),
//                                           ),
//                                           disabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 width: 1,
//                                                 color: Colors.grey.shade400),
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   width: 1,
//                                                   color: Colors.grey.shade400),
//                                               borderRadius:
//                                                   BorderRadius.circular(8)),
//                                           hintText: "Select Date",
//                                           hintStyle: GoogleFonts.montserrat(
//                                               textStyle: const TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.grey,
//                                           )),
//                                           suffixIcon: Icon(
//                                             Icons.calendar_month_rounded,
//                                             size: 20,
//                                             color: ColorsData.themeColor,
//                                           ),
//                                           border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8)),
//                                         ),
//                                         onTap: () async {
//                                           if (fromController.text.isNotEmpty) {
//                                             await showDatePicker(
//                                               context: context,
//                                               initialDate: fromDate,
//                                               firstDate: fromDate,
//                                               lastDate: DateTime.now(),
//                                             ).then((value) {
//                                               todatecontroller.text =
//                                                   DateFormat('dd-MM-yyyy')
//                                                       .format(value!);
//                                               context
//                                                   .read<MyEarningsBloc>()
//                                                   .add(MyEarningsFetchingEvent(
//                                                       fromDate:
//                                                           fromController.text,
//                                                       toDate: todatecontroller
//                                                           .text));
//                                             });
//                                           } else {
//                                             Fluttertoast.showToast(
//                                                 backgroundColor: Colors.red,
//                                                 msg:
//                                                     "Please select from date first");
//                                           }
//                                           print("object fdf $fromDate");
//                                         },
//                                         onChanged: (val) {
//                                           setState(() {
//                                             // selectedToDate = val;

//                                             // fromDate = val;
//                                           });
//                                           print("object $fromDate");
//                                         },
//                                       )),
//                                 ],
//                               ));
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Column(
//             //         mainAxisAlignment: MainAxisAlignment.start,
//             //         crossAxisAlignment: CrossAxisAlignment.start,
//             //         children: [
//             //           Text(
//             //             ConvertText.getTitle("From"),
//             //             style: GoogleFonts.manrope(
//             //               fontSize: 12,
//             //               color: Colors.black,
//             //               fontWeight: FontWeight.w600,
//             //             ),
//             //           ),
//             //           const SizedBox(
//             //             height: 4,
//             //           ),
//             //           SizedBox(
//             //               width: MediaQuery.of(context).size.width * 0.42,
//             //               child: Theme(
//             //                 data: Theme.of(context).copyWith(
//             //                     colorScheme: ColorScheme.light(
//             //                   onBackground: Colors.transparent,
//             //                   primary: ColorsData.themeColor,
//             //                 )),
//             //                 child: DatePickerTextField(
//             //                   initialDate: DateTime.now(),
//             //                   hintText: ConvertText.getTitle("From Date"),
//             //                   controller: fromController,
//             //                   onChanged: (value) {
//             //                     setState(() {
//             //                       fromDate = value;
//             //                       start = 1;
//             //                     });
//             //                     print(fromDate);
//             //                   },
//             //                   firstDate: DateTime.now(),
//             //                   onFieldSubmitted: (String) {},
//             //                 ),
//             //               )),
//             //         ],
//             //       ),
//             //       const SizedBox(
//             //         width: 10,
//             //       ),
//             //       Column(
//             //         mainAxisAlignment: MainAxisAlignment.start,
//             //         crossAxisAlignment: CrossAxisAlignment.start,
//             //         children: [
//             //           Text(
//             //             ConvertText.getTitle("To"),
//             //             style: GoogleFonts.manrope(
//             //               fontSize: 12,
//             //               color: Colors.black,
//             //               fontWeight: FontWeight.w600,
//             //             ),
//             //           ),
//             //           const SizedBox(
//             //             height: 4,
//             //           ),
//             //           BlocConsumer<MyEarningsBloc, MyEarningsState>(
//             //             listener: (context, state) {
//             //               // TODO: implement listener
//             //             },
//             //             builder: (context, state) {
//             //               return SizedBox(
//             //                   width: MediaQuery.of(context).size.width * 0.42,
//             //                   child: Column(
//             //                     crossAxisAlignment: CrossAxisAlignment.start,
//             //                     children: [
//             //                       /**safedoor theme wrape theme widget */
//             //                       Theme(
//             //                         data: Theme.of(context).copyWith(
//             //                             colorScheme: ColorScheme.light(
//             //                           onBackground: Colors.transparent,
//             //                           primary: ColorsData.themeColor,
//             //                         )),
//             //                         child: DatePickerTextField(
//             //                           initialDate: DateTime.now(),
//             //                           hintText: ConvertText.getTitle("To Date"),
//             //                           controller: todatecontroller,
//             //                           onChanged: (value) {
//             //                             print("final  -  ");
//             //                             context.read<MyEarningsBloc>().add(
//             //                                 MyEarningsFetchingEvent(
//             //                                     fromDate: fromDate!,
//             //                                     toDate: value));
//             //                             print("fin  -  ");
//             //                           },
//             //                           firstDate: DateTime.now(),
//             //                           onFieldSubmitted: (string) {},
//             //                         ),
//             //                       ),
//             //                     ],
//             //                   ));
//             //             },
//             //           ),
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Container(
//               child: BlocBuilder<MyEarningsBloc, MyEarningsState>(
//                 builder: (context, state) {
//                   if (state is MyEarningsFailedState) {
//                     return const Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 40,
//                           ),
//                           Text("No Records found"),
//                         ],
//                       ),
//                     );
//                   }
//                   if (state is MyEarningsSuccessState) {
//                     print("AA SS");
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: state.myEarningsModelData.data.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(6.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               boxShadow: const [
//                                 BoxShadow(
//                                   offset: Offset(0, 0),
//                                   blurRadius: 2,
//                                   color: Color.fromARGB(85, 0, 0, 0),
//                                 )
//                               ],
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(18.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         state.myEarningsModelData.data[index]
//                                             .incentiveDate,
//                                         style: GoogleFonts.manrope(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       Text(
//                                         "₹ ${state.myEarningsModelData.data[index].incentiveAmount}",
//                                         style: GoogleFonts.manrope(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   7.ph,
//                                   Text(
//                                     state.myEarningsModelData.data[index]
//                                         .displayText,
//                                     style: GoogleFonts.manrope(
//                                       fontSize: 12,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                   if (state is MyEarningsLoadingState) {
//                     return Shimmer.fromColors(
//                         baseColor: Colors.grey.shade200,
//                         highlightColor: Colors.white,
//                         child: Column(
//                           children: [
//                             for (int i = 0; i < 5; i++)
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   height: 40,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.8,
//                                 ),
//                               ),
//                           ],
//                         ));
//                   }

//                   return const Center(
//                     child: CircularProgressIndicator(
//                       strokeWidth: 3,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
