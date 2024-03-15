import 'package:admin_menu_mobile/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class CommonIconButton extends StatelessWidget {
  const CommonIconButton(
      {super.key, required this.onTap, this.color, this.icon});
  final void Function()? onTap;
  final Color? color;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: color?.withOpacity(0.2) ??
                    context.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
                border:
                    Border.all(color: color ?? context.colorScheme.secondary)),
            child: Icon(icon ?? Icons.remove_red_eye,
                size: 15, color: color ?? context.colorScheme.secondary)));
  }
}
