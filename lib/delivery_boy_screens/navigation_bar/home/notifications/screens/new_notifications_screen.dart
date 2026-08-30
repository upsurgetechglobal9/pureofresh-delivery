import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/logic/cubit/notifications_data_cubit.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/notifications/repository/notifications_repository.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/screens/commocoloo.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';
import 'package:pure_o_fresh_rider_app/utility/widgets/theme_spinner.dart';

class NotificationsListScreen extends StatefulWidget {
  final String status;

  const NotificationsListScreen({super.key, required this.status});

  @override
  State<NotificationsListScreen> createState() =>
      _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> {
  final notificationsListScrollController = ScrollController();
  DateTime? previousEventTime;
  double previousScrollOffset = 0;
  late NotificationsDataCubit notificationsDataCubit;

  @override
  void initState() {
    super.initState();
    notificationsDataCubit =
        NotificationsDataCubit(context.read<NotificationsRepository>());
    notificationsDataCubit.featchNotifications(seenStatus: widget.status);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationsListScrollController.addListener(() {
        notificationsListScrollController.position.isScrollingNotifier
            .addListener(() {
          if (notificationsListScrollController.position.maxScrollExtent ==
              notificationsListScrollController.offset) {
            notificationsDataCubit.featchNotifications(
                loadMoreData: true, seenStatus: widget.status);
          }
          //Find the scrolling speed
          final currentScrollOffset =
              notificationsListScrollController.position.pixels;
          final currentTime = DateTime.now();
          previousEventTime = currentTime;
          previousScrollOffset = currentScrollOffset;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    notificationsListScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: notificationsDataCubit,
      child: BlocBuilder<NotificationsDataCubit, NotificationsDataState>(
        builder: (context, notificationsDataState) {
          if (notificationsDataState.error != null) {
            return Text(notificationsDataState.error!);
          } else if (notificationsDataState.dataLoading ||
              notificationsDataState.notificationsDataNewResponseModel ==
                  null) {
            return const Center(child: ThemeSpinner());
          } else {
            final logs =
                notificationsDataState.notificationsDataNewResponseModel;
            return logs!.results.isEmpty
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/no_notification.png',
                          width: 190,
                          height: 240,
                        ),
                      ),
                      20.ph,
                      const CommonProximaNovaTextWidget(
                        text: 'No Notifications',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  ))
                : RefreshIndicator(
                    color: ColorsData.themeColor,
                    onRefresh: () async {
                      notificationsDataCubit.featchNotifications(
                          seenStatus: widget.status);
                    },
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),

                      controller: notificationsListScrollController,
                      itemCount: logs.results.length +
                          (logs.paginationTestModel.isLastPage
                              ? 0
                              : 1), // Replace with your actual data
                      itemBuilder: (context, index) {
                        if (index < logs.results.length) {
                          final noti = logs.results[index];
                          return InkWell(
                            onTap: () {
                              notificationsDataCubit.singleNotificationRead(
                                  noti.id, widget.status);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              child: Row(
                                children: [
                                  noti.type == "Completed"
                                      ? Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ColorsData.themeColor),
                                          child: const Icon(Icons.notifications,
                                              color: Colors.white),
                                        )
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green),
                                          child: const Icon(Icons.notifications,
                                              color: Colors.white),
                                        ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: CommonProximaNovaTextWidget(
                                            text: noti.comment),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CommonProximaNovaTextWidget(
                                          text: noti.displayTime),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      noti.seenStatus == "NOT_SEEN"
                                          ? Container(
                                              width: 10,
                                              height: 10,
                                              decoration: ShapeDecoration(
                                                color: ColorsData.themeColor,
                                                shape: const OvalBorder(),
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 11,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (logs.paginationTestModel.isLastPage) {
                          return const SizedBox.shrink();
                        } else {
                          return const LinearProgressIndicator(
                            backgroundColor: Colors.orange,
                          );
                        }
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
        },
      ),
    );
  }
}
