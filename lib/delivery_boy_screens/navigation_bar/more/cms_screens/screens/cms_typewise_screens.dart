import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/bloc/cms_bloc.dart';

class CMsTypeWiseScreen extends StatefulWidget {
  final String apiType;
  final String titleType;
  const CMsTypeWiseScreen(
      {super.key, required this.apiType, required this.titleType});

  @override
  State<CMsTypeWiseScreen> createState() => _CMsTypeWiseScreenState();
}

class _CMsTypeWiseScreenState extends State<CMsTypeWiseScreen> {
  @override
  void initState() {
    context.read<CmsBloc>().add(CmsFetchingEvent(api: widget.apiType));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          widget.titleType,
          style: GoogleFonts.manrope(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<CmsBloc, CmsState>(
        builder: (context, state) {
          if (state is CmsFailedState) {
            return Center(
              child: Text(" ${state.cmserror} "),
            );
          } else if (state is CmsInitial) {
            return const Center(child: Text("Loading..."));
          } else if (state is CmsSuccessState) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: HtmlWidget(
                    state.cmsModelData.data ?? '',
                  ),
                ));
          }
          return const Center(child: Text("Loading..."));
        },
      ),
    );
  }
}
