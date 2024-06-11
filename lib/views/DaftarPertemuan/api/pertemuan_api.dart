import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wkldlabs_flutter_frontend/global/login_context.dart';
import '../model/pertemuan_model.dart';

class MeetingAPI {
  static final MeetingAPI _instance = MeetingAPI._constructor();
  static final Dio _dio = Dio();

  factory MeetingAPI() {
    return _instance;
  }

  MeetingAPI._constructor();

  Exception dioExceptionHandler(e) {
    if (e.response != null && e.response?.data is Map) {
      if (e.response?.data.containsKey('error')) {
        return Exception(e.response?.data['error']);
      } else if (e.response?.data.containsKey('message')) {
        return Exception(e.response?.data['message']);
      } else {
        return Exception(e.response?.data.toString());
      }
    } else {
      return Exception('Error');
    }
  }

  Future<List<Meeting>> getList() async {
    try {
      String? bearerToken = await LoginContext.getToken();
      if (bearerToken != null) {
        Response response = await _dio.get(
          "${dotenv.env['API_SERVER']!}/api/pertemuan",
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          List<Meeting> list = [];
          for (var item in response.data) {
            if (item != null) {
              list.add(Meeting.fromJson(item));
            }
          }
          return list;
        } else {
          throw Exception('Error: ${response.data}');
        }
      } else {
        throw Exception('Token tidak valid');
      }
    } on DioError catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<Meeting> createMeeting(Meeting meeting) async {
    try {
      String? bearerToken = await LoginContext.getToken();
      if (bearerToken != null) {
        Response response = await _dio.post(
          "${dotenv.env['API_SERVER']!}/api/pertemuan",
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $bearerToken",
            },
          ),
          data: meeting.toJson(),
        );
        if (response.statusCode == 201) {
          return Meeting.fromJson(response.data);
        } else {
          throw Exception('Error: ${response.data}');
        }
      } else {
        throw Exception('Token is null or invalid');
      }
    } on DioError catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<Meeting> updateMeeting(Meeting meeting) async {
    try {
      String bearerToken = (await LoginContext.getToken())!;
      if (meeting.id == null) {
        throw Exception('Tidak boleh kosong');
      }
      Response response = await _dio.put(
        "${dotenv.env['API_SERVER']!}/api/pertemuan/${meeting.id}",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          },
        ),
        data: meeting.toJson(),
      );
      if (response.statusCode == 200) {
        return Meeting.fromJson(response.data);
      } else {
        throw Exception('Error: ${response.data}');
      }
    } on DioError catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> deleteMeeting(int id) async {
    try {
      String bearerToken = (await LoginContext.getToken())!;
      Response response = await _dio.delete(
        "${dotenv.env['API_SERVER']!}/api/pertemuan/$id",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Error: ${response.data}');
      }
    } on DioError catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
