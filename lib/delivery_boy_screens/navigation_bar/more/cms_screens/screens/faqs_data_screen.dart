import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/logic/cubit/faqs_data_cubit.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/repository/faqs_repository.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/widgets/faqs_list_widget.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

class FaqsDataScreen extends StatefulWidget {
  const FaqsDataScreen({super.key});

  @override
  State<FaqsDataScreen> createState() => _FaqsDataScreenState();
}

class _FaqsDataScreenState extends State<FaqsDataScreen> {
  late FaqsDataCubit faqsDataCubit;

  @override
  void initState() {
    faqsDataCubit = FaqsDataCubit(FaqsRepository());
    faqsDataCubit.featchFaqsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: faqsDataCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
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
          title: CommonProximaNovaTextWidget(
            text: "Faqs",
            fontSize: 14,
            color: ColorsData.themeColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: BlocBuilder<FaqsDataCubit, FaqsDataState>(
          builder: (context, faqsDataState) {
            if (faqsDataState.dataLoading) {
              return const CircularProgressIndicator();
            } else if (faqsDataState.error != null) {
              return CommonProximaNovaTextWidget(text: faqsDataState.error!);
            } else {
              final faqs = faqsDataState.faqsResponseModel;

              if (faqs != null) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: faqs.data.length,
                      itemBuilder: (context, index) {
                        return FAQsWidget(
                          faqContent: faqs.data[index].answer,
                          showContent: faqsDataState.currentIndex == index
                              ? false
                              : true,
                          title: faqs.data[index].question,
                          viewContent: () {
                            context
                                .read<FaqsDataCubit>()
                                .updateCurrentIndex(index);
                          },
                        );
                      }),
                );
              } else {
                return const CircularProgressIndicator();
              }
            }
          },
        ),
      ),
    );
  }
}
