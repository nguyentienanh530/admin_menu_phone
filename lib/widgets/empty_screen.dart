import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          flex: 4,
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black38, shape: BoxShape.circle),
              margin: EdgeInsets.all(defaultPadding),
              child: Image.asset("assets/image/empty.png"))),
      Expanded(
          child: Center(
              child: Text("Không có sản phẩm",
                  style: CommonTextStyle.bold(fontSize: kTextSizeLarge)))),
      Expanded(
          child: Center(
              child: Text(
                  "Xin lỗi, chúng tôi không thể tìm thấy bất kỳ kết quả nào cho mặt hàng của bạn.",
                  style: CommonTextStyle.light(fontSize: kTextSizeSmall),
                  textAlign: TextAlign.center)))
    ]);
  }
}
