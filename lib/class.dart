import 'package:flutter/material.dart';

class customText extends Text{
  customText(String data, {factor = 1.3, Color = Colors.white, textAlign = TextAlign.center}):
      super(
       data,
       textAlign: textAlign,
       textScaleFactor: factor,
       style: TextStyle(
         color: Color,
       )
      );
}

