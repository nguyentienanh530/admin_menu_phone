import 'package:flutter/material.dart';
import '../utils/utils.dart';

class DisplayWhiteText extends StatelessWidget {
  const DisplayWhiteText({
    super.key,
    required this.text,
    this.size,
    this.fontWeight,
  });
  final String text;
  final double? size;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: context.textStyleSmall?.copyWith(
            color: context.colorScheme.surface,
            fontSize: size,
            fontWeight: fontWeight ?? FontWeight.w300));
  }
}
