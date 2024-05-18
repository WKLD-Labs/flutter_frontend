import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'model.dart';

class documentsAPI {
  static final documentsAPI _instance = documentsAPI._constructor();
  static final Dio _dio = Dio();
  factory documentsAPI() {
    return _instance;
  }
  documentsAPI._constructor();

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

  Future<List<Document>> getList(int? month, int? year) async {
    try {
      String bearerToken = dotenv.env['TEMPORARY_TOKEN']!;
      Response response = await _dio.get(
        "${dotenv.env['API_SERVER']!}/api/documents",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
          },
        ),
        queryParameters: {
          'month': month,
          'year': year,
        },
      );
      if (response.statusCode == 200) {
        List<Document> list = [];
        for (var item in response.data) {
          list.add(Document.fromJson(item));
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

  Future<Document> create(Document documents) async {
    try {
      String bearerToken = dotenv.env['TEMPORARY_TOKEN']!;
      // FormData data = FormData.fromMap(documents.toJson());
      Response response = await _dio.post(
        "${dotenv.env['API_SERVER']!}/api/documents",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          },
        ),
        data: documents.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Terjadi Kesalahan');
      }
      return Document.fromJson(response.data);
    } on DioException catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Terjadi Kesalahan');
    }
  }

  Future<Document> update(Document documents) async {
    try {
      String bearerToken = dotenv.env['TEMPORARY_TOKEN']!;
      FormData data = FormData.fromMap(documents.toJson());
      if (documents.id == null) {
        throw Exception('ID tidak boleh kosong');
      }
      Response response = await _dio.put(
        "${dotenv.env['API_SERVER']!}/api/documents/${documents.id}",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          },
        ),
        data: data,
      );
      if (response.statusCode != 200) {
        throw Exception('Terjadi Kesalahan');
      }
      return Document.fromJson(response.data);
    } on DioException catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Terjadi Kesalahan');
    }
  }

  Future<void> delete(int id) async {
    try {
      String bearerToken = dotenv.env['TEMPORARY_TOKEN']!;
      Response response = await _dio.delete(
        "${dotenv.env['API_SERVER']!}/api/documents/$id",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $bearerToken",
          },
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Terjadi Kesalahan');
      }
    } on DioException catch (e) {
      throw dioExceptionHandler(e);
    } catch (error) {
      throw Exception('Terjadi Kesalahan');
    }
  }
}