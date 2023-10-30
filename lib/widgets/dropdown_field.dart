import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
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

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  final TextEditingController fieldTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fieldTextEditingController.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(fieldTextEditingController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return widget.items
            .where((String option) => option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      onSelected: (text) => fieldTextEditingController.text = text,
      fieldViewBuilder: (BuildContext context, fieldTextEditingController,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        fieldTextEditingController.text = widget.initialValue ?? '';
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          decoration: widget.decoration,
          style: widget.textStyle,
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
        );
      },
    );
  }
}
