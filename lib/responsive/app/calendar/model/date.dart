class DateModel {
  final String dateString;
  final DateTime date;
  final bool isCurrentMonth; // color
  final bool isCurrentDate; // symbol
  final bool isCurrentWeekend;
  late List<Event> listEvents;

  DateModel({
    required this.dateString,
    required this.date,
    required this.isCurrentMonth,
    required this.isCurrentDate,
    required this.isCurrentWeekend,
    required this.listEvents,
  });

  factory DateModel.fromJson(Map<String, dynamic> json) {
    List<Event> eventsList = List<Event>.from(
      json['listEvents'].map((event) => Event.fromJson(event)),
    );

    return DateModel(
      dateString: json['dateString'],
      date: json['date'],
      isCurrentMonth: json['isCurrentMonth'],
      isCurrentDate: json['isCurrentDate'],
      isCurrentWeekend: json['isCurrentWeekend'],
      listEvents: eventsList,
    );
  }
}

class Event {
  final String userId;
  final String type;
  final String dateString;
  final DateTime startDate;
  final DateTime endDate;
  final String image;
  final String status;

  Event(
      {required this.userId,
      required this.type,
      required this.dateString,
      required this.startDate,
      required this.endDate,
      required this.image,
      required this.status});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        userId: json['userId'],
        type: json['type'],
        dateString: json['dateString'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        image: json['image'],
        status: json['status']);
  }
}
