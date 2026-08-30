import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../utility/text_form_field.dart';
import '../../verification_documents/screens/documents_verification_screen.dart';
import '../logic/select_work_area_bloc.dart';

class SelectWorkAreaScreen extends StatefulWidget {
  final String type;
  final String cityName;
  const SelectWorkAreaScreen(
      {super.key, required this.type, required this.cityName});

  @override
  State<SelectWorkAreaScreen> createState() => _SelectWorkAreaScreenState();
}

class _SelectWorkAreaScreenState extends State<SelectWorkAreaScreen> {
  String _locationId = '';
  // List citiesNamesData = ["Hyderabad", "Bangalore", "Chennai"];

  @override
  void initState() {
    print(widget.cityName);
    super.initState();
    context
        .read<SelectWorkAreaBloc>()
        .add(SelectWorkAreaFetching(cityId: widget.type, searchLetter: ''));
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
        title: Text(
          ConvertText.getTitle("Select Work Area"),
          style: GoogleFonts.manrope(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocConsumer<SelectWorkAreaBloc, SelectWorkAreaState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is NextButtonClickedState) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DocumentVerificationScreen(),
                ));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DeliveryBoyTextFormField(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          onChanged: (textWord) {
                            context
                                .read<SelectWorkAreaBloc>()
                                .add(SelectWorkAreaFetching(
                                  cityId: widget.type,
                                  searchLetter: textWord,
                                ));
                          },
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
                          hint: "Search Your Work Area",
                          hintStyle: GoogleFonts.manrope(
                              color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${ConvertText.getTitle("Areas in")} ${widget.cityName}",
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  BlocBuilder<SelectWorkAreaBloc, SelectWorkAreaState>(
                    builder: (context, state) {
                      // if(state is invalidState(){})
                      if (state is LoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is SelectWorkAreaLoadedState) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.selectWorkAreaModel.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: RadioListTile(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: _locationId ==
                                                state.selectWorkAreaModel
                                                    .data[index].id
                                            ? Colors.black
                                            : Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8)),
                                dense: true,
                                // subtitle: Text('${citiesNamesData[index]}'),
                                activeColor: Colors.black,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding: const EdgeInsets.only(left: 8),
                                toggleable: true,
                                title: Row(
                                  children: [
                                    Text(
                                        state.selectWorkAreaModel.data[index].name,
                                        style: GoogleFonts.manrope(
                                            color: Colors.black)
                                        // _locationId ==
                                        //         state.selectWorkAreaModel
                                        //             .data[index].id
                                        //     ? Colors.green
                                        //     : Colors.black),
                                        ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    // Visibility(
                                    //   visible: true,
                                    //   child: Container(
                                    //     padding: EdgeInsets.all(3),
                                    //     decoration: BoxDecoration(
                                    //       borderRadius:
                                    //           BorderRadius.circular(6),
                                    //       color: Color(0xFF45B3C2),
                                    //     ),
                                    //     child: Text(
                                    //       '${citiesNamesData[index]}',
                                    //       style: GoogleFonts.manrope(
                                    //           fontSize: 10,
                                    //           color: Colors.white),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                                value:
                                    state.selectWorkAreaModel.data[index].id,
                                groupValue: _locationId,
                                onChanged: (v) {
                                  setState(() {
                                    _locationId = v!;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  // const Spacer(),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          color: Colors.white,
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF000000),
            ),
            onPressed: () {
              print("object");
              if (_locationId == '') {
                Fluttertoast.showToast(
                    backgroundColor: Colors.red,
                    msg: "Please select work area");
              } else {
                context.read<SelectWorkAreaBloc>().add(WorkAreasetupEvent(
                    cityId: widget.type, locationId: _locationId));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
