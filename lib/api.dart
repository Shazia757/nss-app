import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:nss/model/attendance_model.dart';
import 'package:nss/model/issues_model.dart';
import 'package:nss/model/programs_model.dart';
import 'package:nss/model/users_model.dart';
import 'package:nss/model/volunteer_model.dart';

class Urls {}

class Api {
  static String baseUrl = 'https://nssapi.bvocfarookcollege.com/api';

//------------------Login---------------------------//

  Future<LoginResponse?> login(Map<String, dynamic> data) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/login/'), body: data);
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(responseJson);
    } catch (e) {
      log('Error during login:$e');
      return null;
    }
  }

  //------------------Change Password---------------------------//

  Future<GeneralResponse?> changePassword(Map<String, dynamic> data) async {
    try {
      final response =
          await http.patch(Uri.parse('$baseUrl/change_password/'), body:data);

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

//------------------List Volunteer---------------------------//

  Future<VolunteerList?> listVolunteer() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_volunteers/'));
      log(response.body.toString());
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return VolunteerList.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

//------------------Get Volunteer Details---------------------------//

  Future<VolunteerDetailResponse?> volunteerDetails(String admissionNo) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/get_volunteer_details/'),
          body: {'admission_number': admissionNo});

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return VolunteerDetailResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

//------------------Add Volunteer---------------------------//

  Future<GeneralResponse?> addVolunteer(Users user) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/add_volunteer/'),
          body: user.toJson());

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

//------------------Update Volunteer---------------------------//

  Future<GeneralResponse?> updateVolunteer(Map<String, dynamic> data) async {
    try {
      final response =
          await http.patch(Uri.parse('$baseUrl/update_volunteer/'), body: data);

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

//------------------Delete Volunteer---------------------------//

  Future<GeneralResponse?> deleteVolunteer(String id) async {
    try {
      final response = await http.delete(
          Uri.parse('$baseUrl/delete_volunteer/'),
          body: {'admission_number': id});

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

//------------------Get All Programs---------------------------//

  Future<ProgramResponse?> allPrograms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_all_programs/'));
      final responseAsJson = jsonDecode(response.body) as Map<String, dynamic>;
      return ProgramResponse.fromJson(responseAsJson);
    } catch (e) {
      log('Error fetching programs: $e');
      return null;
    }
  }

//------------------Get Program Names---------------------------//

  Future<ProgramResponse?> programNames() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_programs/'));
      final responseAsJson = jsonDecode(response.body) as Map<String, dynamic>;
      return ProgramResponse.fromJson(responseAsJson);
    } catch (e) {
      log('Error fetching programs: $e');
      return null;
    }
  }

//------------------Upcoming Programs---------------------------//

  Future<ProgramResponse?> upcomingPrograms() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/get_upcoming_programs/'));
      final responseAsJson = jsonDecode(response.body) as Map<String, dynamic>;
      return ProgramResponse.fromJson(responseAsJson);
    } catch (e) {
      log('Error fetching upcoming programs: $e');
      return null;
    }
  }

//------------------Add Program---------------------------//

  Future<GeneralResponse?> addProgram(Program program) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/add_program/'),
          body: program.toJson());

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

//------------------Update Program---------------------------//

  Future<GeneralResponse?> updateProgram(Map<String, dynamic> data) async {
    try {
      final response =
          await http.patch(Uri.parse('$baseUrl/update_program/'), body: data);

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

//------------------Delete Program---------------------------//

  Future<GeneralResponse?> deleteProgram(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/delete_program/'), body: {'id': id});

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

  //------------------Get Attendance---------------------------//

  Future<AttendanceResponse?> getAttendance(String admissionNo) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/get_attendance/'),
          body: {'admission_number': admissionNo});

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return AttendanceResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

  //------------------Add Attendance---------------------------//

  Future<GeneralResponse?> addAttendance(Attendance attendance) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/add_attendance/'),
          body: attendance.toJson());

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

  //------------------Delete Attendance---------------------------//

  Future<GeneralResponse?> deleteAttendance(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/delete_attendance/'), body: {'id': id});
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

  //------------------Get Admin Issues ---------------------------//

  Future<IssueResponse?> getAdminIssues(String role) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/get_issue_by_role/'), body: {'role': role});

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      
      return IssueResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }
  //------------------Get Volunteer Issues ---------------------------//

  Future<IssueResponse?> getVolIssues(String admissionNo) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/get_issue_by_user/'),
          body: {'admission_number': admissionNo});

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      
      return IssueResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }

  //------------------Add Issue---------------------------//

  Future<GeneralResponse?> addIssue(Issues issues) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/add_attendance/'),
          body: issues.toJson());

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');
      return null;
    }
  }
}
