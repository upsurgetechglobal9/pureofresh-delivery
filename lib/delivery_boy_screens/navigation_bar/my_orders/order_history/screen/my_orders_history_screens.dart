import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../../../utility/text_form_field.dart';
import '../../../../new_order/widgets/swiper_button_widget.dart';
import '../logic/bloc/my_order_history_bloc.dart';

class MyOrdersHistoryScreen extends StatefulWidget {
  final String date;
  final String searchType;

  const MyOrdersHistoryScreen(
      {super.key, required this.date, required this.searchType});

  @override
  State<MyOrdersHistoryScreen> createState() => _MyOrdersHistoryScreenState();
}

class _MyOrdersHistoryScreenState extends State<MyOrdersHistoryScreen> {
  final selectShiftKey = GlobalKey<FormState>();

  bool collapse = false;

  @override
  void initState() {
    super.initState();
    context.read<MyOrderHistoryBloc>().add(MyHistoryFetchingEvent(
        date: widget.date, searchType: widget.searchType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
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
            "Order History",
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: BlocBuilder<MyOrderHistoryBloc, MyOrderHistoryState>(
          builder: (context, state) {
            if (state is LoadingStateHistory) {
              return const Center(
                  child: ThemeSpinner(
                size: 50,
                color: Colors.black,
              ));
            } else if (state is MyOrdersHistoryLoadedState) {
              return state.MyOrdersHistoryModeldata.data.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/nodata.png',
                            height: 200,
                            width: 70,
                          ),
                          const CommonProximaNovaTextWidget(
                              text: 'No Data Found'),
                        ],
                      ),
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 2,
                              color: Color.fromARGB(85, 0, 0, 0),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorsData.themeColor,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.MyOrdersHistoryModeldata.date,
                                        style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "₹ ${state.MyOrdersHistoryModeldata.totalEarnings.toString()}",
                                        style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 10),
                                itemCount:
                                    state.MyOrdersHistoryModeldata.data.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 1),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Order Id : ${state.MyOrdersHistoryModeldata.data[index].refId}',
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    state
                                                        .MyOrdersHistoryModeldata
                                                        .data[index]
                                                        .restaurantName,
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    state
                                                        .MyOrdersHistoryModeldata
                                                        .data[index]
                                                        .serviceDateTime,
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "₹ ${state.MyOrdersHistoryModeldata.data[index].earningAmount}",
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                          state
                                                  .MyOrdersHistoryModeldata
                                                  .data[index]
                                                  .dropingLocations
                                                  .isEmpty
                                              ? const SizedBox()
                                              : Text(
                                                  "PickUp Location : ${state.MyOrdersHistoryModeldata.data[index].pickUpFrom}",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          state
                                                  .MyOrdersHistoryModeldata
                                                  .data[index]
                                                  .dropingLocations
                                                  .isEmpty
                                              ? const SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                )
                                              : ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: state
                                                      .MyOrdersHistoryModeldata
                                                      .data[index]
                                                      .dropingLocations
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int indexT) {
                                                    String displayIndex =
                                                        (indexT + 1).toString();
                                                    return Text(
                                                      "Drop Location$displayIndex : ${state.MyOrdersHistoryModeldata.data[index].dropingLocations[indexT].address}",
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    );
                                                  }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
            } else {
              return const Center(
                  child: CommonProximaNovaTextWidget(
                      text: 'Something went wrong please'));
            }
          },
        ));

    // DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     appBar: AppBar(
    //         elevation: 1,
    //         backgroundColor: Colors.white,
    //         // leading: null,
    //         title: Text(
    //           "My Order",
    //           style: GoogleFonts.manrope(
    //             fontSize: 14,
    //             color: Colors.black,
    //             fontWeight: FontWeight.w700,
    //           ),
    //         ),
    //         bottom: TabBar(
    //           indicatorColor: ColorsData.themeColor,
    //           indicatorWeight: 4,
    //           indicatorPadding: EdgeInsets.symmetric(horizontal: 24),
    //           labelColor: Colors.black,
    //           labelStyle: GoogleFonts.manrope(
    //             fontSize: 14,
    //             color: Colors.black,
    //             fontWeight: FontWeight.w700,
    //           ),
    //           tabs: const [
    //             Tab(
    //               child: Text("This Week"),
    //             ),
    //             Tab(
    //               child: Text("Next Week"),
    //             ),
    //           ],
    //         )),
    //     body: TabBarView(
    //       children: [
    //         thisWeek(),
    //         Icon(
    //           Icons.heart_broken,
    //           color: Colors.red,
    //           size: 50,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

