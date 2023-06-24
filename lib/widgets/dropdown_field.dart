import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  DropdownField({
    Key? key,
    required this.items,
    this.decoration,
    this.textStyle,
    this.onSaved,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  final List<String> items;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;
  final TextEditingController fieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return items
            .where((String option) => option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      onSelected: (text) => fieldTextEditingController.text = text,
      fieldViewBuilder: (BuildContext context, fieldTextEditingController,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        fieldTextEditingController.text = initialValue ?? '';
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: decoration,
          style: textStyle,
          onSaved: onSaved,
          onChanged: onChanged,
        );
      },
    );
  }
}
