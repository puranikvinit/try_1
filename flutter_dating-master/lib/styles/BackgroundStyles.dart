import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:folx_dating/styles/StringConstants.dart';

final String svgBgAsset = 'assets/images/folx_bg.svg';

final String femaleAsset = imagePath + 'ic_female.svg';
final String maleAsset = imagePath + 'ic_male.svg';

Widget svg(assetName, colorCode) => SvgPicture.asset(
      assetName,
      semanticsLabel: 'Acme Logo',
      color: colorCode,
    );

//getting svg util
// Widget getSvgWidget(String asset) {
//   return SvgPicture.asset(asset);
// }
//
// final Widget svg = SvgPicture.asset(svgBgAsset);
