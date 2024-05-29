import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/utils/color_utils.dart';

import '../../utils/localizations.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final String type;
  final VoidCallback onConfirm;

  ConfirmDialog({
    Key? key,
    required this.message,
    required this.type,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = '';
    String confirmText = '';

    if (type == 'confirm') {
      imagePath = 'assets/images/dialog/undraw_confirm.svg';
      confirmText = MyLocalizations.translate("text_Confirm");
    } else if (type == 'delete') {
      imagePath = 'assets/images/no_data/undraw_throw_away.svg';
      confirmText = MyLocalizations.translate("button_Delete");
    } else if (type == 'error'){
      imagePath = 'assets/images/dialog/error_date_picker.svg';
      confirmText = MyLocalizations.translate("text_OK");
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.only(top: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              imagePath,
              width: 75,
              height: 75,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(
                  color: subTextColor,
                  fontFamily: 'prompt',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (type != 'error') // Show cancel button for 'confirm' and 'delete' types
          TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MyLocalizations.translate("text_Cancel"),
              style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'prompt')),
        ),
        Container(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: type == 'delete' ? Colors.red : primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
