class WorkSession {
  final DateTime checkIn;
  final DateTime checkOut;

  WorkSession({
    required this.checkIn,
    required this.checkOut,
  });

  Duration get duration => checkOut.difference(checkIn);
}