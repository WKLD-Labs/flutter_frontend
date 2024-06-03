import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'dart:io';
// import 'package:flutter/foundation.dart';


import "../models/agenda_model.dart";

class AgendaAPI{
  static final AgendaAPI _instance = AgendaAPI._constructor();
  static final Dio _dio = Dio();
  factory AgendaAPI() {
    return _instance;
  }
  AgendaAPI._constructor();

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
        return Exception('Terjadi Kesalahan');
      }
  }

  Future<List<AgendaModel>> getList() async {
    try {
      String bearerToken = dotenv.env['TEMPORARY_TOKEN']!;
      Response response = await _dio.get(
        "${dotenv.env['API_SERVER']!}/api/agenda",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        List<AgendaModel> list = [];
        for (var item in response.data) {
          list.add(AgendaModel.fromJson(item));
        }
        return list;
      } else {
        debugPrint(response.data.toString());
        throw Exception('Terjadi Kesalahan');
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      throw dioExceptionHandler(e);
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Terjadi Kesalahan');
    } 
  } 

  Future<AgendaModel> create(AgendaModel agendaModel) async {
    try {
      String bearerToken = dotenv.env['TEMPORARY_TOKEN']!;
      // FormData data = FormData.fromMap(roomSchedule.toJson());
      Response response = await _dio.post(
        "${dotenv.env['API_SERVER']!}/api/agenda",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          },
        ),
        data: agendaModel.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Terjadi Kesalahan');
      }
      return AgendaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Terjadi Kesalahan');
    }
  }
}