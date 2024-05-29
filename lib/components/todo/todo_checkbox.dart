import 'package:flutter/material.dart';
import 'package:untitled/utils/color_utils.dart';

import '../../utils/localizations.dart';
import '../dialog/dialog.dart';

class TodoCheckbox extends StatefulWidget {
  final bool isChecked;
  final Color borderColor;
  final Color checkedColor;
  final Color checkIconColor;
  final ValueSetter<bool> onToggle;

  const TodoCheckbox({
    Key? key,
    required this.isChecked,
    this.borderColor = Colors.green,
    this.checkedColor = Colors.green,
    this.checkIconColor = white,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<TodoCheckbox> createState() => _TodoCheckboxState();
}

class _TodoCheckboxState extends State<TodoCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show the confirmation dialog when the checkbox is tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog(
              type: 'confirm',
              message: MyLocalizations.translate("text_CheckboxStatus"),
              onConfirm: () {
                setState(() {
                  isChecked = !isChecked;
                  widget.onToggle(isChecked);
                });
              },
            );
          },
        );

      },
      child: Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.borderColor,
            width: 2.0,
          ),
          color: isChecked ? widget.checkedColor : Colors.transparent,
        ),
        child: isChecked
            ? Icon(
          Icons.check_rounded,
          size: 24.0,
          color: widget.checkIconColor,
        )
            : const Icon(
          Icons.check_rounded,
          size: 24.0,
          color: Colors.transparent, // Set the color to transparent
        ),
      ),
    );
  }
}
