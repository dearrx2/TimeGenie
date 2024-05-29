import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utils/color_utils.dart';
import '../utils/localizations.dart';

class DatePicker extends StatelessWidget {
  final DateTime? initialDate;
  final List<String>? disableDate;

  DatePicker({this.initialDate, this.disableDate});

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate = initialDate;

    // Define a list of translated day names
    final translatedDayNames = [
      MyLocalizations.translate("text_Sunday"),
      MyLocalizations.translate("text_Monday"),
      MyLocalizations.translate("text_Tuesday"),
      MyLocalizations.translate("text_Wednesday"),
      MyLocalizations.translate("text_Thursday"),
      MyLocalizations.translate("text_Friday"),
      MyLocalizations.translate("text_Saturday"),
    ];

    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.height * 0.4,
        child: SfDateRangePicker(
          view: DateRangePickerView.month,
          showNavigationArrow: true,
          monthViewSettings: const DateRangePickerMonthViewSettings(
            showTrailingAndLeadingDates: false,
          ),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value is DateTime) {
              selectedDate = args.value;
            }
          },
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedDate: selectedDate,
          minDate: DateTime.now(),
          maxDate: DateTime.now().add(const Duration(days: 365)),
          selectableDayPredicate: (DateTime date) {
            if (disableDate != null) {
              String formattedDate = DateFormat('d/M/yyyy').format(date);
              return date.weekday != DateTime.saturday &&
                  date.weekday != DateTime.sunday &&
                  !disableDate!.contains(formattedDate);
            }
            // Use translated day names here
            return date.weekday != DateTime.saturday &&
                date.weekday != DateTime.sunday &&
                !translatedDayNames.contains(MyLocalizations.translate("text_${date.weekday}"));
          },
        ),
      ),

      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MyLocalizations.translate("text_Cancel"), style: TextStyle(color: grey)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(selectedDate),
          child: Text(MyLocalizations.translate("text_OK"), style: TextStyle(color: orange)),
        ),
      ],
    );
  }
}


class RangeDatePickerDialog extends StatelessWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime? startDate, DateTime? endDate) onSelected;
  final List<String>? disableDate;
  final bool isSickLeaveRequest;

  RangeDatePickerDialog({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onSelected,
    required this.disableDate,
    required this.isSickLeaveRequest
  });

  @override
  Widget build(BuildContext context) {
    DateTime? startDate = initialStartDate;
    DateTime? endDate = initialEndDate;

    // Calculate the minimum date based on the flag
    DateTime minDate = DateTime.now();
    if (isSickLeaveRequest) {
      // If it's for sick leave, set minDate to one month ago
      minDate = minDate.subtract(Duration(days: 5));
    }

    // Customizing the size of the calendar popup
    final double dialogWidth = MediaQuery.of(context).size.width * 0.65;
    final double dialogHeight = MediaQuery.of(context).size.height * 0.4;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dialogWidth,
            height: dialogHeight,
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  startDate = args.value.startDate;
                  endDate = args.value.endDate ?? args.value.startDate;
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(startDate, endDate),
              minDate: minDate, // Set minDate based on the flag
              maxDate: DateTime.now().add(const Duration(days: 365)),
              selectableDayPredicate: (DateTime date) {
                if (disableDate != null) {
                  String formattedDate = DateFormat('d/M/yyyy').format(date);
                  return date.weekday != DateTime.saturday &&
                      date.weekday != DateTime.sunday &&
                      !disableDate!.contains(formattedDate);
                }
                return date.weekday != DateTime.saturday &&
                    date.weekday != DateTime.sunday;
              },
            ),
          ),
          const SizedBox(
            height: 2.0, // Add desired height between content and actions
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MyLocalizations.translate("text_Cancel"), style: TextStyle(color: grey)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onSelected(startDate, endDate);
          },
          child: Text(MyLocalizations.translate("text_OK"), style: TextStyle(color: orange)),
        ),
      ],
    );
  }
}
