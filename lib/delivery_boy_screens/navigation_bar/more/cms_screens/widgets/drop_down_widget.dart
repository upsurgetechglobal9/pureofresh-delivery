import 'package:flutter/material.dart';

class ThemeTextFormFieldDropDown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(T?)? validator;
  final String? label;
  final String? hint;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final T? value;

  const ThemeTextFormFieldDropDown({
    Key? key,
    required this.items,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.contentPadding,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: DropdownButtonFormField<T>(
          value: value,
          items: items,
          icon: suffixIcon,
          onChanged: onChanged,
          isExpanded: true,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            contentPadding: contentPadding,
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            isDense: false,
            hintStyle:  const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,fontFamily: 'ProximaNova'),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.black12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
}
