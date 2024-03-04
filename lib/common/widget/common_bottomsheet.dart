import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import 'common_text_style.dart';

class CommonBottomSheet extends StatelessWidget {
  final String? title;
  final String? textConfirm;
  final String? textCancel;
  final Color? textCancelColor;
  final Color? textConfirmColor;
  final Function()? onConfirm;
  final Function()? onCancel;

  const CommonBottomSheet(
      {super.key,
      this.title,
      this.textConfirm,
      this.textCancel,
      this.onConfirm,
      this.onCancel,
      this.textCancelColor,
      this.textConfirmColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: context.sizeDevice.height * 0.2,
        child: Column(children: [
          Expanded(flex: 2, child: _buildConfirm()),
          SizedBox(height: defaultPadding / 2),
          Expanded(child: _buildCancel()),
          SizedBox(height: defaultPadding / 2)
        ]));
  }

  Widget _buildConfirm() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
            color: dialogColor,
            borderRadius: BorderRadius.circular(defaultBorderRadius)),
        child: Column(children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(defaultPadding / 2),
                  child: Center(
                      child:
                          Text(title ?? "", style: CommonTextStyle.normal())))),
          Container(height: 1, color: kTextColor.withOpacity(0.3)),
          Expanded(
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onConfirm,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(textConfirm ?? "Ok",
                        style: CommonTextStyle.bold(
                            textColor: textConfirmColor ?? kTextColor)))),
          )
        ]));
  }

  Widget _buildCancel() {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onCancel,
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: defaultPadding),
            decoration: BoxDecoration(
                color: dialogColor,
                borderRadius: BorderRadius.circular(defaultBorderRadius)),
            child: Text(textCancel ?? "Cancel",
                style: CommonTextStyle.normal(
                    textColor: textCancelColor ?? kTextColor))));
  }
}
