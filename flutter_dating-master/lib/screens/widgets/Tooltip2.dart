import 'package:flutter/material.dart';
import 'package:folx_dating/styles/ColorConstants.dart';
import 'package:folx_dating/styles/StringConstants.dart';

class ToolTip2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Row(
            children: [
              Spacer(),
              Icon(
                Icons.arrow_back,
                color: secondaryBg,
                size: 48,
              ),
              Text(
                'Tap to browse pictures',
                style: getDefaultTextStyle()
                    .copyWith(letterSpacing: 0.64, fontWeight: FontWeight.w600),
              ),
              Icon(
                Icons.arrow_forward,
                color: secondaryBg,
                size: 48,
              ),
              Spacer()
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 120),
            child: Text(
              'Tap Anywhere To Continue',
              style: getDefaultTextStyle().copyWith(
                fontSize: 12,
                letterSpacing: 0.48,
              ),
            ),
          )
        ],
      ),
    );
  }
}
