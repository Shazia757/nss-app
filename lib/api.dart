import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nss/model/attendance_model.dart';
import 'package:nss/model/department.dart';
import 'package:nss/model/enrollment_model.dart';
import 'package:nss/model/issues_model.dart';
import 'package:nss/model/programs_model.dart';
import 'package:nss/model/users_model.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/common_pages/no_connection_page.dart';

class Urls {}

class Api {
  String baseUrl = 'https://nssapi.bvocfarookcollege.com/api';
  // 'https://nss.noorabiyad.com/api';
  final headers = {"content-type": "application/json"};

//------------------Login---------------------------//

  Future<LoginResponse?> login(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login/'),
            body: jsonEncode(data),
            headers: headers,
          )
          .timeout(Duration(seconds: 60));
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      log(LoginResponse.fromJson(responseJson)
              .data
              .department
              ?.name
              .toString() ??
          "null");
      return LoginResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during login:$e');
    }
    return null;
  }

  //------------------Change Password---------------------------//

  Future<GeneralResponse?> changePassword(Map<String, dynamic> data) async {
    try {
      log("request :${jsonEncode(data)}");
      final response = await http
          .post(Uri.parse('$baseUrl/change_password/'),
              body: jsonEncode(data), headers: headers)
          .timeout(Duration(seconds: 60));
      log(response.body);
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
    }
    return null;
  }
  //------------------Reset Password---------------------------//

  Future<GeneralResponse?> resetPassword(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/reset_password/'),
              body: jsonEncode(data), headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

//------------------List Volunteer---------------------------//

  Future<VolunteerList?> getVolunteers() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/get_volunteers/'))
          .timeout(Duration(seconds: 60));
      log(response.body.toString());
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return VolunteerList.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      // jsonEncode(object)
      return null;
    }
  }
//------------------List Admins---------------------------//

  Future<VolunteerList?> getAdmins() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/get_admins/'))
          .timeout(Duration(seconds: 60));
      log(response.body.toString());
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return VolunteerList.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      // jsonEncode(object)
      return null;
    }
  }

//------------------Get Volunteer Details---------------------------//

  Future<VolunteerDetailResponse?> volunteerDetails(String admissionNo) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/get_volunteer_details/'),
              body: jsonEncode({'admission_number': admissionNo}),
              headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return VolunteerDetailResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

//------------------Add Volunteer---------------------------//

  Future<GeneralResponse?> addVolunteer(Map<String, dynamic> user) async {
    try {
      log("request :${jsonEncode(user)}");

      final response = await http
          .post(Uri.parse('$baseUrl/add_volunteer/'),
              body: jsonEncode(user), headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      log(response.body);

      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

//------------------Update Volunteer---------------------------//

  Future<GeneralResponse?> updateVolunteer(Map<String, dynamic> data) async {
    try {
      log("request :${jsonEncode(data)}");
      final response = await http
          .patch(Uri.parse('$baseUrl/update_volunteer/'),
              body: jsonEncode(data), headers: headers)
          .timeout(Duration(seconds: 60));
      log(response.body);
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

//------------------Delete Volunteer---------------------------//

  Future<GeneralResponse?> deleteVolunteer(String id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/delete_volunteer/'),
              body: jsonEncode({'admission_number': id}), headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

//------------------Get All Programs---------------------------//

  Future<ProgramResponse?> allPrograms() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/get_all_programs/'))
          .timeout(Duration(seconds: 60));
      final responseAsJson = jsonDecode(response.body) as Map<String, dynamic>;
      return ProgramResponse.fromJson(responseAsJson);
    } catch (e) {
      checkConnectivity();
      log('Api error fetching programs: $e');
      return null;
    }
  }

//------------------Get Program Names---------------------------//

  Future<ProgramNameResponse?> programNames() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/get_programs/'))
          .timeout(Duration(seconds: 60));
      final responseAsJson = jsonDecode(response.body) as Map<String, dynamic>;
      return ProgramNameResponse.fromJson(responseAsJson);
    } catch (e) {
      checkConnectivity();
      log('Api error fetching programs: $e');
      return null;
    }
  }

//------------------Upcoming Programs---------------------------//

  Future<ProgramResponse?> getUpcomingPrograms() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/get_upcoming_programs/'))
          .timeout(Duration(seconds: 60));
      final responseAsJson = jsonDecode(response.body) as Map<String, dynamic>;
      return ProgramResponse.fromJson(responseAsJson);
    } catch (e) {
      checkConnectivity();
      log('Api error fetching upcoming programs: $e');
      return null;
    }
  }

