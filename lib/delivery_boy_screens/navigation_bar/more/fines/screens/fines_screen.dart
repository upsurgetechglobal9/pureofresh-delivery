import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../commons/shared_prefs.dart';
import '../../../../../utility/DottedLinePainter.dart';
import '../../../../../utility/colors_data.dart';
import '../logic/bloc/fines_bloc.dart';
import '../repository/fines_repository.dart';

class FineScreen extends StatefulWidget {
  const FineScreen({super.key});

  @override
  State<FineScreen> createState() => _FineScreenState();
}

class _FineScreenState extends State<FineScreen> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   context.read<FinesBloc>().add(FinesFetchingEvent());
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FinesBloc(finesRepository: FinesRepository())
        ..add(FinesFetchingEvent()),
      child: BlocConsumer<FinesBloc, FinesState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              // backgroundColor: Colors.transparent,
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 4,
              leading: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
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
                ConvertText.getTitle("Fines"),
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/fine 1.png",
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<FinesBloc, FinesState>(
                      builder: (context, state) {
                        if (state is FinesSuccess) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "₹ ${state.finesModelData.data.totalAmount}",
                                style: GoogleFonts.manrope(
                                    fontSize: 24,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }
                        if (state is FinesErrorState) {
                          return Text("${state.errorMessage}",
                              style: GoogleFonts.manrope(
                                  fontSize: 16, fontWeight: FontWeight.w500));
                        }
                        return Shimmer.fromColors(
                            baseColor: Colors.grey.shade200,
                            highlightColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 20,
                              width: 40,
                            ));
                      },
                    ),
                    Text(
                      ConvertText.getTitle("Total Fines"),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomPaint(
                      painter: DottedLinePainter(color: Color(0xff727272)),
                      child: Container(
                          // Your widget's content
                          ),
                    ),
                    BlocBuilder<FinesBloc, FinesState>(
                      builder: (context, state) {
                        if (state is FinesErrorState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      state.errorMessage,
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        if (state is FinesSuccess) {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  state.finesModelData.data.results.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    "${state.finesModelData.data.results[index].fineTypes}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${state.finesModelData.data.results[index].dateTime}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: Text(
                                      "- ₹ ${state.finesModelData.data.results[index].fineAmount}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                );
                              });
                        }
                        return Shimmer.fromColors(
                            baseColor: Colors.grey.shade200,
                            highlightColor: Colors.white,
                            child: Column(
                              children: [
                                for (int i = 0; i < 5; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                    ),
                                  ),
                              ],
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
