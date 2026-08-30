import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../utility/colors_data.dart';
import '../logic/my_orders_bloc.dart';
import '../order_history/screen/my_orders_history_screens.dart';

class CustomScreenTab extends StatefulWidget {
  final String searchType;
  const CustomScreenTab({
    super.key,
    required this.searchType,
  });

  @override
  State<CustomScreenTab> createState() => _CustomScreenTabState();
}

class _CustomScreenTabState extends State<CustomScreenTab> {
  TextEditingController fromController = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();
  // String? fromDate;
  DateTime fromDate = DateTime.now();

  int? start;
  bool iscalendar = false;
  @override
  void initState() {
    fromController.clear();
    fromController.text = '';
    todatecontroller.text = '';
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
    todatecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ConvertText.getTitle("From"),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                              onSurface: Colors.transparent,
                              primary: ColorsData.themeColor,
                            )),
                            child: TextFormField(
                              controller: fromController,
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 8),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.grey.shade400),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8)),
                                hintText: "Select Date",
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                suffixIcon: Icon(
                                  Icons.calendar_month_rounded,
                                  size: 20,
                                  color: ColorsData.themeColor,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onTap: () async {
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime.now(),
                                ).then(
                                  (value) =>
                                      value != null ? fromDate = value : null,
                                );
                                setState(() {
                                  DateTime now = fromDate;
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy').format(now);
                                  // // selectedToDate = val;
                                  fromController.text = formattedDate;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  // selectedToDate = val;
                                  fromController.text = val;
                                });
                              },
                              onSaved: (val) => print(val),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ConvertText.getTitle("To"),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        BlocConsumer<MyOrdersBloc, MyOrdersState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /**safedoor theme wrape theme widget */
                                    Theme(
                                        data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                          onSurface: Colors.transparent,
                                          primary: ColorsData.themeColor,
                                        )),
                                        child: TextFormField(
                                          controller: todatecontroller,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(left: 8),
                                            fillColor: Colors.white,
                                            filled: true,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.grey.shade400),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade400),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            hintText: "Select Date",
                                            hintStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            suffixIcon: Icon(
                                              Icons.calendar_month_rounded,
                                              size: 20,
                                              color: ColorsData.themeColor,
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          onTap: () async {
                                            if (fromController
                                                .text.isNotEmpty) {
                                              await showDatePicker(
                                                context: context,
                                                initialDate: fromDate,
                                                firstDate: fromDate,
                                                lastDate: DateTime.now(),
                                              ).then((value) {
                                                todatecontroller.text =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(value!);
                                                context.read<MyOrdersBloc>().add(
                                                    MyCustomOrdersdetailsFetchingEvent(
                                                        type: "custom",
                                                        fromDate:
                                                            fromController.text,
                                                        toDate: todatecontroller
                                                            .text,
                                                        searchType:
                                                            widget.searchType));
                                                setState(() {
                                                  fromController.clear();
                                                  todatecontroller.clear();
                                                });
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  backgroundColor: Colors.red,
                                                  msg:
                                                      "Please select from date first");
                                            }
                                          },
                                          onChanged: (val) {
                                            setState(() {
                                              // selectedToDate = val;

                                              // fromDate = val;
                                            });
                                          },
                                        )),
                                  ],
                                ));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BlocBuilder<MyOrdersBloc, MyOrdersState>(
                builder: (context, state) {
                  if (state is FailedState) {
                    return SizedBox(
                      height: 20,
                      child: Center(child: Text(state.errorData.toString())),
                    );
                  }
                  if (state is MyOrdersCustomDetailsLoadedState) {
                    return Text(
                        "${state.myOrdersCustomDetailsModeldata.data.totalEarnings.fromDate} - ${state.myOrdersCustomDetailsModeldata.data.totalEarnings.toDate}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold
                            // color: Colors.black,
                            ));
                  } else {
                    return const Text("");
                  }
                },
              ),
              BlocBuilder<MyOrdersBloc, MyOrdersState>(
                  builder: (context, state) {
                if (state is FailedCustomState) {
                  return Center(child: Text(state.errorData));
                }
                if (state is MyOrdersCustomDetailsLoadedState) {
                  return Container(
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
                            height: 6,
                          ),
                          const Text(
                            "Total Earnings",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          BlocBuilder<MyOrdersBloc, MyOrdersState>(
                            builder: (context, state) {
                              if (state is LoadingState) {
                                return const Text("no records");
                              }
                              if (state is MyOrdersCustomDetailsLoadedState) {
                                print("unable to get");
                                return Text(
                                    "${state.myOrdersCustomDetailsModeldata.data.totalEarnings.fromDate} - ${state.myOrdersCustomDetailsModeldata.data.totalEarnings.toDate}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ));
                              } else {
                                return const Text("loading state");
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              "₹ ${state.myOrdersCustomDetailsModeldata.data.totalEarnings.totalEarning}",
                              style: TextStyle(
                                fontSize: 26,
                                color: ColorsData.themeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Text(
                          //     "${state.myOrdersCustomDetailsModeldata.data.totalEarnings.dutyTimings} on Duty",
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       color: Colors.black,
                          //     )),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(children: <Widget>[
                              Expanded(child: Divider()),
                              Text(" Earning History "),
                              Expanded(child: Divider()),
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Order Earnings"),
                              Text(
                                  "₹ ${state.myOrdersCustomDetailsModeldata.data.totalEarnings.earnings.toString()}"),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Referral amount"),
                                Text(
                                    "₹ ${state.myOrdersCustomDetailsModeldata.data.totalEarnings.incentives.toString()}"),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Customer Tips"),
                              Text(
                                  "₹ ${state.myOrdersCustomDetailsModeldata.data.totalEarnings.tips.toString()}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(
                height: 6,
              ),
              BlocBuilder<MyOrdersBloc, MyOrdersState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
                  }
                  if (state is MyOrdersCustomDetailsLoadedState) {
                    return Column(
                      children: [
                        if (state.myOrdersCustomDetailsModeldata.data.results
                            .isNotEmpty)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Day Wise",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.myOrdersCustomDetailsModeldata.data
                              .results.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyOrdersHistoryScreen(
                                          date: state
                                              .myOrdersCustomDetailsModeldata
                                              .data
                                              .results[index]
                                              .date,
                                          searchType: state
                                              .myOrdersCustomDetailsModeldata
                                              .data
                                              .results[index]
                                              .type),
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
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          // "Thu 31 aug",
                                          state
                                              .myOrdersCustomDetailsModeldata
                                              .data
                                              .results[index]
                                              .displayServiceDate,
                                          style: const TextStyle(),
                                        )),
                                        Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    // "80.00",
                                                    state
                                                        .myOrdersCustomDetailsModeldata
                                                        .data
                                                        .results[index]
                                                        .deliveryPersonEarningAmount,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  6.pw,
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                              // const SizedBox(
                                              //   height: 6,
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     const Icon(
                                              //       Icons.access_time_sharp,
                                              //       size: 10,
                                              //     ),
                                              //     const SizedBox(
                                              //       width: 4,
                                              //     ),
                                              //     Text(
                                              //       // "0 hrs",
                                              //       state
                                              //           .myOrdersCustomDetailsModeldata
                                              //           .data
                                              //           .results[index]
                                              //           .dutyTimings,
                                              //       style:
                                              //           const TextStyle(fontSize: 10),
                                              //     ),
                                              //   ],
                                              // ),
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
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
