import 'package:flutter/material.dart';
import 'package:folx_dating/styles/StringConstants.dart';

class TextIcon extends StatelessWidget {
  final IconData _icon;
  final String _text;
  final double iconTransform;
  final double iconSize;
  TextIcon(this._icon, this._text, {this.iconTransform, this.iconSize = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Transform.rotate(
            angle: iconTransform == null ? 0 : iconTransform,
            child: Container(
              child: Icon(
                _icon,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            _text,
            style: getDefaultTextStyle().copyWith(
              letterSpacing: 0.16,
            ),
          )
        ],
      ),
    );
  }
}
