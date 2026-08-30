import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';

class Swipperbuttonwidget extends StatelessWidget {
  final VoidCallback onSwipeFun;
  final String buttonTitle;
  const Swipperbuttonwidget(
      {super.key, required this.onSwipeFun, required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return SwipeButton(
      activeTrackColor: ColorsData.themeColor,
      duration: const Duration(milliseconds: 900),
      thumbPadding: EdgeInsets.all(3),
      activeThumbColor: Colors.white,
      thumb: Icon(
        Icons.double_arrow_rounded,
        color: ColorsData.themeColor,
        size: 18,
      ),
      elevationThumb: 2,
      elevationTrack: 2,
      child: Text(
        buttonTitle,
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onSwipeEnd: onSwipeFun,
      //  () {
      //   setState(() {
      //     delayValue = true;
      //   });
      //   Timer(const Duration(seconds: 2), () {
      //     setState(() {
      //       delayValue = false;
      //       buttonindex = true;
      //     });
      //   });

      //   // ScaffoldMessenger.of(context).showSnackBar(
      //   //   SnackBar(
      //   //     content: Text("Swipped"),
      //   //     backgroundColor: Colors.green,
      //   //   ),
      //   // );
      // },
    );
  }
}
