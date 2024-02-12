import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({super.key, this.text, this.onTap});
  final String? text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
        icon: const Icon(Icons.arrow_forward_rounded),
        onPressed: onTap,
        label: Text(text ?? '', style: context.textStyleMedium));
  }
}
