import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../commons/ConvertText.dart';
import '../../raised_issues.dart/screens/raised_issues_list_screen.dart';
import 'cod_cash_issues_screen.dart';
import 'incentives_payout_issues_screen.dart';
import 'order_earning_issue.dart';
import 'other_issues_screen.dart';
import 'update_personal_screen.dart';

class SupportandHelpScreen extends StatefulWidget {
  final bool? isProfile;
  const SupportandHelpScreen({super.key, required this.isProfile});

  @override
  State<SupportandHelpScreen> createState() => _SupportandHelpScreenState();
}

class _SupportandHelpScreenState extends State<SupportandHelpScreen> {
  final bankKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 5,
        automaticallyImplyLeading: false,
        // leading: widget.isProfile == true?IconButton(
        //   icon: Container(
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       color: Colors.grey[200],
        //       borderRadius: BorderRadius.circular(6),
        //     ),
        //     child: const Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //       color: Colors.black,
        //       size: 16,
        //     ),
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ):const SizedBox.shrink(),
        // leading: null,
        title: Text(
          ConvertText.getTitle("Help and Support"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RaisedIssuesScreen(),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/Help & Support.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ConvertText.getTitle("Raise a New Issue"),
                  style: GoogleFonts.manrope(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              ListView(
                padding: const EdgeInsets.all(0),
                // physics: BouncingScrollPhysics(),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: ListTile.divideTiles(
                    //          <-- ListTile.divideTiles
                    context: context,
                    tiles: [
                      ListTile(
                        title: Text(
                          ConvertText.getTitle("Order Earning Issue"),
                          style: GoogleFonts.manrope(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderEarningIssueScreen(),
                              ));
                        },
                      ),
                      ListTile(
                        title: Text(
                          ConvertText.getTitle("Payout Issues"),
                          style: GoogleFonts.manrope(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PayoutIssueScreen(),
                              ));
                        },
                      ),
                      ListTile(
                        title: Text(
                          ConvertText.getTitle("COD Cash Issues"),
                          style: GoogleFonts.manrope(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CodCashIssueScreen(),
                              ));
                        },
                      ),
                      ListTile(
                        title: Text(
                          ConvertText.getTitle("Update Personal Details"),
                          style: GoogleFonts.manrope(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpdatePersonalDetails(),
                              ));
                        },
                      ),
                      ListTile(
                        title: Text(
                          ConvertText.getTitle("Any Other Issues"),
                          style: GoogleFonts.manrope(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OtherIssueScreen(),
                              ));
                        },
                      ),
                    ]).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
