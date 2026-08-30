import 'package:flutter/material.dart';

import '../../../../../utility/bottons/theme_button.dart';


class NoServicesSheet extends StatelessWidget {
  final String messageData;
  Function()? onPressed;
  NoServicesSheet({super.key, required this.messageData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              'assets/images/nodata.png',
              height: 90,
              width: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: messageData,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'ProximaNova',
                        overflow: TextOverflow.ellipsis),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.map,
                      color: Colors.blue.shade900, // Change color as needed
                      size: 20, // Change size as needed
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            ThemeElevatedButton(
              buttonName: 'Continue',
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
