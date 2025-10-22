import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import 'ColorCodes.dart';

class Shap {
  BoxDecoration baseBackgroundDecoration() {
    return BoxDecoration(
        border:  GradientBoxBorder(
        gradient: LinearGradient(colors: [AppColors.themeColor, AppColors.themeColor]),
        ),
      color: AppColors.inputColor,
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),

    );
  }

  BoxDecoration baseBackgroundDecoration2() {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.grayColor99.withOpacity(.5),
      ),
      color: AppColors.whiteColor.withOpacity(.5),
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    );
  }

  BoxDecoration roundBackgroundDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.grayColor99.withOpacity(.3),
      ),
      color: AppColors.grayColor99.withOpacity(.3),
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    );
  }
  BoxDecoration dynamicBackgroundDecoration(Color baseColor,Color borderColor, double radius) {
    return BoxDecoration(
      border: Border.all(
        color: borderColor,
      ),
      color: baseColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }
  BoxDecoration roundLiteBackgroundDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.grayColor99.withOpacity(0.2),
      ),
      color: AppColors.whiteColor,
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    );
  }
  BoxDecoration roundWhiteBackground() {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.whiteColor,
      ),
      color: AppColors.whiteColor,
      shape: BoxShape.circle,

    );
  }
}
