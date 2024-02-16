import 'package:flutter/material.dart';

import '../utils/utils.dart';

// import 'widgets.dart';

class CommonLineText extends StatelessWidget {
  final String? title, value;
  final Color? color;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  final bool? isDarkText;
  const CommonLineText(
      {super.key,
      this.title,
      this.value,
      this.color,
      this.titleStyle,
      this.isDarkText = false,
      this.valueStyle});
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: RichText(
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              text: title ?? "",
              style: titleStyle ?? context.textStyleSmall!,
              // CommonTextStyle.normal(
              //     fontSize: kTextSizeSmall,
              //     textColor: isDarkText! ? kBlackColor : kTextColor),
              children: <TextSpan>[
                TextSpan(
                    text: value ?? '',
                    style: valueStyle ??
                        context.textTheme.bodySmall!
                            .copyWith(color: color ?? kTextColor)
                    // MyTextStyle.bold(
                    //     fontSize: kTextSizeSmall,
                    //     textColor: color ?? kTextColor)
                    )
              ])),
    );
  }
}
