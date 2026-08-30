import 'package:flutter/material.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

class OnlineOflineStatus extends StatelessWidget {
  final String status;
  final VoidCallback SwitchFun;
  const OnlineOflineStatus(
      {super.key, required this.status, required this.SwitchFun});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: SwitchFun,
      child: Container(
          height: 25,
          width: 75,
          decoration: BoxDecoration(
              color: status == "Online" ? const Color(0xFF7EC245) : Colors.red,
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                status != "Online"
                    ? const CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.white,
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                CommonProximaNovaTextWidget(
                  text: status,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                status != "Online"
                    ? const SizedBox(
                        height: 0,
                      )
                    : const CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.white,
                      )
              ],
            ),
          )),
    );
  }
}
