import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../commons/ConvertText.dart';
import 'showing_issues_screen.dart';

class RaisedIssuesScreen extends StatefulWidget {
  const RaisedIssuesScreen({super.key});

  @override
  State<RaisedIssuesScreen> createState() => _RaisedIssuesScreenState();
}

class _RaisedIssuesScreenState extends State<RaisedIssuesScreen> {
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
          ConvertText.getTitle("Raised Issues"),
          style: GoogleFonts.manrope(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: const EdgeInsets.all(0),
          // physics: BouncingScrollPhysics(),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: ListTile.divideTiles(
              //          <-- ListTile.divideTiles
              context: context,
              tiles: [
                ListTile(
                  // dense: true,
                  title: Text(
                    ConvertText.getTitle("Order Earning Issue"),
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShowingIssuesScreen(
                              apiType: "order",
                              titleType: 'Order Earning Issues'),
                        ));
                  },
                ),
                ListTile(
                  // dense: true,
                  title: Text(
                    ConvertText.getTitle("Payout Issues"),
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShowingIssuesScreen(
                            apiType: 'incentive',
                            titleType: 'Payout Issues',
                          ),
                        ));
                  },
                ),
                ListTile(
                  // dense: true,
                  title: Text(
                    ConvertText.getTitle("COD Cash Issues"),
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShowingIssuesScreen(
                            apiType: 'cod',
                            titleType: 'COD Cash Issues',
                          ),
                        ));
                  },
                ),
                ListTile(
                  // dense: true,
                  title: Text(
                    ConvertText.getTitle("Any Other Issues"),
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShowingIssuesScreen(
                            apiType: 'other',
                            titleType: 'Any Other Issues',
                          ),
                        ));
                  },
                ),
              ]).toList(),
        ),
      ),
    );
  }
}
