

class TimeSlot {
  int slotId;
  DateTime start;
  DateTime endTime;
  bool isAvailable;

  TimeSlot({
    required this.slotId,
    required this.start,
    required this.endTime,
    this.isAvailable = true,
  });

  Duration get duration => endTime.difference(start);
}