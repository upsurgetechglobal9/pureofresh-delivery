// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/screens/new_notifications_screen.dart';

import '../../../navigationbar_screen.dart';
import '../../screens/commocoloo.dart';
import '../logic/bloc/notifications_bloc.dart';
import 'api_notification_screen.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: TrimmitThemeData.backgroundColor,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: TrimmitThemeData.backgroundColor,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomsNaviScreen(index: 0),
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffECECEC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: TrimmitThemeData.darkColor,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      onTap: () {
                        context
                            .read<NotificationsBloc>()
                            .add(NotificationsMarkAllEvent());
                      },
                      height: 24,
                      value: 'option1',
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.grey,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5.6,
                          ),
                          Text(
                            'Mark all as Read',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // PopupMenuItem<String>(
                    //   height: 0.5,
                    //   value: 'option3',
                    //   child: Container(
                    //     height: 0.5,
                    //     color: const Color(0xff888899),
                    //   ),
                    // ),
                    // const PopupMenuItem<String>(
                    //   height: 24,
                    //   value: 'option2',
                    //   child: Row(
                    //     children: [
                    //       // ImageIcon(
                    //       //   AssetImage('assets/assets/images/Profile.png'),
                    //       //   color: TrimmitThemeData.darkColor,
                    //       //   size: 14,
                    //       // ),
                    //       Icon(
                    //         Icons.settings,
                    //         color: Colors.grey,
                    //         size: 16,
                    //       ),
                    //       SizedBox(
                    //         width: 4,
                    //       ),
                    //       Text(
                    //         'Notification Settings',
                    //         style: TextStyle(
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ];
                },
                shadowColor: TrimmitThemeData.darkColor.withOpacity(0.5),
                elevation: 8,
                constraints: const BoxConstraints(maxHeight: 65, maxWidth: 145),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                position: PopupMenuPosition.under,
                onSelected: (String value) {
                  switch (value) {
                    case 'option1':
                      break;
                    case 'option2':
                      break;
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: CircleAvatar(
                    backgroundColor: Color(0xffECECEC),
                    child: Icon(
                      Icons.more_horiz,
                      color: TrimmitThemeData.darkColor,
                      size: 26,
                    ),
                  ),
                ),
              ),
            )
          ],
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: TrimmitThemeData.darkColor,
              fontSize: 18,
              fontFamily: TrimmitThemeData.manropeFontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey,
                  onTap: (int itemIndex) {
                    setState(() {
                      index = itemIndex;
                    });
                  },
                  automaticIndicatorColorAdjustment: false,
                  indicatorWeight: 0.2,
                  indicatorColor: Colors.transparent,
                  labelStyle: const TextStyle(),
                  unselectedLabelStyle: const TextStyle(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                  tabs: [
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
                        // width: 60,
                        height: 28,
                        decoration: ShapeDecoration(
                          color: index == 0
                              ? TrimmitThemeData.mainColor
                              : const Color(0xFFA5A5A5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          child: Text(
                            'All',
                            style: TextStyle(
                              color: TrimmitThemeData.liteColor,
                              fontSize: 12,
                              fontFamily: TrimmitThemeData.manropeFontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 28,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: index == 1
                              ? TrimmitThemeData.mainColor
                              : const Color(0xFFA5A5A5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'Read',
                            style: TextStyle(
                              color: TrimmitThemeData.liteColor,
                              fontSize: 12,
                              fontFamily: TrimmitThemeData.manropeFontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        alignment: Alignment.center,
                        // width: 60,
                        height: 28,
                        decoration: ShapeDecoration(
                          color: index == 2
                              ? TrimmitThemeData.mainColor
                              : const Color(0xFFA5A5A5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'Unread',
                            style: TextStyle(
                              color: TrimmitThemeData.liteColor,
                              fontSize: 12,
                              fontFamily: TrimmitThemeData.manropeFontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            const Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // ListView.separated(
                  //   shrinkWrap: true,
                  //   physics: const BouncingScrollPhysics(),
                  //   itemCount: Mydata.length,
                  //   itemBuilder: (context, index) {
                  //     return Row(
                  //       children: [
                  //         15.pw,
                  //         Container(
                  //           width: 45,
                  //           height: 45,
                  //           decoration: const ShapeDecoration(
                  //             shape: OvalBorder(side: BorderSide(width: 1)),
                  //           ),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(10.0),
                  //             child: Image.asset(
                  //                 Mydata['item${index + 1}']['image']),
                  //           ),
                  //         ),
                  //         8.pw,
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             SizedBox(
                  //               width: 19,
                  //               child: Text(
                  //                 Mydata['item${index + 1}']['name'],
                  //                 style: const TextStyle(
                  //                   color: TrimmitThemeData.mainColor,
                  //                   fontSize: 8,
                  //                   fontFamily:
                  //                       TrimmitThemeData.manropeFontFamily,
                  //                   fontWeight: FontWeight.w500,
                  //                 ),
                  //               ),
                  //             ),
                  //             Text(
                  //               Mydata['item${index + 1}']['title'],
                  //               style: const TextStyle(
                  //                 color: TrimmitThemeData.darkColor,
                  //                 fontSize: 12,
                  //                 fontFamily: TrimmitThemeData.manropeFontFamily,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //             3.ph,
                  //             SizedBox(
                  //               width: 196,
                  //               child: Text(
                  //                 Mydata['item${index + 1}']['subtitle'],
                  //                 style: const TextStyle(
                  //                   color: TrimmitThemeData.darkColor,
                  //                   fontSize: 10,
                  //                   fontFamily:
                  //                       TrimmitThemeData.manropeFontFamily,
                  //                   fontWeight: FontWeight.w400,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         const Spacer(),
                  //         Column(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             const Text(
                  //               'yesterday',
                  //               style: TextStyle(
                  //                 color: TrimmitThemeData.darkColor,
                  //                 fontSize: 8,
                  //                 fontFamily: TrimmitThemeData.manropeFontFamily,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             20.ph,
                  //             !Mydata['item${index + 1}']['seen']
                  //                 ? Container(
                  //                     width: 10,
                  //                     height: 10,
                  //                     decoration: const ShapeDecoration(
                  //                       color: TrimmitThemeData.mainColor,
                  //                       shape: OvalBorder(),
                  //                     ),
                  //                   )
                  //                 : Container()
                  //           ],
                  //         ),
                  //         11.pw
                  //       ],
                  //     );
                  //   },
                  //   separatorBuilder: (context, index) => Padding(
                  //     padding: const EdgeInsets.only(
                  //         top: 12, bottom: 10, left: 15, right: 15),
                  //     child: Container(
                  //       width: double.infinity,
                  //       decoration: const ShapeDecoration(
                  //         shape: RoundedRectangleBorder(
                  //           side: BorderSide(
                  //             width: 0.25,
                  //             strokeAlign: BorderSide.strokeAlignCenter,
                  //             color: Color(0xFF969696),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  NotificationsListScreen(status: ''),
                  NotificationsListScreen(status: 'SEEN'),
                  NotificationsListScreen(status: 'NOT_SEEN'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