//------------------Add Program---------------------------//

  Future<GeneralResponse?> addProgram(Program program) async {
    try {
      final url = '$baseUrl/add_program/';

      final response = await http
          .post(Uri.parse(url),
              body: jsonEncode(program.toJson()), headers: headers)
          .timeout(Duration(seconds: 60));
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

//------------------Update Program---------------------------//

  Future<GeneralResponse?> updateProgram(Map<String, dynamic> data) async {
    try {
      final response = await http
          .patch(Uri.parse('$baseUrl/update_program/'), body: data)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

//------------------Delete Program---------------------------//

  Future<GeneralResponse?> deleteProgram(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/delete_program/'),
              body: jsonEncode({'id': id.toString()}), headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

//------------------Get Departments---------------------------//

  Future<DepartmentList?> getDepartments() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/get_departments/'))
          .timeout(Duration(seconds: 60));
      log(response.body.toString());
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return DepartmentList.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }
  //------------------Get Students Enrolled---------------------------//

  Future<EnrollmentResponse?> getEnrolledStudents(int? id) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/get_enrollment_list/'),
              body: jsonEncode({'id': id}), headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      log(responseJson.toString());
      return EnrollmentResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }
  //------------------Get Attendance---------------------------//

  Future<AttendanceResponse?> getAttendance(String admissionNo) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/get_attendance/'),
              body: jsonEncode({'admission_number': admissionNo}),
              headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      log("json resp:$responseJson");
      final returnValue = AttendanceResponse.fromJson(responseJson);
      log(returnValue.message ?? "Null msg");
      return returnValue;
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

  //------------------Add Attendance---------------------------//

  Future<GeneralResponse?> addAttendance(Map<String, dynamic> data) async {
    try {
      log("request :$data");

      final response = await http
          .post(Uri.parse('$baseUrl/add_attendance/'),
              body: jsonEncode(data), headers: headers)
          .timeout(Duration(seconds: 60));
      log('response: ${(response.body)}');
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }
  //------------------version check---------------------------//

  Future<GeneralResponse?> checkVersion() async {
    // try {
    //   final response = await http
    //       .post(Uri.parse('$baseUrl/check_version/'),
    //           body: jsonEncode({"version": '0.0.1'}), headers: headers)
    //       .timeout(Duration(seconds: 60));
    //   log('response: ${(response.body)}');
    //   final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    //   return GeneralResponse.fromJson(responseJson);
    // } catch (e) {
    //   checkConnectivity();
    //   log('Api error:$e');
    return GeneralResponse(status: true);
    //}
  }

  //------------------Delete Attendance---------------------------//

  Future<GeneralResponse?> deleteAttendance(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/delete_attendance/'),
              body: jsonEncode({'id': id}), headers: headers)
          .timeout(Duration(seconds: 60));
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

  //------------------Get Admin Issues ---------------------------//

  Future<IssueResponse?> getAdminIssues(String role) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/get_issue_by_role/'),
              body: jsonEncode({'role': role}), headers: headers)
          .timeout(Duration(seconds: 60));
      log(response.body);
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      return IssueResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }
  //------------------Get Volunteer Issues ---------------------------//

  Future<IssueResponse?> getVolIssues(String admissionNo) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/get_issue_by_user/'),
              body: jsonEncode({'admission_number': admissionNo}),
              headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      return IssueResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

  //------------------Add Issue---------------------------//

  Future<GeneralResponse?> addIssue(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/add_issue/'),
              body: jsonEncode(data), headers: headers)
          .timeout(Duration(seconds: 60));
      log(response.body);

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }
  //------------------Resolve Issue---------------------------//

  Future<GeneralResponse?> resolveIssue(Map<String, dynamic> data) async {
    try {
      final response = await http
          .patch(Uri.parse('$baseUrl/resolve_issue/'),
              body: jsonEncode(data), headers: headers)
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

  //------------------Enrollment---------------------------//

  Future<GeneralResponse?> enrollToProgram(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/enroll_program/'),
              body: jsonEncode(data), headers: headers)
          .timeout(Duration(seconds: 60));
      log(response.body);

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }
}

checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none)) {
    Get.to(() => NoInternetScreen());
  }
}
