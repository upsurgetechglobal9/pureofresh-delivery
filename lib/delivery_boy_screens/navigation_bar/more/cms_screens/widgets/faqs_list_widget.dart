import 'package:flutter/material.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

class FAQsWidget extends StatelessWidget {
  final String faqContent, title;
  final bool showContent;
  final Function()? viewContent;
  const FAQsWidget(
      {super.key,
      required this.faqContent,
      required this.title,
      required this.showContent,
      required this.viewContent});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.only(left: 10, top: -5, bottom: -5),
              title: CommonProximaNovaTextWidget(text: title),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                child: IconButton(
                    icon: Icon(showContent
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up),
                    iconSize: 20,
                    color: Colors.black,
                    onPressed: viewContent),
              ),
            ),
            !showContent
                ? Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 0, bottom: 10),
                    child: Transform.translate(
                      offset: const Offset(-3, 0),
                      child: CommonProximaNovaTextWidget(text: faqContent),
                    ),
                  )
                : Container()
          ]),
    );
  }
}
