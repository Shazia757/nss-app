import 'package:nss/model/department.dart';

class Users {
  String? admissionNo;
  String? name;
  String? email;
  String? phoneNo;
  DateTime? dob;
  DateTime? createdDate;
  DateTime? updatedDate;
  Department? department;
  String? role;
  String? caste;
  String? gender;
  String? rollNo;
  String? createdBy;
  String? updatedBy;
  String? year;

  Users(
      {this.admissionNo,
      this.name,
      this.email,
      this.phoneNo,
      this.dob,
      this.createdDate,
      this.updatedDate,
      this.department,
      this.role,
      this.rollNo,
      this.createdBy,
      this.updatedBy,
      this.year,
      this.caste,
      this.gender});

  factory Users.fromJson(Map<String, dynamic>? json) {
    return Users(
      admissionNo: json?['admission_number'] as String?,
      name: json?['name'] as String?,
      email: json?['email'] as String?,
      phoneNo: json?['phone_number'] as String?,
      dob: DateTime.tryParse(json?['date_of_birth']),
      createdDate: DateTime.tryParse(json?['created_date']),
      updatedDate: DateTime.tryParse(json?['updated_date']),
      department: json?['department'] != null
          ? Department.fromJson(json?['department'])
          : null,
      role: json?['role'] as String?,
      rollNo: json?['roll_number'] as String?,
      createdBy: json?['created_by'] as String?,
      updatedBy: json?['updated_by'] as String?,
      year: json?['year'] as String?,
      caste: json?['caste'] as String?,
      gender: json?['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admission_number': admissionNo,
      'roll_number': rollNo,
      'role': role,
      'phone_number': phoneNo,
      'name': name,
      'email': email,
      'department': department?.toJson(),
      'date_of_birth': dob?.toString(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_date': createdDate?.toString(),
      'updated_date': updatedDate?.toString(),
      'year': year,
      'caste': caste,
      'gender': gender,
    };
  }

  @override
  String toString() {
    return 'Login(username:$admissionNo,name:$name)';
  }
}

class VolunteerList {
  bool? status;
  String? message;
  List<Volunteer>? data;

  VolunteerList({this.status, this.message, this.data});

  factory VolunteerList.fromJson(Map<String, dynamic> json) {
    return VolunteerList(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Volunteer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class VolunteerDetailResponse {
  bool? status;
  String? message;
  Users? volunteerDetails;

  VolunteerDetailResponse({this.status, this.message, this.volunteerDetails});

  factory VolunteerDetailResponse.fromJson(Map<String, dynamic> json) {
    return VolunteerDetailResponse(
        status: json['status'] as bool?,
        message: json['message'] as String?,
        volunteerDetails: Users.fromJson(json['volunteer_details']));
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'volunteer_details': volunteerDetails?.toJson(),
    };
  }
}

class Volunteer {
  String? admissionNo;
  String? name;
  Department? department;
  String? role;

  Volunteer({this.admissionNo, this.name, this.department, this.role});

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
        admissionNo: json['admission_number'] as String?,
        name: json['name'] as String?,
        department: Department.fromJson(json['department']),
        role: json['role'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'admission_number': admissionNo,
      'name': name,
      'department': department?.toJson(),
      'role': role
    };
  }
}
