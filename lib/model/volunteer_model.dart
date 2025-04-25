class Users {
  String? admissionNo;
  String? name;
  String? email;
  String? phoneNo;
  DateTime? dob;
  DateTime? createdDate;
  DateTime? updatedDate;
  String? department;
  String? role;
  String? rollNo;
  String? createdBy;
  String? updatedBy;
  String? password;

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
      this.password});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        admissionNo: json['admission_number'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        phoneNo: json['phone_number'] as String?,
        dob: (json['date_of_birth'] != null)
            ? DateTime.parse(json['date_of_birth'])
            : null,
        createdDate: (json['created_date'] != null)
            ? DateTime.parse(json['created_date'])
            : null,
        updatedDate: (json['updated_date'] != null)
            ? DateTime.parse(json['updated_date'])
            : null,
        department: json['department'] as String?,
        role: json['role'] as String?,
        rollNo: json['roll_number'] as String?,
        createdBy: json['created_by'] as String?,
        updatedBy: json['updated_by'] as String?,
        password: null);
  }

  Map<String, dynamic> toJson() {
    return {
      'admission_number': admissionNo,
      'roll_number': rollNo,
      'role': role,
      'phone_number': phoneNo,
      'name': name,
      'email': email,
      'department': department,
      'date_of_birth': dob?.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_date': createdDate?.toIso8601String(),
      'updated_date': updatedDate?.toIso8601String()
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
      volunteerDetails: Users.fromJson(json['volunteer_details'])
       );
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
  String? department;

  Volunteer({this.admissionNo, this.name, this.department});

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      admissionNo: json['admission_number'] as String?,
      name: json['name'] as String?,
      department: json['department'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admission_number': admissionNo,
      'name': name,
      'department': department
    };
  }
}
