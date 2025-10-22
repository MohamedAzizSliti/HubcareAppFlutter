import 'package:flutter/material.dart';

import 'AppTextStyles.dart';
import 'CustomText.dart';

class HeadlineText extends CustomText {
  const HeadlineText(String text, {super.key, Color? color})
      : super(
    text,
    style: AppTextStyles.headline1,
    color: color,
  );
}

class BodyText extends CustomText {
  const BodyText(String text, {super.key, Color? color})
      : super(
    text,
    style: AppTextStyles.bodyText1,
    color: color,
  );
}

class CaptionText extends CustomText {
  const CaptionText(String text, {super.key, Color? color})
      : super(
    text,
    style: AppTextStyles.caption,
    color: color,
  );
}