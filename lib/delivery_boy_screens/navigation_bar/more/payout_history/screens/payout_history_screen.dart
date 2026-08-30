import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/date_picker_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../commons/ConvertText.dart';
import '../../../../../utility/colors_data.dart';
import '../logic/bloc/payout_history_bloc.dart';

class PayoutHistoryScreen extends StatefulWidget {
  const PayoutHistoryScreen({super.key});

  @override
  State<PayoutHistoryScreen> createState() => _PayoutHistoryScreenState();
}

class _PayoutHistoryScreenState extends State<PayoutHistoryScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();
  DateTime fromDate = DateTime.now();

  int? start;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<PayoutHistoryBloc>()
        .add(const PayoutFetchingEvent(fromDate: '', toDate: ''));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fromController.dispose();
    todatecontroller.dispose();
    super.dispose();
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
          ConvertText.getTitle("Payout History"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ConvertText.getTitle("From"),
                      style: GoogleFonts.manrope(
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
                          onBackground: Colors.transparent,
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
                              borderSide: const BorderSide(color: Colors.grey),
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
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            )),
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
                      "To",
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    BlocConsumer<PayoutHistoryBloc, PayoutHistoryState>(
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
                                      onBackground: Colors.transparent,
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
                                                color: Colors.grey.shade400),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        hintText: "Select Date",
                                        hintStyle: GoogleFonts.montserrat(
                                            textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        )),
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
                                        if (fromController.text.isNotEmpty) {
                                          await showDatePicker(
                                            context: context,
                                            initialDate: fromDate,
                                            firstDate: fromDate,
                                            lastDate: DateTime.now(),
                                          ).then((value) {
                                            todatecontroller.text =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(value!);

                                            context
                                                .read<PayoutHistoryBloc>()
                                                .add(PayoutFetchingEvent(
                                                    fromDate:
                                                        fromController.text,
                                                    toDate:
                                                        todatecontroller.text));
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
                                        print("object $fromDate");
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
          Container(
            child: BlocBuilder<PayoutHistoryBloc, PayoutHistoryState>(
              builder: (context, state) {
                if (state is PayoutHistoryInavalidState) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/no_payouts.png',
                          width: 190,
                          height: 240,
                        ),
                      ),
                      20.ph,
                      const CommonProximaNovaTextWidget(
                        text: 'No Payouts done yet',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ));
                }
                if (state is PayoutHistorySuccessState) {
                  return state.payoutHistoryModelData.data.results.payoutHistory
                          .isEmpty
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            100.ph,
                            Center(
                              child: Image.asset(
                                'assets/images/no_payouts.png',
                                width: 190,
                                height: 240,
                              ),
                            ),
                            20.ph,
                            const CommonProximaNovaTextWidget(
                              text: 'No Payouts done yet',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.payoutHistoryModelData.data.results
                              .payoutHistory.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 2,
                                        color: Color.fromARGB(85, 0, 0, 0),
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state
                                                .payoutHistoryModelData
                                                .data
                                                .results
                                                .payoutHistory[index]
                                                .payoutRefId,
                                            style: GoogleFonts.manrope(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "${state.payoutHistoryModelData.data.results.payoutHistory[index].transactionStatus} - ${state.payoutHistoryModelData.data.results.payoutHistory[index].createdDateTime}",
                                            style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹ ${state.payoutHistoryModelData.data.results.payoutHistory[index].requestedAmount}",
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
