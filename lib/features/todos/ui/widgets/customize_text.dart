import 'package:flutter/material.dart';

class CustomizeText extends StatelessWidget {
  const CustomizeText({super.key, required this.text, this.fontSize, this.fontWeight, this.colors});

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: colors
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
