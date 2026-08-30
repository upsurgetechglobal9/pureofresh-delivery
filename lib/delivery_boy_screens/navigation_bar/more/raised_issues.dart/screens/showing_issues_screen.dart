import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

import '../../../../../commons/ConvertText.dart';
import '../logic/raised_issues_bloc.dart';

class ShowingIssuesScreen extends StatefulWidget {
  final String apiType;
  final String titleType;
  const ShowingIssuesScreen(
      {super.key, required this.apiType, required this.titleType});

  @override
  State<ShowingIssuesScreen> createState() => _ShowingIssuesScreenState();
}

class _ShowingIssuesScreenState extends State<ShowingIssuesScreen> {
  @override
  void initState() {
    context
        .read<RaisedIssuesBloc>()
        .add(AllTypeIssuesEvent(issueType: widget.apiType));

    super.initState();
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
          widget.titleType,
          style: GoogleFonts.manrope(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<RaisedIssuesBloc, RaisedIssuesState>(
        builder: (context, state) {
          if (state is ErrorState) {
            return Center(child: Text(state.error!));
          } else if (state is LoadingState) {
            return const Center(child: Text('Loading....'));
          } else if (state is RaisedDetailsSuccessState) {
            return state.raisedIssuesModel.data.isEmpty
                ? const Center(
                    child: Text("No records found"),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.raisedIssuesModel.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 2,
                                    color: Color.fromARGB(85, 0, 0, 0),
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.titleType == "Any Other Issues"
                                      ? const SizedBox.shrink()
                                      : state.raisedIssuesModel.data[index]
                                                  .orderId !=
                                              ""
                                          ? Text(
                                              "Order Id: ${state.raisedIssuesModel.data[index].orderId}",
                                              style: GoogleFonts.manrope(
                                                fontSize: 15,
                                                color: ColorsData.themeColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          : Text(
                                              "Transaction Id: ${state.raisedIssuesModel.data[index].transactionId}",
                                              style: GoogleFonts.manrope(
                                                fontSize: 15,
                                                color: ColorsData.themeColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    ConvertText.getTitle("Description"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    " ${state.raisedIssuesModel.data[index].description}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    ConvertText.getTitle("Attachments"),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              state.raisedIssuesModel
                                                  .data[index].image,
                                            ),
                                            fit: BoxFit.cover)),
                                  ),
                                  // Image.network(
                                  //   state.raisedIssuesModel.data[index].image,
                                  //   height: 100,
                                  // ),
                                  // CachedNetworkImage(
                                  //   imageUrl: "http://via.placeholder.com/200x150",
                                  //   imageBuilder: (context, imageProvider) =>
                                  //       Container(
                                  //     decoration: BoxDecoration(
                                  //       image: DecorationImage(
                                  //           image: imageProvider,
                                  //           fit: BoxFit.cover,
                                  //           colorFilter: ColorFilter.mode(
                                  //               Colors.red, BlendMode.colorBurn)),
                                  //     ),
                                  //   ),
                                  //   placeholder: (context, url) =>
                                  //       CircularProgressIndicator(),
                                  //   errorWidget: (context, url, error) =>
                                  //       Icon(Icons.error),
                                  // )
                                ],
                              ),
                            ),
                          ));
                    },
                  );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
