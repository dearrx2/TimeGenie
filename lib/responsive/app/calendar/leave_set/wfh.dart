import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/components/calendar/custom_calendar/model.dart';

import '../../../../utils/localizations.dart';

class WFHRange extends StatefulWidget {
  final List<Event> listEvent;
  final String day;
  const WFHRange({Key? key, required this.listEvent, required this.day})
      : super(key: key);

  @override
  State<WFHRange> createState() => _WFHRangeState();
}

class _WFHRangeState extends State<WFHRange> {
  final String emptyProfie = 'assets/svg/signup/signup.svg';
  @override
  Widget build(BuildContext context) {
    List<Event>? listEvents = widget.listEvent;
    String selectDay = widget.day;

    return listEvents.isEmpty
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    MyLocalizations.translate("text_NoWFH"),
                  ),
                ]),
          )
        : Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    var imageAsset = "assets/images/calendar/wfh.png";

                    return listEvents[index].dateString == selectDay &&
                            listEvents[index].type == "wfh" &&
                            listEvents[index].status == "approved"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              children: [
                                Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      listEvents[index].image == ""
                                          ? SvgPicture.asset(
                                              emptyProfie,
                                              width: 60,
                                              height: 60,
                                            )
                                          : ClipOval(
                                              child: Image.network(
                                                listEvents[index].image,
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      Image.asset(
                                        imageAsset,
                                        width: 26,
                                        height: 26,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ]),
                                Text(
                                    "${listEvents[index].name.split(" ")[0]} ${listEvents[index].name.split(" ")[1].substring(0, 1)}")
                              ],
                            ))
                        : Container();
                  },
                ),
              ),
            ],
          );
  }
}
