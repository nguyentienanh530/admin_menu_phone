import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/order/data/model/food_dto.dart';

class PrintBottomSheet extends StatelessWidget {
  const PrintBottomSheet(
      {super.key, required this.listFoodDto, required this.onPressedPrint});
  final List<FoodDto> listFoodDto;
  final void Function()? onPressedPrint;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      AppBar(
          backgroundColor: context.colorScheme.primary.withOpacity(0.1),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Danh sách món ăn', style: context.titleStyleMedium),
          actions: [
            IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.highlight_remove_rounded))
          ]),
      Expanded(
          child: ListView.builder(
              itemCount: listFoodDto.length,
              itemBuilder: (context, index) => Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 10,
                  child: ListTile(
                      dense: true,
                      leading: FittedBox(child: Text('#${index + 1}')),
                      subtitle: Text(
                          'Số lượng: ${listFoodDto[index].quantity.toString()}'),
                      title: Text(listFoodDto[index].foodName),
                      trailing: Text(
                          Ultils.currencyFormat(double.parse(
                              listFoodDto[index].totalPrice.toString())),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.secondary)))))),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      context.colorScheme.tertiaryContainer)),
              onPressed: onPressedPrint,
              icon: const Icon(Icons.print),
              label: const Text('In')))
    ]));
  }
}
