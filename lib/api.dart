import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/attendance_model.dart';
import 'package:nss/model/department.dart';
import 'package:nss/model/enrollment_model.dart';
import 'package:nss/model/issues_model.dart';
import 'package:nss/model/programs_model.dart';
import 'package:nss/model/users_model.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/common_pages/no_connection_page.dart';

class Urls {
  static String base = 'https://nss.noorabiyad.com/api';
  // 'https://nssapi.bvocfarookcollege.com/api';
  static String login = '$base/login/';
  static String changePassword = '$base/change_password/';
  static String resetPassword = '$base/reset_password/';
  static String getVolunteers = '$base/get_volunteers/';
  static String getAdmins = '$base/get_admins/';
  static String volunteerDetails = '$base/get_volunteer_details/';
  static String addVolunteer = '$base/add_volunteer/';
  static String updateVolunteer = '$base/update_volunteer/';
  static String deleteVolunteer = '$base/delete_volunteer/';
  static String getAllPrograms = '$base/get_all_programs/';
  static String getProgramNames = '$base/get_programs/';
  static String getUpcomingPrograms = '$base/get_upcoming_programs/';
  static String getEnrolledStudents = '$base/get_enrollment_list/';
  static String addProgram = '$base/add_program/';
  static String updateProgram = '$base/update_program/';
  static String deleteProgram = '$base/delete_program/';
  static String getDepartments = '$base/get_departments/';
  static String getAttendance = '$base/get_attendance/';
  static String addAttendance = '$base/add_attendance/';
  static String deleteAttendance = '$base/delete_attendance/';
  static String getAdminIssue = '$base/get_issue_by_role/';
  static String getVolIssue = '$base/get_issue_by_user/';
  static String addIssue = '$base/add_issue/';
  static String resolveIssue = '$base/resolve_issue/';
  static String enrollToProgram = '$base/enroll_program/';
  static String checkVersion = '$base/check_version/';
}

Future<Map<String, String>?> getHeader() async {
  return {"Content-type": "application/json", "OS": Platform.operatingSystem, "App-version": "1.0.0", "Authorization": await LocalStorage().readToken() ?? ''};
}

class Api {
//------------------Login---------------------------//

  Future<LoginResponse?> login(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.login),
            body: jsonEncode(data),
            headers: await getHeader(),
          )
          .timeout(Duration(seconds: 60));
      log(response.body);
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
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
      final response = await http.post(Uri.parse(Urls.changePassword), body: jsonEncode(data), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.post(Uri.parse(Urls.resetPassword), body: jsonEncode(data), headers: await getHeader()).timeout(Duration(seconds: 60));

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
      final response = await http.get(Uri.parse(Urls.getVolunteers), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.get(Uri.parse(Urls.getAdmins), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.post(Uri.parse(Urls.volunteerDetails), body: jsonEncode({'admission_number': admissionNo}), headers: await getHeader()).timeout(Duration(seconds: 60));

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

      final response = await http.post(Uri.parse(Urls.addVolunteer), body: jsonEncode(user), headers: await getHeader()).timeout(Duration(seconds: 60));

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
      final response = await http.patch(Uri.parse(Urls.updateVolunteer), body: jsonEncode(data), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.delete(Uri.parse(Urls.deleteVolunteer), body: jsonEncode({'volunteer': id}), headers: await getHeader()).timeout(Duration(seconds: 60));

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
      final response = await http.get(Uri.parse(Urls.getAllPrograms), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.get(Uri.parse(Urls.getProgramNames), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.get(Uri.parse(Urls.getUpcomingPrograms), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.post(Uri.parse(Urls.addProgram), body: jsonEncode(program.toJson()), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      log("request :${jsonEncode(data)}");

      final response = await http.patch(Uri.parse(Urls.updateProgram), body: jsonEncode(data), headers: await getHeader()).timeout(Duration(seconds: 60));
      log(response.body);

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
      final response = await http.delete(Uri.parse(Urls.deleteProgram), body: jsonEncode({'id': id.toString()}), headers: await getHeader()).timeout(Duration(seconds: 60));

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
      final response = await http.get(Uri.parse(Urls.getDepartments), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.post(Uri.parse(Urls.getEnrolledStudents), body: jsonEncode({'id': id}), headers: await getHeader()).timeout(Duration(seconds: 60));

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
      final response = await http.post(Uri.parse(Urls.getAttendance), body: jsonEncode({'admission_number': admissionNo}), headers: await getHeader()).timeout(Duration(seconds: 60));

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

      final response = await http.post(Uri.parse(Urls.addAttendance), body: jsonEncode(data), headers: await getHeader()).timeout(Duration(seconds: 60));
      log('response: ${(response.body)}');
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return null;
    }
  }

  //------------------Delete Attendance---------------------------//

  Future<GeneralResponse?> deleteAttendance(int id) async {
    try {
      final response = await http.delete(Uri.parse(Urls.deleteAttendance), body: jsonEncode({'id': id}), headers: await getHeader()).timeout(Duration(seconds: 60));
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
    try {
      // log(headers.toString());
      // getHeader();
      // log(header.toString());
      final response = await http.post(Uri.parse(Urls.checkVersion), body: jsonEncode({"version": '1.0.0', "os": Platform.operatingSystem}), headers: await getHeader()).timeout(Duration(seconds: 60));
      log('response: ${(response.body)}');
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error:$e');
      return GeneralResponse(status: true);
    }
  }

  //------------------Get Admin Issues ---------------------------//

  Future<IssueResponse?> getAdminIssues(String role) async {
    try {
      final response = await http.post(Uri.parse(Urls.getAdminIssue), body: jsonEncode({'role': role}), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.post(Uri.parse(Urls.getVolIssue), body: jsonEncode({'admission_number': admissionNo}), headers: await getHeader()).timeout(Duration(seconds: 60));

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
      final response = await http.post(Uri.parse(Urls.addIssue), body: jsonEncode(data), headers: await getHeader()).timeout(Duration(seconds: 60));
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
      final response = await http.patch(Uri.parse(Urls.resolveIssue), body: jsonEncode(data), headers: await getHeader()).timeout(Duration(seconds: 60));

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
      final response = await http.post(Uri.parse(Urls.enrollToProgram), body: jsonEncode(data), headers: await getHeader()).timeout(Duration(seconds: 60));
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
