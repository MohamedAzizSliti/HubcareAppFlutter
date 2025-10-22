import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConstImage{

  Widget buildImage(String assetName, double width,double height) {
    return Image.asset('assets/$assetName', width: width,height: height,);
  }

  Widget buildSvgImage(String assetName, double width) {
    return SvgPicture.asset('assets/$assetName', width: width);
  }
  Widget buildSvgImage1(String assetName, double width, double height) {
    return SvgPicture.asset('assets/$assetName', width: width,height: height,);
  }
}