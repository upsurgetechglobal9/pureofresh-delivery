import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeliveryBoyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String? text)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;
  final String? label;
  final String? hint;
  final int? maxLines;
  final bool? enabled;
  final bool? isDense;
  final bool autofocus;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Color? fillColor;
  final bool readOnly;
  final bool obscureText;
  final double topPadding;
  final double bottomPadding;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? style;
  DeliveryBoyTextFormField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.words,
    this.label,
    this.hint,
    this.enabled,
    this.autofocus = false,
    this.onTap,
    this.isDense,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.fillColor,
    this.topPadding = 15,
    this.bottomPadding = 0,
    this.readOnly = false,
    this.obscureText = false,
    this.contentPadding,
    this.hintStyle,
    this.style,
  }) : super(key: key);

  final OutlineInputBorder activeBorderStyle = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
    borderRadius: BorderRadius.circular(8),
  );
  final OutlineInputBorder deActiveBorderStyle = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Colors.grey.shade200),
    borderRadius: BorderRadius.circular(8),
  );
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: autofocus,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          onTap: onTap,
          style: style,
          decoration: InputDecoration(
            isDense: isDense,
            contentPadding: contentPadding,
            suffixIcon: suffixIcon,
            prefix: prefix,
            prefixIcon: prefixIcon,
            hintText: hint,
            hintStyle: hintStyle,
            labelText: label,
            filled: true,
            fillColor: fillColor ?? Colors.white,
            focusedBorder: activeBorderStyle,
            enabledBorder: deActiveBorderStyle,
            focusedErrorBorder: activeBorderStyle,
            errorBorder: deActiveBorderStyle,
            disabledBorder: deActiveBorderStyle,
          ),
        ),
      );
}
