import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:intl/intl.dart';

class DatePickerTextField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String value) onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? hintText;
  final DateTime initialDate;
  final DateTime firstDate;
  const DatePickerTextField({
    Key? key,
    this.controller,
    this.hintText,
    required this.initialDate,
    required this.onFieldSubmitted,
    required this.firstDate,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 8),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8)),
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          )),
          suffixIcon: Icon(
            Icons.calendar_month_rounded,
            size: 20,
            color: ColorsData.themeColor,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onTap: () async {
          await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: DateTime.now(),
          ).then(
            (value) => value != null && controller != null
                ? controller!.text = DateFormat('dd-MM-yyyy').format(value)
                : null,
          );
        },
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted);
  }
}
