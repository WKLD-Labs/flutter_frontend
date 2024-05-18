import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'model.dart';

class DocumentsAPI {
  static final DocumentsAPI _instance = DocumentsAPI._constructor();
  static final Dio _dio = Dio();
  factory DocumentsAPI() {
    return _instance;
  }
  DocumentsAPI._constructor();

  String get _baseUrl => dotenv.env['API_SERVER']!;
  String? get _bearerToken => dotenv.env['TEMPORARY_TOKEN'];

  Options _getOptions() {
    if (_bearerToken == null || _bearerToken!.isEmpty) {
      throw Exception('Bearer token is null or empty');
    }
    return Options(
      headers: {HttpHeaders.authorizationHeader: 'Bearer $_bearerToken'},
    );
  }

  Exception _handleDioError(DioError e) {
    if (e.response?.data is Map && e.response?.data.containsKey('error')) {
      return Exception(e.response?.data['error']);
    } else if (e.response?.data is Map && e.response?.data.containsKey('message')) {
      return Exception(e.response?.data['message']);
    }
    return Exception('An error occurred');
  }

  Future<List<Document>> getList() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/document',
        options: _getOptions(),
      );
      if (response.statusCode == HttpStatus.ok) {
        final responseData = response.data;
        if (responseData is String) {
          final dataMap = json.decode(responseData) as Map<String, dynamic>;
          return _parseDocuments(dataMap['data']);
        } else if (responseData is Map<String, dynamic>) {
          return _parseDocuments(responseData['data']);
        } else {
          throw Exception('Response data is not in the expected format');
        }
      } else {
        throw Exception('Failed to fetch documents');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to fetch documents');
    }
  }

  List<Document> _parseDocuments(List<dynamic> data) {
    return data.map((item) => Document.fromJson(item)).toList();
  }

  Future<Document> create(Document document) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/document',
        options: _getOptions(),
        data: document.toJson(),
      );

      if (response.statusCode == HttpStatus.created || response.statusCode == HttpStatus.ok) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          return Document.fromJson(responseData);
        } else {
          throw Exception('Response data is not in the expected format');
        }
      } else {
        throw Exception('Failed to create document. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error adding document: $e');
      throw Exception('Failed to create document. Error: $e');
    }
  }

  Future<Document> update(Document document) async {
    if (document.id == null) {
      throw Exception('ID cannot be null');
    }
    try {
      final response = await _dio.put(
        '$_baseUrl/api/document/${document.id}',
        options: _getOptions(),
        data: document.toJson(),
      );

      if (response.statusCode == HttpStatus.ok) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          return Document.fromJson(responseData);
        } else {
          throw Exception('Response data is not in the expected format');
        }
      } else {
        throw Exception('Failed to update document');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to update document');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/api/document/$id',
        options: _getOptions(),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw Exception('Failed to delete document');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete document');
    }
  }
}
