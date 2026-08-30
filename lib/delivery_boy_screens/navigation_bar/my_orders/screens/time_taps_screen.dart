import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utility/colors_data.dart';
import '../widgets/custom_screen.dart';
import '../widgets/this_week.dart';

class TimeTabsScreen extends StatefulWidget {
  final String searchType;
  const TimeTabsScreen({super.key,required this.searchType});

  @override
  State<TimeTabsScreen> createState() => _TimeTabsScreenState();
}

class _TimeTabsScreenState extends State<TimeTabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
           elevation: 1,
            backgroundColor: Colors.white,
            toolbarHeight: 10,
          bottom: TabBar(
          isScrollable: true,
          indicatorColor: ColorsData.themeColor,
          indicatorWeight: 4,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
          labelColor: Colors.black,
          labelStyle: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          tabs: const [
            Tab(
              child: Text("This Week"),
            ),
            Tab(
              child: Text("Last Week"),
            ),
            Tab(
              child: Text("1 Months"),
            ),
            Tab(
              child: Text("Custom"),
            ),
          ],
        )
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ThisWeekScreenTab(
              type: 'this week',
              searchType: widget.searchType,
            ),
            ThisWeekScreenTab(
              type: 'last week',
              searchType: widget.searchType,
            ),
            ThisWeekScreenTab(
              type: '1 month',
              searchType: widget.searchType,
            ),
            CustomScreenTab(searchType: widget.searchType),
          ],
        ),
      ),
    );
  }
}