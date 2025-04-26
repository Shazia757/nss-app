class Attendance {
  int? id;
  String? name;
  DateTime? date;
  String? markedBy;
  int? hours;
  int? admissionNo;

  Attendance({
    this.id,
    this.name,
    this.admissionNo,
    this.date,
    this.hours,
    this.markedBy,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int?,
      name: json['program_name'] as String?,
      admissionNo: json['admission_number'] as int?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      hours: json['hours'] as int?,
      markedBy: json['marked_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'program_name': name,
      'date': date?.toIso8601String(),
      'hours': hours,
      'marked_by': markedBy,
      'admission_number': admissionNo
    };
  }
}

class AttendanceResponse {
  bool? status;
  String? message;
  List<Attendance>? attendance;

  AttendanceResponse({
    this.status,
    this.message,
    this.attendance,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      attendance: (json['attendance_details'] as List<dynamic>?)
          ?.map((e) => Attendance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'attendance_details': attendance?.map((e) => e.toJson()).toList(),
    };
  }
}
