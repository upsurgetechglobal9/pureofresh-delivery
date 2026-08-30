import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../../../../../utility/DottedLinePainter.dart';
import '../logic/bloc/cod_cash_bloc.dart';
import '../models/cod_cash_model.dart';

class CODCashScreen extends StatefulWidget {
  const CODCashScreen({super.key});

  @override
  State<CODCashScreen> createState() => _CODCashScreenState();
}

class _CODCashScreenState extends State<CODCashScreen> {
  dynamic amount = "₹ 150";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CodCashBloc>().add(
        CODCashFetching(accessToken: (Constants.prefs!.getString("token"))!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          ConvertText.getTitle("COD Cash"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Column(
                children: [
                  BlocBuilder<CodCashBloc, CodCashState>(
                    builder: (context, state) {
                      if (state is CodCashInitial) {
                        return Shimmer.fromColors(
                            baseColor: const Color.fromARGB(95, 191, 188, 188),
                            highlightColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(121, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(24)),
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ));
                      }
                      if (state is CodCashLoadedState) {
                        CodCashModel codCash = state.cashModel;
                        return Column(
                          children: [
                            Image.asset(
                              "assets/images/codCash.png",
                              height: 100,
                            ),
                            Text(
                              codCash.data.wallet.isEmpty
                                  ? "₹ 0"
                                  : " ₹ ${codCash.data.wallet}",
                              style: GoogleFonts.manrope(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              ConvertText.getTitle("Current Balance"),
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${ConvertText.getTitle("Limit")}   ₹ ${codCash.data.limit}",
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                color: ColorsData.themeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }
                      return Shimmer.fromColors(
                          baseColor: const Color.fromARGB(95, 191, 188, 188),
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(121, 255, 255, 255),
                                borderRadius: BorderRadius.circular(24)),
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            CustomPaint(
              painter: DottedLinePainter(color: const Color(0xff727272)),
              child: Container(
                  // Your widget's content
                  ),
            ),
            BlocBuilder<CodCashBloc, CodCashState>(
              builder: (context, state) {
                // if (state is CustomerTipsInitial) {
                //   return CircularProgressIndicator();
                // }
                // if (state is TipsErrorState) {
                //   return Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       SizedBox(
                //         height: 20,
                //       ),
                //       Container(
                //         child: Center(
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Text(
                //               state.errorMessage,
                //               style: GoogleFonts.manrope(
                //                 fontSize: 12,
                //                 color: Colors.grey,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   );
                // }
                if (state is CodCashLoadedState) {
                  CodCashModel cashData = state.cashModel;
                  // List<CustomerTipsList> tipsList = tipsData.results
                  //     .map((e) => CustomerTipsList.fromJson(e))
                  //     .toList();

                  return cashData.orders.results.isEmpty
                      ? const Center(
                          heightFactor: 15,
                          child: Text("No Records Found"),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cashData.orders.results.length,
                          itemBuilder: (context, index) {
                            return getOrderFromItem(cashData, index);
                          });
                }
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(95, 191, 188, 188),
                                highlightColor: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          121, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(24)),
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                ))),
                      );
                    });
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     padding: EdgeInsets.all(12),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12), color: Colors.white),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(ConvertText.getTitle("Instant Transfer with UPI"),

            //           style: GoogleFonts.manrope(
            //             fontSize: 14,
            //             color: Colors.black,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         SizedBox(
            //           height: 8,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             for (int i = 0; i < transferAmount.length; i++)
            //               GestureDetector(
            //                 onTap: () {
            //                   setState(() {
            //                     amount = transferAmount[i];
            //                   });
            //                   print(amount);
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Container(
            //                       padding: EdgeInsets.all(10),
            //                       decoration: BoxDecoration(
            //                           color: amount == transferAmount[i]
            //                               ? ColorsData.themeColor
            //                               : Colors.grey.shade200,
            //                           borderRadius: BorderRadius.circular(10)),
            //                       child: Text(
            //                         transferAmount[i],
            //                         style: GoogleFonts.manrope(
            //                             fontWeight: FontWeight.w500,
            //                             fontSize: 12,
            //                             color: amount == transferAmount[i]
            //                                 ? Colors.white
            //                                 : Colors.black),
            //                       )),
            //                 ),
            //               )
            //           ],
            //         ),
            //         SizedBox(
            //           height: 8,
            //         ),
            //         SizedBox(
            //           width: double.infinity,
            //           child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Color(0xFF7ec245),
            //             ),
            //             onPressed: () {},
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(
            //                   vertical: 10.0, horizontal: 12),
            //               child: Text(
            //                 ConvertText.getTitle("TRANSFER NOW"),
            //                 style: GoogleFonts.manrope(
            //                   color: Colors.white,
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // RadioListTile(
            //   dense: true,
            //   activeColor: Colors.green,
            //   controlAffinity: ListTileControlAffinity.trailing,
            //   contentPadding: EdgeInsets.only(left: 8),
            //   toggleable: true,
            //   title: Text(
            //     'Phone Pay',
            //     style: GoogleFonts.manrope(),
            //   ),
            //   value: "",
            //   onChanged: (v) {},
            //   groupValue: '',
            // ),
          ],
        ),
      ),
    );
  }

  // List transferAmount = ["₹ 150", "₹ 350", "₹ 500", "₹ 1000"];
  Widget getOrderFromItem(CodCashModel cashDat, int i) {
    return ListTile(
      title: Text(
        "ID:${cashDat.orders.results[i].refId},${ConvertText.getTitle("Order From")} ${cashDat.orders.results[i].customerName}",
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        cashDat.orders.results[i].serviceDateTime,
        style: GoogleFonts.manrope(
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
      trailing: Text("+ ₹${cashDat.orders.results[i].grandTotal}",
          style: TextStyle(
              color: ColorsData.themeColor, fontWeight: FontWeight.bold)),
    );
  }
}
