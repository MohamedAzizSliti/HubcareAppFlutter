import 'package:flutter/material.dart';

import '../Constants/ColorCodes.dart';


class ButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double width;
  final double height;
  final IconData? icon;
  final double borderRadius;
  final double fontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isLoading;
  const ButtonWidget(
      {required this.text,
      required this.onPressed,
      this.width = double.infinity,
      this.height = 48,
      this.borderRadius = 10,
      this.icon,
      this.backgroundColor,
      this.textColor,
      this.borderColor,
      this.fontSize = 15,
        this.isLoading = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.primaryColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        gradient: backgroundColor == null
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xffB169C9),
                  Color(0xffB169C9),
                ],
              )
            : null,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        height: height,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: textColor ?? AppColors.whiteColor,size: 20,
                  ),
                if (icon != null) const SizedBox(width: 3),
                isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ):
                Text(
                  text,
                  style: theme.textTheme.labelLarge?.copyWith(
                      color: textColor ?? AppColors.whiteColor,
                      fontSize: fontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
