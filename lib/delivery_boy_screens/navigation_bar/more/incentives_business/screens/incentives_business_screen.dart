import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/incentives_business/repository/incentives_repository.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../commons/ConvertText.dart';
import '../logic/incentives_business_bloc.dart';

class IncentivesMoreScreen extends StatefulWidget {
  const IncentivesMoreScreen({super.key});

  @override
  State<IncentivesMoreScreen> createState() => _IncentivesMoreScreenState();
}

class _IncentivesMoreScreenState extends State<IncentivesMoreScreen> {
  bool bonus = false;
  bool viewConditions = false;
  String conditionsId = '';
  late IncentivesBusinessBloc incentivesBloc;
  @override
  void initState() {
    super.initState();
    incentivesBloc =
        IncentivesBusinessBloc(incentivesReposotory: IncentivesReposotory())
          ..add(const IncentivesFetchingEvent(timeType: "Day"));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MultiBlocProvider(
        providers: [BlocProvider.value(value: incentivesBloc)],
        child: Scaffold(
            appBar: AppBar(
                elevation: 1,
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
                  ConvertText.getTitle("Incentives"),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                bottom: TabBar(
                    onTap: (value) {
                      switch (value) {
                        case 0:
                          incentivesBloc.add(
                              const IncentivesFetchingEvent(timeType: "Day"));
                          break;
                        case 1:
                          incentivesBloc.add(
                              const IncentivesFetchingEvent(timeType: "Week"));
                          break;
                        case 2:
                          incentivesBloc.add(
                              const IncentivesFetchingEvent(timeType: "Month"));
                          break;
                        case 3:
                          incentivesBloc.add(const IncentivesFetchingEvent(
                              timeType: "Festive"));
                          break;
                      }

                      // if (value == 0) {
                      //   context
                      //       .read<IncentivesBusinessBloc>()
                      //       .add(IncentivesFetchingEvent(timeType: "Day"));
                      // }
                      // if (value == 1) {
                      //   context
                      //       .read<IncentivesBusinessBloc>()
                      //       .add(IncentivesFetchingEvent(timeType: "Week"));
                      // }
                      // if (value == 2) {
                      //   context
                      //       .read<IncentivesBusinessBloc>()
                      //       .add(IncentivesFetchingEvent(timeType: "Month"));
                      // }
                      // if (value == 3) {
                      //   context
                      //       .read<IncentivesBusinessBloc>()
                      //       .add(IncentivesFetchingEvent(timeType: "Festive"));
                      // }
                      // print(value);
                    },
                    indicatorColor: ColorsData.themeColor,
                    indicatorWeight: 4,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
                    labelColor: Colors.black,
                    labelStyle: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs:
                        // [
                        //   Tab(
                        //     child: Text(
                        //       "One Day",
                        //       style: GoogleFonts.manrope(
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //   ),
                        //   Tab(
                        //     child: Text(
                        //       "One Week",
                        //       style: GoogleFonts.manrope(
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //   ),
                        //   Tab(
                        //     child: Text(
                        //       "One Month",
                        //       style: GoogleFonts.manrope(
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //   ),
                        // ]
                        bonus
                            ? [
                                Tab(
                                  child: Text(
                                    ConvertText.getTitle("One Day"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    ConvertText.getTitle("One Week"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    ConvertText.getTitle("One Month"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    ConvertText.getTitle("Season"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ]
                            : [
                                Tab(
                                  child: Text(
                                    ConvertText.getTitle("One Day"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    ConvertText.getTitle("One Week"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    ConvertText.getTitle("One Month"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ])),
            body: bonus
                ? TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        child: BlocBuilder<IncentivesBusinessBloc,
                            IncentivesBusinessState>(
                          builder: (context, state) {
                            if (state.incentivesLoading) {
                              return const Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            //  else if (state
                            //     .incentivesDataList.data.conditions.isNotEmpty) {
                            //   return Text(state.incentivesDataList.status);
                            // }
                            else {
                              return Center(
                                  child: Text(
                                ConvertText.getTitle("No Records found"),
                              ));
                            }
                          },
                        ),
                      ),
                      Container(
                        child: BlocBuilder<IncentivesBusinessBloc,
                            IncentivesBusinessState>(
                          builder: (context, state) {
                            if (state.incentivesLoading) {
                              return const Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            //  else if (state
                            //     .incentivesDataList.conditions.isNotEmpty) {
                            //   return Text(state.incentivesDataList.id);
                            // }
                            else {
                              return Center(
                                  child: Text(
                                ConvertText.getTitle("No Records found"),
                              ));
                            }
                          },
                        ),
                      ),
                      Container(
                        child: BlocBuilder<IncentivesBusinessBloc,
                            IncentivesBusinessState>(
                          builder: (context, state) {
                            if (state.incentivesLoading) {
                              return const Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            //  else if (state
                            //     .incentivesDataList.plans.isNotEmpty) {
                            //   return Text(state.incentivesDataList.title);
                            // }
                            else {
                              return Center(
                                  child: Text(
                                ConvertText.getTitle("No Records found"),
                              ));
                            }
                          },
                        ),
                      ),
                      Container(
                        child: BlocBuilder<IncentivesBusinessBloc,
                            IncentivesBusinessState>(
                          builder: (context, state) {
                            if (state.incentivesLoading) {
                              return const Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            //  else if (state
                            //     .incentivesDataList.conditions.isNotEmpty) {
                            //   return Text(state.incentivesDataList.status);
                            // }
                            else {
                              return Center(
                                  child: Text(
                                ConvertText.getTitle("No Records found"),
                              ));
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   itemCount: 2,
                      //   itemBuilder: (context, index) {
                      //     return Row(
                      //       children: [
                      //         Text("single "),
                      //         SizedBox(
                      //           height: 20,
                      //           width: 300,
                      //           child: ListView.builder(
                      //             scrollDirection: Axis.horizontal,
                      //             shrinkWrap: true,
                      //             itemCount: 12,
                      //             itemBuilder: (context, index) {
                      //               return Text("data  ");
                      //             },
                      //           ),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),
                      BlocBuilder<IncentivesBusinessBloc,
                          IncentivesBusinessState>(
                        builder: (context, state) {
                          if (state.incentivesLoading) {
                            return const Center(
                              heightFactor: 1,
                              widthFactor: 1,
                              child: SizedBox(
                                height: 26,
                                width: 26,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          } else if (state.incentivesDataList.data.isNotEmpty) {
                            return oneDay(state);
                          } else {
                            return Center(
                                child: Text(
                              ConvertText.getTitle("No Records found"),
                            ));
                          }
                        },
                      ),
                      Container(
                        child: BlocBuilder<IncentivesBusinessBloc,
                            IncentivesBusinessState>(
                          builder: (context, state) {
                            if (state.incentivesLoading) {
                              return const Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            } else if (state
                                .incentivesDataList.data.isNotEmpty) {
                              return oneDay(state);
                            } else {
                              return Center(
                                  child: Text(
                                ConvertText.getTitle("No Records found"),
                              ));
                            }
                          },
                        ),
                      ),
                      Container(
                        child: BlocBuilder<IncentivesBusinessBloc,
                            IncentivesBusinessState>(
                          builder: (context, state) {
                            if (state.incentivesLoading) {
                              return const Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            if (state.incentivesDataList.data.isNotEmpty) {
                              return oneDay(state);
                            } else {
                              return Center(
                                child: Text(
                                    ConvertText.getTitle("No Records found")),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )

            // bonus
            //     ? TabBarView(
            //         physics: const NeverScrollableScrollPhysics(),
            //         children: [
            //           Text(state.incentivesModeldata.message.toString()),
            //           Text(state.incentivesModeldata.message.toString()),
            //           Icon(
            //             Icons.heart_broken,
            //             color: Color.fromARGB(255, 219, 194, 192),
            //             size: 50,
            //           ),
            //           Icon(
            //             Icons.heart_broken,
            //             color: Color.fromARGB(255, 40, 7, 159),
            //             size: 50,
            //           )
            //         ],
            //       )
            //     : TabBarView(
            //         physics: const NeverScrollableScrollPhysics(),
            //         children: [
            //           oneDay(state),
            //           weeklyDay(),
            //           monthlyDay(),
            //         ],
            //       );
            ),
      ),
    );
  }

  Widget oneDay(IncentivesBusinessState state) {
    return Container(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: state.incentivesDataList.data.length,
        shrinkWrap: true,
        itemBuilder: (context, main) {
          List<bool> viewConditionsList = List.generate(
              state.incentivesDataList.data.length, (index) => false);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 2,
                        color: Color.fromARGB(32, 0, 0, 0),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      state.incentivesDataList.data[main].title,
                      style: GoogleFonts.manrope(
                          fontSize: 16,
                          color: ColorsData.themeColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "${state.incentivesDataList.data[main].fromtime} - ${state.incentivesDataList.data[main].totime}",
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              left: BorderSide(),
                              top: BorderSide(),
                              bottom: BorderSide())),
                      child: IntrinsicHeight(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: IntrinsicWidth(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        child: Text(
                                            ConvertText.getTitle(
                                                "Deliverd Orders"),
                                            style: GoogleFonts.manrope(
                                              fontSize: 13,
                                            )),
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                      ),
                                      Text(ConvertText.getTitle("Guarantee"),
                                          style: GoogleFonts.manrope(
                                            fontSize: 13,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                color: Colors.black,
                              ),
                              for (int i = 0;
                                  i <
                                      state.incentivesDataList.data[main].plans
                                          .length;
                                  i++)
                                Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      right: BorderSide(),
                                      // top: BorderSide(),
                                      // bottom: BorderSide()
                                    )),
                                    // width: 50,
                                    child: IntrinsicWidth(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: Text(
                                                state
                                                    .incentivesDataList
                                                    .data[main]
                                                    .plans[i]
                                                    .noOfOrders,
                                                style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.black,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 6, right: 6, left: 6),
                                              child: Text(
                                                  "₹ ${state.incentivesDataList.data[main].plans[i].incentiveAmount}",
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              // SizedBox(
                              //   height: 90,
                              //   width: 200,
                              //   child: ListView.builder(
                              //     scrollDirection: Axis.horizontal,
                              //     shrinkWrap: true,
                              //     itemCount: state
                              //         .incentivesDataList.data[main].plans.length,
                              //     itemBuilder: (context, pIndex) {
                              //       return Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             vertical: 18.0),
                              //         child: Row(
                              //           children: [
                              //             const SizedBox(
                              //               width: 3,
                              //             ),
                              //             Column(
                              //               children: [
                              //                 Text(
                              //                     state
                              //                         .incentivesDataList
                              //                         .data[main]
                              //                         .plans[pIndex]
                              //                         .noOfOrders,
                              //                     style: GoogleFonts.manrope(
                              //                         fontSize: 12,
                              //                         fontWeight:
                              //                             FontWeight.bold)),
                              //                 const Divider(
                              //                   color: Colors.black,
                              //                 ),
                              //                 Text(
                              //                     "₹ ${state.incentivesDataList.data[main].plans[pIndex].incentiveAmount}",
                              //                     style: GoogleFonts.manrope(
                              //                         fontSize: 12,
                              //                         fontWeight:
                              //                             FontWeight.bold)),
                              //               ],
                              //             ),
                              //             const SizedBox(
                              //               width: 6,
                              //             )
                              //           ],
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          viewConditions = !viewConditions;
                          conditionsId = state.incentivesDataList.data[main].id;
                        });
                      },
                      child: Row(
                        children: [
                          Text(ConvertText.getTitle("View Conditions"),
                              style: GoogleFonts.manrope(
                                color: ColorsData.themeColor,
                                fontSize: 14,
                              )),
                          conditionsId ==
                                      state.incentivesDataList.data[main].id &&
                                  viewConditions
                              ? const Icon(Icons.keyboard_arrow_down_rounded)
                              : const Icon(Icons.keyboard_arrow_right_rounded)
                        ],
                      ),
                    ),
                    conditionsId == state.incentivesDataList.data[main].id &&
                            viewConditions
                        ? state.incentivesDataList.data[main].conditions
                                .isNotEmpty
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.incentivesDataList.data[main]
                                    .conditions.length,
                                itemBuilder: (context, cIndex) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    ColorsData.themeColor,
                                                child: const Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white,
                                                )),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              " ${state.incentivesDataList.data[main].conditions[cIndex].conditions}",
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: Text("No conditions listed")),
                              )
                        : const SizedBox.shrink()
                  ],
                )),
          );
        },
      ),
    );
  }
}
