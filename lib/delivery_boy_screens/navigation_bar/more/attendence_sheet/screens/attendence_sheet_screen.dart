import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../check_in/screens/check_in_out_screen.dart';
import '../logic/bloc/attendance_sheet_bloc.dart';
import '../repository/attendance_sheet_repository.dart';

class AttendenceSheetScreen extends StatefulWidget {
  const AttendenceSheetScreen({super.key});

  @override
  State<AttendenceSheetScreen> createState() => _AttendenceSheetScreenState();
}

class _AttendenceSheetScreenState extends State<AttendenceSheetScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // create: (context) => AttendanceSheetBloc(attendanceSheetReposotory: AttendanceSheetReposotory),
      create: (context) => AttendanceSheetBloc(
          attendanceSheetReposotory: AttendanceSheetReposotory())
        ..add(AttendanceSheetFetchingEvent(
            accessToken: (Constants.prefs!.getString("token"))!)),
      child: Scaffold(
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
            ConvertText.getTitle("Attendance Sheet"),
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: BlocConsumer<AttendanceSheetBloc, AttendanceSheetState>(
          listener: (context, state) {
            if (state is CheckInValidFaildSate) {
              Fluttertoast.showToast(
                  msg: "Already Checkin Done. Please Do Checkout.");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AttendenceSheetScreen(),
                  ));
            }
            if (state is CheckOutValidFaildSate) {
              Fluttertoast.showToast(
                  msg: "Already Checkout Done. Please Do CheckIn.");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AttendenceSheetScreen(),
                  ));
            }
            if (state is CheckInValidSuccessSate) {
              context.read<AttendanceSheetBloc>().add(
                  AttendanceSheetFetchingEvent(
                      accessToken: (Constants.prefs!.getString("token"))!));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CheckInCheckOutScreen(type: "Check In"),
                  ));
            }
            if (state is CheckOutValidSuccessSate) {
              context.read<AttendanceSheetBloc>().add(
                  AttendanceSheetFetchingEvent(
                      accessToken: (Constants.prefs!.getString("token"))!));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CheckInCheckOutScreen(type: "Check Out"),
                  ));
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AttendanceSheetBloc>().add(
                    AttendanceSheetFetchingEvent(
                        accessToken: (Constants.prefs!.getString("token"))!));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12)),
                        title: Text(
                          ConvertText.getTitle("Check In"),
                          style: GoogleFonts.manrope(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          context.read<AttendanceSheetBloc>().add(
                              AttendanceCheckInValidationEvent(
                                  accessToken:
                                      (Constants.prefs!.getString("token"))!));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12)),
                        title: Text(
                          ConvertText.getTitle("Check Out"),
                          style: GoogleFonts.manrope(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          context.read<AttendanceSheetBloc>().add(
                              AttendanceCheckOutValidationEvent(
                                  accessToken:
                                      (Constants.prefs!.getString("token"))!));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        ConvertText.getTitle("Attendance Sheet"),
                        style: GoogleFonts.manrope(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<AttendanceSheetBloc, AttendanceSheetState>(
                      builder: (context, state) {
                        // if (state is AttendanceSheetInitial) {
                        //   return Center(
                        //     child: CircularProgressIndicator(
                        //       strokeWidth: 2,
                        //     ),
                        //   );
                        // }
                        if (state is AttendanceDetailsLoaded) {
                          return state.attendanceDetailsModeldata
                                  .attendanceDetails.isEmpty
                              ? Center(
                                  child: Text(
                                    ConvertText.getTitle("No Records Found"),
                                  ),
                                )
                              : DataTable(
                                  // border: TableBorder.all(color: Colors.grey),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                      ConvertText.getTitle("Date"),
                                      style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      ConvertText.getTitle("Check In"),
                                      style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      ConvertText.getTitle("Check Out"),
                                      style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    )),
                                  ],
                                  rows: [
                                    for (int i = 0;
                                        i <
                                            state.attendanceDetailsModeldata
                                                .attendanceDetails.length;
                                        i++)
                                      DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(
                                            state.attendanceDetailsModeldata.attendanceDetails[i].date,
                                            style: GoogleFonts.manrope(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          )),
                                          DataCell(Text(
                                            state.attendanceDetailsModeldata.attendanceDetails[i].checkin,
                                            style: GoogleFonts.manrope(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          )),
                                          DataCell(Text(
                                            state.attendanceDetailsModeldata.attendanceDetails[i].checkout,
                                            style: GoogleFonts.manrope(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          )),
                                        ],
                                      ),
                                  ],
                                );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
