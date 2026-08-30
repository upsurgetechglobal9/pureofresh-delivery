import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../utility/colors_data.dart';
import '../logic/my_orders_bloc.dart';
import '../order_history/screen/my_orders_history_screens.dart';

class ThisWeekScreenTab extends StatefulWidget {
  final String type;
  final String searchType;

  const ThisWeekScreenTab(
      {super.key, required this.type, required this.searchType});

  @override
  State<ThisWeekScreenTab> createState() => _ThisWeekScreenTabState();
}

class _ThisWeekScreenTabState extends State<ThisWeekScreenTab> {
  @override
  void initState() {
    super.initState();

    context.read<MyOrdersBloc>().add(MyOrdersdetailsFetchingEvent(
        type: widget.type, searchType: widget.searchType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyOrdersBloc, MyOrdersState>(
        builder: (context, state) {
          if (state is FailedState) {
            return Center(child: Text(state.errorData));
          } else if (state is MyOrdersDetailsLoadedState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Column(
                          children: [
                            // Text(
                            //   "From to date need to implement",
                            //   style: GoogleFonts.manrope(
                            //     fontSize: 12,
                            //     color: Colors.black,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                    Container(
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
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ConvertText.getTitle("Total Earnings"),
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                                "${state.myOrdersDetailsModeldata.data.totalEarnings.fromDate} - ${state.myOrdersDetailsModeldata.data.totalEarnings.toDate}",
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: Colors.black,
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                "₹ ${state.myOrdersDetailsModeldata.data.totalEarnings.totalEarning}",
                                style: GoogleFonts.manrope(
                                  fontSize: 26,
                                  color: ColorsData.themeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // Text(
                            //     "${state.myOrdersDetailsModeldata.data.totalEarnings.dutyTimings} on Duty",
                            //     style: GoogleFonts.manrope(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //     )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(children: <Widget>[
                                const Expanded(child: Divider()),
                                Text(ConvertText.getTitle("Earning History"),
                                    style: GoogleFonts.manrope(
                                      color: Colors.black,
                                    )),
                                const Expanded(child: Divider()),
                              ]),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(ConvertText.getTitle("Order Earnings"),
                                    style: GoogleFonts.manrope(
                                      color: Colors.black,
                                    )),
                                Text(
                                    "₹ ${state.myOrdersDetailsModeldata.data.totalEarnings.earnings.toString()}"),
                              ],
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ConvertText.getTitle("Referral amount"),
                                      style: GoogleFonts.manrope(
                                        color: Colors.black,
                                      )),
                                  Text(
                                      "₹ ${state.myOrdersDetailsModeldata.data.totalEarnings.incentives.toString()}"),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(ConvertText.getTitle("Customer Tips"),
                                    style: GoogleFonts.manrope(
                                      color: Colors.black,
                                    )),
                                Text(
                                    "₹ ${state.myOrdersDetailsModeldata.data.totalEarnings.tips.toString()}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            ConvertText.getTitle("Day Wise"),
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          state.myOrdersDetailsModeldata.data.results.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyOrdersHistoryScreen(
                                      date: state.myOrdersDetailsModeldata.data
                                          .results[index].date,
                                      searchType: state.myOrdersDetailsModeldata
                                          .data.results[index].type),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                            ),
                            child: Container(
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonProximaNovaTextWidget(
                                            text: state.myOrdersDetailsModeldata
                                                .data.results[index].type),
                                        CommonProximaNovaTextWidget(
                                          text: state
                                              .myOrdersDetailsModeldata
                                              .data
                                              .results[index]
                                              .displayServiceDate,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    )),
                                    Row(
                                      children: [
                                        Text(
                                          '₹ ${state.myOrdersDetailsModeldata.data.results[index].earnings}',
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                        5.pw,
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: Color(0xff878787),
                                        )
                                      ],
                                    ),
                                  ],
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
          }

          return const Center(
            child: ThemeSpinner(),
          );
        },
      ),
    );
  }
}
