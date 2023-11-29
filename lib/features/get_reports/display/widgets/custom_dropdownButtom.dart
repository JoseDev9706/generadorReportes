import 'package:flutter/material.dart';
import 'package:generadorreportes/core/utils/ui_utils.dart';

class CustomDropdown extends StatelessWidget {
  final String selectedValue;
  final List<String> itemList;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.itemList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: itemList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            width: UiUtils().screenWidth * 0.5,
            child: Text(
              value,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis, fontSize: 12),
            ),
          ),
        );
      }).toList(),
    );
  }
}
