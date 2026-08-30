import 'package:flutter/material.dart';

class TabItemWidget extends StatelessWidget {
  final String title;
  final Color color;
  const TabItemWidget({super.key, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          color: color),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
