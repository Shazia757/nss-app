import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:nss/model/programs_model.dart';
import 'package:nss/model/users_model.dart';
import 'package:nss/model/volunteer_model.dart';

class Urls {}

class Api {
  static String baseUrl = 'https://nssapi.bvocfarookcollege.com/api';

//------------------Login---------------------------//

  Future<LoginResponse> login(Map<String, dynamic> data) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/login/'), body: data);
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(responseJson);
      } else {
        throw Exception('Failed to login.Status code:${response.statusCode}');
      }
    } catch (e) {
      log('Error during login:$e');

      return LoginResponse(
        status: false,
        message: 'An error occurred during login: ${e.toString()}',
        data: Users(),
      );
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

//------------------List Volunteer---------------------------//

  Future<VolunteerList> listVolunteer() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_volunteers/'));
      log(response.body.toString());
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return VolunteerList.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');

      return VolunteerList(
        data: [],
        status: false,
        message: 'An error occurred: ${e.toString()}',
      );
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
    }
    return null;
  }

//------------------Add Volunteer---------------------------//

  Future<GeneralResponse> addVolunteer(Users user) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/add_volunteer/'),
          body: user.toJson());

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');

      return GeneralResponse(
        status: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }

//------------------Update Volunteer---------------------------//

  Future<GeneralResponse> updateVolunteer(Map<String, dynamic> data) async {
    try {
      final response =
          await http.patch(Uri.parse('$baseUrl/update_volunteer/'), body: data);

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return GeneralResponse.fromJson(responseJson);
    } catch (e) {
      log('Error:$e');

      return GeneralResponse(
        status: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }

//------------------Delete Volunteer---------------------------//

  Future<GeneralResponse> deleteVolunteer(String id) async {
    try {
      final response = await http.delete(
          Uri.parse('$baseUrl/delete_volunteer/'),
          body: {'admission_number': id});
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return GeneralResponse.fromJson(responseJson);
      } else {
        throw Exception(
            'Failed to delete volunteer.Status code:${response.statusCode}');
      }
    } catch (e) {
      log('Error:$e');

      return GeneralResponse(
        status: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }
}
