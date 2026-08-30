import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

import '../../../../../commons/ConvertText.dart';
import '../logic/bloc/ratings_view_bloc.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RatingsViewBloc>().add(RatingsViewFetchingEvent(
        accessToken: (Constants.prefs!.getString("token"))!));
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
          ConvertText.getTitle("Ratings"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<RatingsViewBloc, RatingsViewState>(
        builder: (context, state) {
          if (state is RatingsViewInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is RatingDetailsLoaded) {
            if (state.ratingsViewModelData.data.thisWeek != '0.0' ||
                state.ratingsViewModelData.data.lastWeek != '0.0') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            state.ratingsViewModelData.txtThisWeek,
                            style: GoogleFonts.manrope(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBarIndicator(
                                rating: double.parse(
                                    state.ratingsViewModelData.data.thisWeek),
                                itemSize: 20,
                                unratedColor: Colors.grey.shade400,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  // color: Color(0xFFfaff00),
                                ),
                              ),
                              Text(
                                state.ratingsViewModelData.data.thisWeek,
                                style: GoogleFonts.manrope(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            state.ratingsViewModelData.txtLastWeek,
                            style: GoogleFonts.manrope(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBarIndicator(
                                rating: double.parse(
                                    state.ratingsViewModelData.data.lastWeek),
                                itemSize: 20,
                                unratedColor: Colors.grey.shade400,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Color(0xFFfaff00),
                                ),
                              ),
                              Text(
                                state.ratingsViewModelData.data.lastWeek,
                                style: GoogleFonts.manrope(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/no_rating.png',
                    width: 253,
                    height: 220,
                  ),
                ),
                20.ph,
                const CommonProximaNovaTextWidget(
                  text: 'No Ratings',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
