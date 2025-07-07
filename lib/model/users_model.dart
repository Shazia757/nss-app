import 'package:nss/model/volunteer_model.dart';

class LoginResponse {
  bool? status;
  String? message;
  String? role;
  String? token;
  Users? data;

  LoginResponse(
      {required this.status,
      required this.data,
      required this.role,
      this.message,
      this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: json['data'] != null
          ? Users.fromJson(json['data'] as Map<String, dynamic>)
          : Users(),
      status: json['status'] as bool?,
      message: json['message'] as String?,
      role: json['role'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'role': role, 'token': token};
  }

  @override
  String toString() {
    return 'status:$status,message:$message';
  }
}

class GeneralResponse {
  bool? status;
  String? message;

  GeneralResponse({required this.status, this.message});

  factory GeneralResponse.fromJson(Map<String, dynamic> json) {
    return GeneralResponse(
        status: json['status'] as bool?, message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }

  @override
  String toString() {
    return 'Add_volunteer(status:$status,message:$message)';
  }
}
