import 'package:flutter/material.dart';

import '../Constants/ColorCodes.dart';


class DropDownButtonWidget extends StatelessWidget {
  final List<String> itmes;
  final String lable;
  final int? value;
  final double height;
  final void Function(int?)? onChanged;
  const DropDownButtonWidget(
      {required this.itmes,
      required this.lable,
      required this.onChanged,
      required this.value,
      this.height = 40,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      height: height,
      child: DropdownButtonFormField(
        isExpanded: true,
        value: value,
        icon: const Icon(
          Icons.keyboard_arrow_down_sharp,
          size: 20,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.inputColor, width: 1.5),
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "${""} $lable",
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.textTheme.bodySmall!.color!.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ),
        onChanged: onChanged,
        items: List.generate(
          itmes.length,
          (index) => DropdownMenuItem(
            value: index,
            child: Text(
              itmes[index],
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.textTheme.bodySmall!.color!.withOpacity(0.8),
              ),
            ),
          ),
        ).toList(),
      ),
    );
  }
}
