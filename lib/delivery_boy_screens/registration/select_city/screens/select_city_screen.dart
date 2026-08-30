import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../commons/shared_prefs.dart';
import '../../../../utility/text_form_field.dart';
import '../../../login/screens/welcome_screen.dart';
import '../../select_work_area/screens/select_work_area_screens.dart';
import '../logic/select_city_bloc.dart';

class SelectCityScreen extends StatefulWidget {
  final String? type;
  const SelectCityScreen({super.key, this.type});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  String citieId = '';
  dynamic citiName;
  // List topCities = ["hyd", "vijay", "ramavarm", "kakinada"];

  // late SelectCityBloc citiesBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // citiesBloc = SelectCityBloc(selectCityRepository: SelectCityRepository())
    //   ..add(CitiesFetchingEvent());
    context
        .read<SelectCityBloc>()
        .add(const CitiesFetchingEvent(searchKeyword: ''));
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
          ConvertText.getTitle("Select City"),
          style: GoogleFonts.manrope(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocConsumer<SelectCityBloc, SelectCityState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        // bloc: citiesBloc,
        builder: (context, state) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BlocBuilder<SelectCityBloc, SelectCityState>(
                    builder: (context, state) {
                      if (state is CitiesLoadedState) {
                        return DeliveryBoyTextFormField(
                          onChanged: (keyword) {
                            context.read<SelectCityBloc>().add(
                                CitiesFetchingEvent(searchKeyword: keyword));
                            // context.read<SelectCityBloc>().add(
                            //     FilterCitiesListEvent(
                            //         overallCitiesData: state.selectCityModel,
                            //         searchKeyword: keyword));
                          },
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          // suffixIcon: Padding(
                          //   padding: EdgeInsets.all(10.0),
                          //   child: CircleAvatar(
                          //       backgroundColor: Colors.green.shade100,
                          //       radius: 5,
                          //       child: Icon(
                          //         Icons.gps_fixed_rounded,
                          //         color: Colors.green.shade300,
                          //         size: 16,
                          //       )),
                          // ),
                          isDense: true,
                          hint: ConvertText.getTitle("Search Your Work City"),
                          hintStyle: GoogleFonts.manrope(
                              color: Colors.grey, fontSize: 12),
                        );
                      }
                      return DeliveryBoyTextFormField(
                        onChanged: (p0) {
                          print("");
                        },
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        // suffixIcon: Padding(
                        //   padding: EdgeInsets.all(10.0),
                        //   child: CircleAvatar(
                        //       backgroundColor: Colors.green.shade100,
                        //       radius: 5,
                        //       child: Icon(
                        //         Icons.gps_fixed_rounded,
                        //         color: Colors.green.shade300,
                        //         size: 16,
                        //       )),
                        // ),
                        isDense: true,
                        hint: ConvertText.getTitle("Search Your Wordk City"),
                        hintStyle: GoogleFonts.manrope(
                            color: Colors.grey, fontSize: 12),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ConvertText.getTitle("Top Cities"),
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  BlocBuilder<SelectCityBloc, SelectCityState>(
                    builder: (context, state) {
                      if (state is CitiesLoadedState) {
                        // topCities.add(state.selectCityModel.data);
                        // topCities = state.selectCityModel.data.results;
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.66,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                state.selectCityModel.data.results.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                horizontalTitleGap: 0,
                                contentPadding: const EdgeInsets.all(0),
                                leading: Icon(
                                  Icons.location_on_outlined,
                                  color: citieId ==
                                          state.selectCityModel.data
                                              .results[index].id
                                      ? ColorsData.themeColor
                                      : Colors.grey,
                                ),
                                title: Text(
                                  state
                                      .selectCityModel.data.results[index].name,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: Radio(
                                  activeColor: citieId ==
                                          state.selectCityModel.data
                                              .results[index].id
                                      ? ColorsData.themeColor
                                      : Colors.grey,
                                  toggleable: true,
                                  value: state
                                      .selectCityModel.data.results[index].id,
                                  groupValue: citieId,
                                  onChanged: (v) {
                                    if (mounted) {
                                      setState(() {
                                        citieId = v!;
                                        citiName = state.selectCityModel.data
                                            .results[index].name;
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        color: ColorsData.themeColor,
                      ));
                    },
                  ),
                  // Spacer(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          print("object");
                          if (citieId == '') {
                            Fluttertoast.showToast(
                                backgroundColor: Colors.red,
                                msg: "Please select city");
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectWorkAreaScreen(
                                  type: citieId,
                                  cityName: citiName,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          ConvertText.getTitle("Next"),
                          style: GoogleFonts.manrope(
                            letterSpacing: 0.8,
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),

                  // Text(topCities.length.toString()),
                  // TextFormField(
                  //   onChanged: (value) {
                  //   },
                  // ),
                  // Container(
                  //   height: 60,
                  //   child: ListView.builder(
                  //     physics: BouncingScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: topCities.length,
                  //     itemBuilder: (context, index) {
                  //       return Text("${topCities[index]}");
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// bool search = false;
//   List<dynamic> searchList = [];
//   // List<String> cities = ["one", "One", "oNe", "me", "ram"];

//   selectLoctionManuallyBottomsheet(BuildContext context) {
  //   location.text = "";
  //   search = false;
  //   searchList = [];
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       isDismissible: false,
  //       context: context,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(20),
  //         ),
  //       ),
  //       builder: (context) {
  //         return Padding(
  //           padding: MediaQuery.of(context).viewInsets,
  //           child: StatefulBuilder(
  //               builder: (context, StateSetter myState) => Container(
  //                     child: Form(
  //                       key: _formKey,
  //                       child: Container(
  //                         height: MediaQuery.of(context).size.height * 0.5,
  //                         padding:
  //                             EdgeInsets.only(top: 10, right: 25, left: 25),
  //                         child: SingleChildScrollView(
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text(
  //                                       _langController
  //                                           .changedLang.selectLocation,

  //                                       // "Select Location",
  //                                       style: GoogleFonts.poppins(
  //                                         textStyle: TextStyle(
  //                                             color: ColorsData.headingsText,
  //                                             fontSize: 18,
  //                                             fontWeight: FontWeight.w400),
  //                                       )),
  //                                   IconButton(
  //                                     icon: const Icon(Icons.close),
  //                                     onPressed: () => Navigator.pop(context),
  //                                   )
  //                                 ],
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     left: 0.0, right: 0, top: 0),
  //                                 child: TextFormField(
  //                                   // readOnly: true,
  //                                   controller: location,
  //                                   cursorColor: ColorsData.blackColor,
  //                                   style: GoogleFonts.poppins(
  //                                     textStyle: TextStyle(
  //                                       fontSize: 16.0,
  //                                       color: Color(0xFF04071E),
  //                                     ),
  //                                   ),
  //                                   decoration: InputDecoration(
  //                                     fillColor: Colors.grey.withOpacity(0.1),
  //                                     filled: true,
  //                                     focusColor: ColorsData.searchFieldColor,
  //                                     prefixIcon: Padding(
  //                                       padding: const EdgeInsets.only(left: 0),
  //                                       child: Icon(
  //                                         Icons.location_pin,
  //                                         color: Color(0xFF808080),
  //                                         size: 18,
  //                                       ),
  //                                     ),
  //                                     suffixIcon: location.text.length > 2
  //                                         ? Container(
  //                                             // color: Colors.red,
  //                                             child: IconButton(
  //                                               icon: Icon(Icons.close),
  //                                               iconSize: 14,
  //                                               padding: EdgeInsets.all(0),
  //                                               onPressed: () {
  //                                                 location.text = "";
  //                                                 myState(() {
  //                                                   search = false;
  //                                                 });
  //                                               },
  //                                               color: Color(0xFF808080),
  //                                             ),
  //                                           )
  //                                         : Container(),
  //                                     suffixIconConstraints:
  //                                         BoxConstraints(maxWidth: 25),
  //                                     prefixIconConstraints:
  //                                         BoxConstraints(maxWidth: 180),
  //                                     enabledBorder: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(13),
  //                                         borderSide: BorderSide.none),
  //                                     errorBorder: OutlineInputBorder(
  //                                       borderRadius: BorderRadius.circular(13),
  //                                       borderSide: BorderSide.none,
  //                                     ),
  //                                     border: InputBorder.none,
  //                                     hintText: _langController
  //                                         .changedLang.searchForYourCity,
  //                                     hintStyle: GoogleFonts.poppins(
  //                                       textStyle: TextStyle(
  //                                           color: Color(0xFF808080),
  //                                           fontSize: 12),
  //                                     ),
  //                                     contentPadding: EdgeInsets.only(
  //                                       top: 16,
  //                                       bottom: 16,
  //                                     ),
  //                                     focusedBorder: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(13),
  //                                         borderSide: BorderSide.none),
  //                                     focusedErrorBorder: OutlineInputBorder(
  //                                       borderRadius: BorderRadius.circular(13),
  //                                       borderSide: BorderSide.none,
  //                                     ),
  //                                   ),
  //                                   onChanged: (val) async {
  //                                     myState(() {
  //                                       searchList.clear();
  //                                     });

  //                                     if (val.length >= 1) {
  //                                       locationController
  //                                           .getManuallySelectedCitiesList
  //                                           .forEach((element) {
  //                                         if (element['cities']
  //                                                 .toLowerCase()
  //                                                 .startsWith(
  //                                                     val.toLowerCase()) ||
  //                                             element['cities']
  //                                                 .contains(val.toString())) {
  //                                           myState(() {
  //                                             search = true;
  //                                           });
  //                                           print(element);
  //                                           String me =
  //                                               element['cities'].toString();

  //                                           myState(() {
  //                                             searchList.add(element);
  //                                           });
  //                                         }
  //                                       });
  //                                     } else {
  //                                       myState(() {
  //                                         searchList.clear();
  //                                         search = false;
  //                                       });
  //                                     }
  //                                     // } else {
  //                                     //   print("va222....$val");

  //                                     //   myState(() {
  //                                     //     // searchList.clear();
  //                                     //     search = false;
  //                                     //   });
  //                                     // }
  //                                   },
  //                                   onTap: () async {},
  //                                   validator: (text) {
  //                                     if (text == null || text.isEmpty) {
  //                                       return 'Can\'t be empty';
  //                                     }
  //                                     return null;
  //                                   },
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 height: 10,
  //                               ),
  //                               Text(
  //                                   _langController
  //                                       .changedLang.chooseYourLocation,
  //                                   // "Choose Your Location",
  //                                   style: GoogleFonts.poppins(
  //                                     textStyle: TextStyle(
  //                                         color: Colors.red,
  //                                         fontSize: 14,
  //                                         fontWeight: FontWeight.w400),
  //                                   )),
  //                               (search == true)
  //                                   ? Container(
  //                                       height:
  //                                           MediaQuery.of(context).size.height *
  //                                               0.405,
  //                                       child: ListView.builder(
  //                                           scrollDirection: Axis.vertical,
  //                                           itemCount: searchList.length,
  //                                           itemBuilder: (context, ind) {
  //                                             return GestureDetector(
  //                                               behavior:
  //                                                   HitTestBehavior.translucent,
  //                                               onTap: () {
  //                                                 myState(() {
  //                                                   currentCityInd = ind;
  //                                                 });
  //                                                 Timer(
  //                                                     Duration(
  //                                                         milliseconds: 500),
  //                                                     () {
  //                                                   Navigator.pop(context);
  //                                                   Constants.prefs!.setString(
  //                                                       "location",
  //                                                       searchList[ind]
  //                                                           ['cities']);
  //                                                   Constants.prefs!.setString(
  //                                                       "lat",
  //                                                       searchList[ind]
  //                                                           ['latitude']);
  //                                                   Constants.prefs!.setString(
  //                                                       "long",
  //                                                       searchList[ind]
  //                                                           ['longitude']);
  //                                                   Navigator.pushReplacement(
  //                                                     context,
  //                                                     MaterialPageRoute(
  //                                                         builder: (context) =>
  //                                                             TabbarScreen()),
  //                                                   );
  //                                                 });
  //                                               },
  //                                               child: Column(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   SizedBox(
  //                                                     height: 10,
  //                                                   ),
  //                                                   Row(
  //                                                     mainAxisAlignment:
  //                                                         MainAxisAlignment
  //                                                             .spaceBetween,
  //                                                     children: [
  //                                                       Text(
  //                                                           searchList[ind][
  //                                                               'cities'], // locationController.getCitiesList[i]['city'],
  //                                                           style: GoogleFonts
  //                                                               .poppins(
  //                                                             textStyle: TextStyle(
  //                                                                 color: ColorsData
  //                                                                     .GrayTextColor,
  //                                                                 fontSize: 14,
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w400),
  //                                                           )),
  //                                                       if (currentCityInd ==
  //                                                           ind)
  //                                                         Icon(
  //                                                           Icons.done,
  //                                                           color: ColorsData
  //                                                               .appThemeColor,
  //                                                         )
  //                                                     ],
  //                                                   ),
  //                                                   Divider(
  //                                                     thickness: 1,
  //                                                     color: Colors.black12
  //                                                         .withOpacity(0.1),
  //                                                   )
  //                                                 ],
  //                                               ),
  //                                             );
  //                                           }),
  //                                     )
  //                                   : Container(
  //                                       height:
  //                                           MediaQuery.of(context).size.height *
  //                                               0.405,
  //                                       child: ListView.builder(
  //                                           scrollDirection: Axis.vertical,
  //                                           itemCount: locationController
  //                                               .getManuallySelectedCitiesList
  //                                               .length,
  //                                           itemBuilder: (context, ind) {
  //                                             return GestureDetector(
  //                                               behavior:
  //                                                   HitTestBehavior.translucent,
  //                                               onTap: () {
  //                                                 myState(() {
  //                                                   currentCityInd = ind;
  //                                                 });
  //                                                 Timer(
  //                                                     Duration(
  //                                                         milliseconds: 500),
  //                                                     () {
  //                                                   Navigator.pop(context);
  //                                                   Constants.prefs!.setString(
  //                                                       "location",
  //                                                       locationController
  //                                                               .getManuallySelectedCitiesList[
  //                                                           ind]['cities']);
  //                                                   Constants.prefs!.setString(
  //                                                       "lat",
  //                                                       locationController
  //                                                               .getManuallySelectedCitiesList[
  //                                                           ind]['latitude']);
  //                                                   Constants.prefs!.setString(
  //                                                       "long",
  //                                                       locationController
  //                                                               .getManuallySelectedCitiesList[
  //                                                           ind]['longitude']);
  //                                                   Navigator.pushReplacement(
  //                                                     context,
  //                                                     MaterialPageRoute(
  //                                                         builder: (context) =>
  //                                                             TabbarScreen()),
  //                                                   );
  //                                                 });
  //                                               },
  //                                               child: Column(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   SizedBox(
  //                                                     height: 10,
  //                                                   ),
  //                                                   Row(
  //                                                     mainAxisAlignment:
  //                                                         MainAxisAlignment
  //                                                             .spaceBetween,
  //                                                     children: [
  //                                                       Text(
  //                                                           locationController
  //                                                                   .getManuallySelectedCitiesList[
  //                                                               ind]['cities'],
  //                                                           style: GoogleFonts
  //                                                               .poppins(
  //                                                             textStyle: TextStyle(
  //                                                                 color: ColorsData
  //                                                                     .GrayTextColor,
  //                                                                 fontSize: 14,
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w400),
  //                                                           )),
  //                                                       if (currentCityInd ==
  //                                                           ind)
  //                                                         Icon(
  //                                                           Icons.done,
  //                                                           color: ColorsData
  //                                                               .appThemeColor,
  //                                                         )
  //                                                     ],
  //                                                   ),
  //                                                   Divider(
  //                                                     thickness: 1,
  //                                                     color: Colors.black12
  //                                                         .withOpacity(0.1),
  //                                                   )
  //                                                 ],
  //                                               ),
  //                                             );
  //                                           }),
  //                                     )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   )),
  //         );
  //       });
  // }