//----------This week-----------//
  Widget thisWeek() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 2,
                color: Color.fromARGB(85, 0, 0, 0),
              )
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          ),
          child: GFAccordion(
              margin: const EdgeInsets.all(0),
              onToggleCollapsed: (v) {},
              contentBorder: Border.all(color: Colors.grey.shade200),
              titleBorderRadius:
                  //  collapse
                  //     ?
                  const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))
              // : BorderRadius.circular(12),
              ,
              titlePadding: const EdgeInsets.all(16),
              expandedTitleBackgroundColor: ColorsData.themeColor,
              contentBackgroundColor: Colors.white,
              titleChild: Text('Monday, 23 May',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  )),
              contentChild: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('07:00 AM-10:00 AM',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                  ),
                  Text('Shift Over',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: Colors.black,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('02:00 PM-04:00 PM',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: Colors.black,
                        )),
                  ),
                  Text('Shift Over',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: Colors.black,
                      )),
                  GestureDetector(
                    onTap: () {
                      cancelShift();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('02:00 PM-04:00 PM',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: Colors.black,
                              )),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('03:00 PM-05:00 PM',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: Colors.grey,
                            )),
                        GestureDetector(
                          onTap: () {
                            addShift();
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_circle_outline_rounded,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text('ADD',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  void cancelShift() {
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // height: 260,
          child: AnimatedPadding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 150),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 900, minHeight: 150),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "05:00 PM- 08:00 PM",
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Mon 23 May",
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Swipperbuttonwidget(
                              onSwipeFun: () {
                                Navigator.pop(context);
                                setState(() {
                                  // buttonTitle = "Order Accepted";
                                });
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => NearToPickUp(
                                //         type: 'submitOTP',
                                //       ),
                                //     ));
                              },
                              buttonTitle: "CANCEL SHIFT"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void addShift() {
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // height: 260,
          child: AnimatedPadding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: const Duration(milliseconds: 150),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 900, minHeight: 150),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Shift",
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                color: ColorsData.themeColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                      child: Column(
                        children: [
                          Form(
                              key: selectShiftKey,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: DeliveryBoyTextFormField(
                                      obscureText: true,
                                      isDense: true,
                                      hint: "From",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: DeliveryBoyTextFormField(
                                      isDense: true,
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      hint: "To",
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 6,
                          ),
                          Swipperbuttonwidget(
                              onSwipeFun: () {
                                Navigator.pop(context);
                                setState(() {
                                  // buttonTitle = "Order Accepted";
                                });
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => NearToPickUp(
                                //         type: 'submitOTP',
                                //       ),
                                //     ));
                              },
                              buttonTitle: "ADD SHIFT"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget thisWeek() {
  //   return ListView.builder(
  //     itemCount: 3,
  //     itemBuilder: (context, index) => ExpansionTile(
  //       expandedAlignment: Alignment.topLeft,
  //       title: Text("Monday, 22 May"),
  //       children: [
  //         Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(0),
  //               child: ListTile(
  //                 minVerticalPadding: 0,
  //                 title: Text("07:00 AM-10:00 AM"),
  //                 subtitle: Text("Shift Over"),
  //               ),
  //             ),
  //             ListTile(
  //               title: Text("07:00 AM-10:00 AM"),
  //               subtitle: Text("Shift Over"),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

//----------Next week-----------//
}
