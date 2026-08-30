import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/support_help/screens/support_help_screen.dart';

import '../../commons/ConvertText.dart';
import '../../utility/colors_data.dart';
import '../../utility/internet_handler/logic/internet/internet_cubit.dart';
import '../../utility/internet_handler/screen/no_internet_screen.dart';
import '../../utility/widgets/theme_spinner.dart';
import 'home/screens/home_screen.dart';
import 'more/screens/more_screen.dart';
import 'my_orders/screens/my_orders_screens.dart';

class BottomsNaviScreen extends StatefulWidget {
  final int index;
  const BottomsNaviScreen({super.key, required this.index});

  @override
  State<BottomsNaviScreen> createState() => _BottomsNaviScreenState();
}

class _BottomsNaviScreenState extends State<BottomsNaviScreen> {
  int _currentIndex = 0;
  final tabbsList = [
    const HomeScreen(),
    const SupportandHelpScreen(
      isProfile: false,
    ),
    //const MyEarningsScreen(),
    const MyOrdersScreen(),
    const MoreScreen(),
  ];

  @override
  void initState() {
    setState(() {
      _currentIndex = widget.index;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, internetState) {
        if (internetState.connected) {
          return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                selectedLabelStyle: GoogleFonts.manrope(
                  fontWeight: FontWeight.w400,
                ),
                unselectedLabelStyle: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                ),
                selectedFontSize: 12,
                unselectedFontSize: 11,
                selectedItemColor: ColorsData.themeColor,
                unselectedItemColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
                currentIndex: _currentIndex,
                backgroundColor: Colors.white,
                items: [
                  BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: SvgPicture.asset(
                          "assets/images/homee.svg",
                          color: _currentIndex == 0
                              ? ColorsData.themeColor
                              : Colors.grey.shade700,
                          height: 21,
                        ),
                      ),
                      label: ConvertText.getTitle("Home")),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: SvgPicture.asset(
                        "assets/images/supportsvg.svg",
                        color: _currentIndex == 1
                            ? ColorsData.themeColor
                            : Colors.black,
                        height: 20,
                      ),
                    ),
                    label: ConvertText.getTitle("Support"),
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: SvgPicture.asset(
                        "assets/images/my_orders.svg",
                        color: _currentIndex == 2
                            ? ColorsData.themeColor
                            : Colors.black,
                        height: 20,
                      ),
                    ),
                    label: ConvertText.getTitle("My Orders"),
                  ),
                  BottomNavigationBarItem(
                      label: ConvertText.getTitle("More"),
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: SvgPicture.asset(
                          "assets/images/More.svg",
                          color: _currentIndex == 3
                              ? ColorsData.themeColor
                              : Colors.black,
                          height: 21,
                        ),
                      ))
                ],
              ),
              body: tabbsList[_currentIndex]
              // IndexedStack(
              //   children: tabbsList,
              //   index: _currentIndex,
              // ),
              );
        } else if (internetState.disconnected) {
          return const NoInternetScreen();
        }
        return const Center(child: ThemeSpinner());
      },
    );
  }
}
