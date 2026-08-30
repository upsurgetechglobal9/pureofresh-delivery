// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../utility/colors_data.dart';

class QuickLinksDataWidget extends StatelessWidget {
  void Function()? onTap;
  final String imageUrl;
  final String amountData;
  final String titleData;

  QuickLinksDataWidget({
    Key? key,
    this.onTap,
    required this.imageUrl,
    required this.amountData,
    required this.titleData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: 120,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: ColorsData.themeColor)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageUrl,
                height: 40,
              ),
              8.ph,
              Text(amountData,
                  style: GoogleFonts.manrope(
                    color: ColorsData.themeColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  )),
              3.ph,
              Text(ConvertText.getTitle(titleData),
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
