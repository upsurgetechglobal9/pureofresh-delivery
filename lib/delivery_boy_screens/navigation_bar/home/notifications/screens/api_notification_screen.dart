import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loadmore/loadmore.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';

import '../logic/bloc/notifications_bloc.dart';

class NotificatinsScreenData extends StatefulWidget {
  final String status;
  const NotificatinsScreenData({super.key, required this.status});

  @override
  State<NotificatinsScreenData> createState() => _NotificatinsScreenDataState();
}

class _NotificatinsScreenDataState extends State<NotificatinsScreenData> {
  int start = 1;

  Future<int> loadMoreData() async {
    if (mounted) {
      setState(() {
        start = start + 1;
      });
    }
    return start;
  }

  @override
  void initState() {
    context.read<NotificationsBloc>().add(NotificationsFetchingEvent(
        start: '1',
        seenstatus: widget.status,
        existingNotificationsList: const [],
        from: 'init'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is NotificationsSeenSuccesState) {
            context.read<NotificationsBloc>().add(NotificationsFetchingEvent(
                start: '1',
                seenstatus: widget.status,
                existingNotificationsList: const [],
                from: 'init'));
          }
        },
        builder: (context, state) {
          if (state is NotificationsSuccessState) {
            return LoadMore(
              textBuilder: DefaultLoadMoreTextBuilder.english,
              isFinish: (int.parse(state.startPage) + 1) >=
                  int.parse(state.totalCount),
              onLoadMore: () async {
                // int start1 = await loadMoreData();
                context.read<NotificationsBloc>().add(
                    NotificationsFetchingEvent(
                        start: (int.parse(state.startPage) + 1).toString(),
                        seenstatus: widget.status,
                        existingNotificationsList: state.notificationsList,
                        from: ''));

                // context.read<NotificationsBloc>()
                //   ..add(JobsFetchingEvent(
                //       from: "",
                //       page: start1.toString(),
                //       existingJobsList: state.jobsList)
                //       );
                return true;
              },
              child: state.notificationsList.isEmpty
                  ? const Center(child: Text("No Records"))
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.notificationsList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (state.notificationsList[index].seenStatus ==
                                "NOT_SEEN") {
                              context.read<NotificationsBloc>().add(
                                  NotificationSeenEvent(
                                      id: state.notificationsList[index].id));
                            }

                            print(
                                "id is -- ${state.notificationsList[index].id}");
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/images/green_noti.png",
                                height: 45,
                              ),
                              // Container(
                              //     width: 45,
                              //     height: 45,
                              //     decoration: const ShapeDecoration(
                              //       shape:
                              //           OvalBorder(side: BorderSide(width: 1)),
                              //     ),
                              //     child: Padding(
                              //         padding: EdgeInsets.all(1.0),
                              //         child: Image.asset(
                              //             "assets/images/Group 1632.png"))
                              //     // state.notificationsList[index].status ==
                              //     //         "Waiting For Pickup"
                              //     //     ? Image.asset(
                              //     //         "assets/images/Group 1632.png")
                              //     //     : CircleAvatar()),
                              //     ),
                              8.pw,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      state.notificationsList[index].comment,
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    state.notificationsList[index].displayTime,
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  10.ph,
                                  // !Mydata['item${index + 1}']['seen']
                                  //     ?
                                  state.notificationsList[index].seenStatus ==
                                          "NOT_SEEN"
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const ShapeDecoration(
                                            color: TrimmitThemeData.mainColor,
                                            shape: OvalBorder(),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                              11.pw
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 10, left: 15, right: 15),
                        child: Container(
                          width: double.infinity,
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.25,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF969696),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          );
        },
      ),
    );
  }
}
