import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wkldlabs_flutter_frontend/views/MemberPage/member_model.dart';

class MemberController {
  final Dio _dio = Dio();

  MemberController() {
    dotenv.load();
    _dio.options.baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'http://localhost:5500/api/';
  }

  Future<List<MemberData>> fetchMembers() async {
    try {
      var headers = {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzE3NDI1MDA5LCJleHAiOjE3MTgwMjk4MDl9.-S4ryYWaVz8ioDUT3W-g5yKa7MxUbuAxR-qgH7wgu8A'
      };
      var dio = Dio();
      var response = await dio.request(
        'http://localhost:5500/api/member',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        debugPrint('Response data: ${response.data}');
        return MemberData.membersFromJson(json.encode(response.data));
      } else {
        throw Exception('Failed to load member');
      }
    } on DioError catch (e) {
      debugPrint('Error fetching member: $e');
      throw Exception('Failed to load member');
    }
  }

  Future<MemberData> createMember(MemberData member) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzE3NDI1MDA5LCJleHAiOjE3MTgwMjk4MDl9.-S4ryYWaVz8ioDUT3W-g5yKa7MxUbuAxR-qgH7wgu8A'
      };
      var dio = Dio();
      var response = await dio.request(
        'http://localhost:5500/api/member',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: member.toJson(),
      );

      if (response.statusCode == 201) {
        return MemberData.fromJson(response.data);
      } else {
        throw Exception('Failed to create member');
      }
    } on DioError catch (e) {
      debugPrint('Error creating member: $e');
      throw Exception('Failed to create member');
    }
  }

  Future<MemberData> updateMember(MemberData member) async {
    try {
      final response = await _dio.put(
        '/member/${member.id}',
        data: member.toJson(),
      );
      if (response.statusCode == 200) {
        return MemberData.fromJson(response.data);
      } else {
        throw Exception('Failed to update member');
      }
    } on DioError catch (e) {
      debugPrint('Error updating member: $e');
      throw Exception('Failed to update member');
    }
  }

  Future<void> deleteMember(int id) async {
    try {
      final response = await _dio.delete('/member/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete member');
      }
    } on DioError catch (e) {
      debugPrint('Error deleting member: $e');
      throw Exception('Failed to delete member');
    }
  }
}