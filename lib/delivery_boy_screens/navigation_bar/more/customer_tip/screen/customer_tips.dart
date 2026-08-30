import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../../../../../utility/DottedLinePainter.dart';
import '../../../../../utility/colors_data.dart';
import '../logic/bloc/customer_tips_bloc.dart';
import '../models/customer_tips_model.dart';
import '../repository/customer_tips_repository.dart';

class CustomerTips extends StatefulWidget {
  const CustomerTips({super.key});

  @override
  State<CustomerTips> createState() => _CustomerTipsState();
}

class _CustomerTipsState extends State<CustomerTips> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   var token = Constants.prefs!.getString("token");
  //   context
  //       .read<CustomerTipsBloc>()
  //       .add(CustomerTipsFetching(accessToken: "LZ777655791"));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CustomerTipsBloc(customerTipsRepository: CustomerTipsRepository())
            ..add(CustomerTipsFetching(
                accessToken: (Constants.prefs!.getString("token"))!)),
      child: Scaffold(
        backgroundColor: Colors.white,
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
            ConvertText.getTitle("Customer Tips"),
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/Customer Tips.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<CustomerTipsBloc, CustomerTipsState>(
                  builder: (context, state) {
                    if (state is CustomerTipsInitial) {
                      return const ThemeSpinner(
                        size: 30,
                      );
                    }
                    if (state is TipsErrorState) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "₹ 0",
                            style: GoogleFonts.manrope(
                              fontSize: 24,
                              color: ColorsData.themeColor,
                            ),
                          ),
                        ),
                      );
                    }
                    if (state is TipsLoadedState) {
                      CustomerTipsModel tipsData = state.customerTipsData;
                      return Text("₹ ${tipsData.data.totalAmount}",
                          style: GoogleFonts.manrope(
                              fontSize: 36,
                              color: ColorsData.themeColor,
                              fontWeight: FontWeight.w500));
                    }
                    return const ThemeSpinner(
                      size: 30,
                    );
                  },
                ),
                Text(
                  ConvertText.getTitle("Total Tips Received"),
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomPaint(
                  painter: DottedLinePainter(color: const Color(0xff727272)),
                  child: Container(
                      // Your widget's content
                      ),
                ),
                BlocBuilder<CustomerTipsBloc, CustomerTipsState>(
                  builder: (context, state) {
                    if (state is CustomerTipsInitial) {
                      return LinearProgressIndicator(
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.black,
                      );
                    }
                    if (state is TipsErrorState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.errorMessage,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is TipsLoadedState) {
                      CustomerTipsModel tipsData = state.customerTipsData;
                      // List<CustomerTipsList> tipsList = tipsData.results
                      //     .map((e) => CustomerTipsList.fromJson(e))
                      //     .toList();

                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: tipsData.data.results.length,
                          itemBuilder: (context, index) {
                            return getOrderFromItem(tipsData, index);
                          });
                    }
                    return const ThemeSpinner(
                      size: 30,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getOrderFromItem(CustomerTipsModel tipsData, int i) {
    return ListTile(
      dense: true,
      title: Text(
        "${ConvertText.getTitle("Order From")} ${tipsData.data.results[i].customerName}",
        style: GoogleFonts.manrope(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        tipsData.data.results[i].serviceDateTime,
        style: GoogleFonts.manrope(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: Text("+ ₹ ${tipsData.data.results[i].tipAmount}",
          style: GoogleFonts.manrope(
              color: ColorsData.themeColor, fontWeight: FontWeight.bold)),
    );
  }
}
