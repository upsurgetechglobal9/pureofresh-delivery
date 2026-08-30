import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../logic/bloc/referrals_data_bloc.dart';
import '../models/referral_data_model.dart';
import 'refer_a_friend.dart';

class ReferYourFriend extends StatefulWidget {
  const ReferYourFriend({super.key});

  @override
  State<ReferYourFriend> createState() => _ReferYourFriendState();
}

class _ReferYourFriendState extends State<ReferYourFriend> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ReferralsDataBloc>().add(
        ReferralsFetching(accessToken: (Constants.prefs!.getString("token"))!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        backgroundColor: Color.fromARGB(255, 56, 138, 35),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/referbg.png'),
                        fit: BoxFit.fill),
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        ConvertText.getTitle("Refer your friends"),
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      BlocBuilder<ReferralsDataBloc, ReferralsDataState>(
                        builder: (context, state) {
                          if (state is ReferralsLoadedState) {
                            return Text(
                              ConvertText.getTitle(
                                  "and Earn ₹ ${state.referralsModel.refAmount}"),
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }
                          return Center(
                            child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(95, 224, 224, 224),
                                highlightColor: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          121, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(24)),
                                  height: 30,
                                  width: 80,
                                )),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        "assets/images/Gift box.png",
                        height: 100,
                      ),
                      BlocBuilder<ReferralsDataBloc, ReferralsDataState>(
                        builder: (context, state) {
                          if (state is ReferralsDataInitial) {
                            return const CircularProgressIndicator();
                          }
                          if (state is ReferralsLoadedState) {
                            ReferralsDataModel referralData =
                                state.referralsModel;
                            // return Text(
                            //   "₹ ${referralData.refWalletAmount}",
                            //   style: GoogleFonts.manrope(
                            //     color: Colors.white,
                            //     fontSize: 28,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // );
                          }
                          return SizedBox();
                          // return Center(
                          //   child: Shimmer.fromColors(
                          //       baseColor:
                          //           const Color.fromARGB(95, 224, 224, 224),
                          //       highlightColor: Colors.white,
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //             color: const Color.fromARGB(
                          //                 121, 255, 255, 255),
                          //             borderRadius: BorderRadius.circular(24)),
                          //         height: 30,
                          //         width: 80,
                          //       )),
                          // );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReferAFriend(),
                                ));
                          },
                          child: Text(
                            ConvertText.getTitle("Refer a Friend"),
                            style: GoogleFonts.manrope(
                              // letterSpacing: 0.6,
                              color: ColorsData.themeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 16),
              child: Text(
                ConvertText.getTitle("Your Referrals"),
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: BlocBuilder<ReferralsDataBloc, ReferralsDataState>(
                builder: (context, state) {
                  if (state is ReferralsDataInitial) {
                    return Center(
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24)),
                            height: 40,
                            width: 300,
                          )),
                    );
                    // Center(child: CircularProgressIndicator());
                  }
                  if (state is ReferralsLoadedState) {
                    ReferralsDataModel referralData = state.referralsModel;
                    if (referralData.data.isEmpty) {
                      return Column(
                        children: [
                          40.ph,
                          const Center(child: Text("No Records Found")),
                        ],
                      );
                    } else {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: referralData.data.length,
                          itemBuilder: (context, index) {
                            return getOrderFromItem(referralData.data[index]);
                          });
                    }
                  }
                  return Center(
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24)),
                          height: 40,
                          width: 300,
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getOrderFromItem(Datum data) {
    return ListTile(
      shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      title: Text(
        data.name,
        style: GoogleFonts.manrope(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        data.datetime,
        style: GoogleFonts.manrope(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: data.status != "Sent to Team"
          ? Text("${data.status}",
              style: TextStyle(color: ColorsData.themeColor))
          : Text(data.status, style: const TextStyle(color: Color(0xFFcccf29))),
    );
  }
}
