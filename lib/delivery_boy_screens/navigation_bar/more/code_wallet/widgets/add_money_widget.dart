import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utility/colors_data.dart';

class WalletBalanceCardWidget extends StatelessWidget {
  final String balance;
  final VoidCallback onTapFun;
  const WalletBalanceCardWidget({
    Key? key,
    required this.balance,
    required this.onTapFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: ColorsData.themeColor,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/images/wallet.svg",
                    )),
                const SizedBox(
                  width: 15,
                  height: 0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(
                          fontFamily: 'MontserratSemiBold',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    Text(
                      '₹ $balance',
                      style: const TextStyle(
                          fontFamily: 'MontserratSemiBold',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: onTapFun,
              child: SizedBox(
                height: 30,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 179, 53, 44),
                  ),
                  child: const Center(
                      child: Text(
                    'ADD CASH',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
