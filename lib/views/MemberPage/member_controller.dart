import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wkldlabs_flutter_frontend/views/MemberPage/member_model.dart';

class MeetingController {
  final Dio _dio = Dio();

  MeetingController() {
    dotenv.load();
    _dio.options.baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'http://localhost:5500/api/';
  }

  Future<List<MemberData>> fetchMeetings() async {
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
        throw Exception('Failed to load meetings');
      }
    } on DioError catch (e) {
      debugPrint('Error fetching meetings: $e');
      throw Exception('Failed to load meetings');
    }
  }

  Future<Meeting> createMeeting() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNzE3NDI1MDA5LCJleHAiOjE3MTgwMjk4MDl9.-S4ryYWaVz8ioDUT3W-g5yKa7MxUbuAxR-qgH7wgu8A'
      };
      var data = json.encode({
        "meetingname": "coba",
        "speaker": "coba ",
        "datetime": "2024-05-14T18:50:41.000Z",
        "meetinglink": "coba",
        "description": "coba",
        "createdAt": "2024-05-26T13:50:40.000Z",
        "updatedAt": "2024-05-26T13:50:40.000Z"
      });
      var dio = Dio();
      var response = await dio.request(
        'http://localhost:5500/api/pertemuan',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 201) {
        return Meeting.fromJson(response.data);
      } else {
        throw Exception('Failed to create meeting');
      }
    } on DioError catch (e) {
      debugPrint('Error creating meeting: $e');
      throw Exception('Failed to create meeting');
    }
  }

  Future<Meeting> updateMeeting(Meeting meeting) async {
    try {
      final response = await _dio.put(
        '/pertemuan/${meeting.id}',
        data: meeting.toJson(),
      );
      if (response.statusCode == 200) {
        return Meeting.fromJson(response.data);
      } else {
        throw Exception('Failed to update meeting');
      }
    } on DioError catch (e) {
      debugPrint('Error updating meeting: $e');
      throw Exception('Failed to update meeting');
    }
  }

  Future<void> deleteMeeting(int id) async {
    try {
      final response = await _dio.delete('/pertemuan/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete meeting');
      }
    } on DioError catch (e) {
      debugPrint('Error deleting meeting: $e');
      throw Exception('Failed to delete meeting');
    }
  }
}