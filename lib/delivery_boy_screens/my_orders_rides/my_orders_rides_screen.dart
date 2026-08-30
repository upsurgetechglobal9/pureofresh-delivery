import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/commons/ConvertText.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/my_orders_rides_widget.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/pick_and_drop_list_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/ride_list_screen.dart';

class MyOrdersRidesScreen extends StatefulWidget {
  const MyOrdersRidesScreen({super.key});

  @override
  State<MyOrdersRidesScreen> createState() => _MyOrdersRidesScreenState();
}

class _MyOrdersRidesScreenState extends State<MyOrdersRidesScreen>
    with TickerProviderStateMixin {
  late final TabController _foodTabController;
  @override
  void initState() {
    super.initState();
    _foodTabController = TabController(length: 2, vsync: this, initialIndex: 0);
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
          ConvertText.getTitle("My Rides"),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              initialIndex: 1,
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width:
                        double.infinity, // Ensure TabBar spans the entire width
                    child: TabBar(
                      controller: _foodTabController,
                      isScrollable: false,
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      splashBorderRadius: BorderRadius.circular(15),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      indicatorPadding:
                          const EdgeInsets.symmetric(vertical: 3.6),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                      tabs: const [
                        Tab(
                          child: TabItemWidget(
                              title: 'Ride Booking', color: Colors.white),
                        ),
                        Tab(
                          child: TabItemWidget(
                              title: 'Pick & Drop', color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _foodTabController,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: RideListScreen(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: PickAndDropListScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
