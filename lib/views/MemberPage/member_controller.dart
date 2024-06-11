import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wkldlabs_flutter_frontend/global/login_context.dart';
import 'member_model.dart';

class MemberAPI {
  static final MemberAPI _instance = MemberAPI._constructor();
  static final Dio _dio = Dio();

  factory MemberAPI() {
    return _instance;
  }

  MemberAPI._constructor();

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

  Future<List<MemberData>> getList() async {
    try {
      String? bearerToken = await LoginContext.getToken();
      if (bearerToken != null) {
        Response response = await _dio.get(
          "${dotenv.env['API_SERVER']!}/api/member",
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
            },
          ),
        );
        if (response.statusCode == 200) {
          List<MemberData> list = [];
          for (var item in response.data) {
            if (item != null) {
              list.add(MemberData.fromJson(item));
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

  Future<MemberData> createMember(MemberData member) async {
    try {
      String? bearerToken = await LoginContext.getToken();
      if (bearerToken != null) {
        Response response = await _dio.post(
          "${dotenv.env['API_SERVER']!}/api/member",
          options: Options(
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $bearerToken",
            },
          ),
          data: member.toJson(),
        );
        if (response.statusCode == 201) {
          return MemberData.fromJson(response.data);
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

  Future<MemberData> updateMember(MemberData member) async {
    try {
      String bearerToken = (await LoginContext.getToken())!;
      if (member.id == null) {
        throw Exception('Tidak boleh kosong');
      }
      Response response = await _dio.put(
        "${dotenv.env['API_SERVER']!}/api/member/${member.id}",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          },
        ),
        data: member.toJson(),
      );
      if (response.statusCode == 200) {
        return MemberData.fromJson(response.data);
      } else {
        throw Exception('Error: ${response.data}');
      }
    } on DioError catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> deleteMember(int id) async {
    try {
      String bearerToken = (await LoginContext.getToken())!;
      Response response = await _dio.delete(
        "${dotenv.env['API_SERVER']!}/api/member/$id",
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