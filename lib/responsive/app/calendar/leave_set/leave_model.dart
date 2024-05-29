class LeaveModel {
  final String userID;
  final String date;
  final String status;
  final String type;
  final DateTime startDate;
  final DateTime endDate;

  LeaveModel(this.userID, this.date, this.status, this.type, this.startDate,
      this.endDate);
}
