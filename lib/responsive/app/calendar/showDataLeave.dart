import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/responsive/app/calendar/leave_set/annual.dart';
import 'package:untitled/utils/localizations.dart';

import '../../../utils/style.dart';
import 'leave_set/leave_model.dart';

class ShowDataLeave extends StatefulWidget {
  final List<LeaveModel>? listLeaves;
  const ShowDataLeave({Key? key, this.listLeaves}) : super(key: key);

  @override
  State<ShowDataLeave> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowDataLeave> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<LeaveModel>? listLeaves = widget.listLeaves ?? [];
    var today = DateFormat('d/M/y').format(DateTime.now());
    listLeaves = listLeaves
        .where(
            (element) => element.status == "approved" && element.date == today)
        .toList();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MyLocalizations.translate("text_Leave"),
                      style: text,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                            '${listLeaves.length} ${MyLocalizations.translate("text_People")}'))
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Annual(
                        listLeaves: listLeaves,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
