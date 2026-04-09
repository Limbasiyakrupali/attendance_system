
class Attendance {
  final DateTime date;
  final String checkIn1;
  final String checkOut1;
  final String checkIn2;
  final String checkOut2;
  final String totalHours;

  Attendance({
    required this.date,
    required this.checkIn1,
    required this.checkOut1,
    required this.checkIn2,
    required this.checkOut2,
    required this.totalHours,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['workDate']);

    DateTime? in1 = json['checkIn'] != null
        ? DateTime.parse(json['checkIn']).toLocal()
        : null;

    DateTime? out1 = json['checkOut'] != null
        ? DateTime.parse(json['checkOut']).toLocal()
        : null;

    DateTime? in2 = json['checkIn2'] != null
        ? DateTime.parse(json['checkIn2']).toLocal()
        : null;

    DateTime? out2 = json['checkOut2'] != null
        ? DateTime.parse(json['checkOut2']).toLocal()
        : null;

    return Attendance(
      date: date,
      checkIn1: _format(in1),
      checkOut1: _format(out1),
      checkIn2: _format(in2),
      checkOut2: _format(out2),
      totalHours: _total(in1, out1, in2, out2),
    );
  }

  static String _format(DateTime? dt) {
    if (dt == null) return "--";

    int h = dt.hour % 12;
    if (h == 0) h = 12;

    String m = dt.minute.toString().padLeft(2, '0');
    String ampm = dt.hour >= 12 ? "PM" : "AM";

    return "$h:$m $ampm";
  }

  static String _total(
      DateTime? in1,
      DateTime? out1,
      DateTime? in2,
      DateTime? out2,
      ) {
    Duration d = Duration();

    if (in1 != null && out1 != null) {
      d += out1.difference(in1);
    }

    if (in2 != null && out2 != null) {
      d += out2.difference(in2);
    }

    return "${d.inHours}h ${d.inMinutes % 60}m";
  }
}
class AttendanceModel {
  DateTime? checkIn;
  DateTime? checkOut;
  DateTime? secondCheckIn;
  DateTime? secondCheckOut;

  AttendanceModel({this.checkIn, this.checkOut, this.secondCheckIn, this.secondCheckOut});

  factory AttendanceModel.fromJson(Map<String,dynamic> json){
    return AttendanceModel(
      checkIn: json['checkIn'] != null
          ? DateTime.parse(json['checkIn']).toLocal()
          : null,
      checkOut: json['checkOut'] != null
          ? DateTime.parse(json['checkOut']).toLocal()
          : null,
      secondCheckIn: json['checkIn2'] != null
          ? DateTime.parse(json['checkIn2']).toLocal()
          : null,
      secondCheckOut: json['checkOut2'] != null
          ? DateTime.parse(json['checkOut2']).toLocal()
          : null,
    );
  }
}

class UserAttendanceModel {
  final String userId;
  final String name;
  final String department;
  final String? checkIn1;
  final String? checkOut1;
  final String? checkIn2;
  final String? checkOut2;

  UserAttendanceModel({
    required this.userId,
    required this.name,
    required this.department,
    this.checkIn1,
    this.checkOut1,
    this.checkIn2,
    this.checkOut2,
  });
}