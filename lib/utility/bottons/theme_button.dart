import 'package:flutter/material.dart';

import '../widgets/theme_spinner.dart';

class ThemeElevatedButton extends StatelessWidget {
  final String buttonName;
  final Widget? suffix;
  final bool showLoadingSpinner;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final double textFontSize;
  final double loadingSpinnerSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool disableButton;
  const ThemeElevatedButton({
    Key? key,
    this.showLoadingSpinner = false,
    this.disableButton = false,
    required this.buttonName,
    this.suffix,
    this.onPressed,
    this.textFontSize = 15,
    this.loadingSpinnerSize = 30,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height ?? 50,
        width: width ?? double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            foregroundColor: MaterialStateProperty.all(foregroundColor),
          ),
          onPressed: disableButton
              ? null
              : () {
                  if (onPressed != null && !showLoadingSpinner) {
                    onPressed!.call();
                  }
                },
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
            child: showLoadingSpinner
                ? ThemeSpinner(
                    color: foregroundColor ?? Colors.white,
                    size: loadingSpinnerSize,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        buttonName,
                        style: TextStyle(
                          color: foregroundColor ?? Colors.white,
                          fontSize: textFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (suffix != null) suffix!,
                    ],
                  ),
          ),
        ),
      );
}
