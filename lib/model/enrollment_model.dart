import 'package:nss/model/volunteer_model.dart';

class ProgramEnrollmentDetails {
  DateTime? date;
  int? id;
  int? program;
  Volunteer? volunteer;

  ProgramEnrollmentDetails({
    this.id,
    this.date,
    this.volunteer,
    this.program,
  });

  factory ProgramEnrollmentDetails.fromJson(Map<String, dynamic> json) {
    return ProgramEnrollmentDetails(
        id: json['id'] as int?,
        volunteer: Volunteer.fromJson(json['volunteer']),
        date: DateTime.tryParse(json['enrollment_date']),
        program: json['id'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enrollment_date': date?.toString(),
      'volunteer': volunteer?.toJson(),
      'program': program?.toString()
    };
  }
}

class EnrollmentResponse {
  bool? status;
  String? message;
  List<ProgramEnrollmentDetails>? enrollmentList;

  EnrollmentResponse({
    this.status,
    this.message,
    this.enrollmentList,
  });

  factory EnrollmentResponse.fromJson(Map<String, dynamic> json) {
    return EnrollmentResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      enrollmentList: (json['enrollment_list'] as List<dynamic>?)
          ?.map((e) =>
              ProgramEnrollmentDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'enrollment_list': enrollmentList?.map((e) => e.toJson()).toList(),
    };
  }
}
