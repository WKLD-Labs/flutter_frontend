import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wkldlabs_flutter_frontend/views/InventoryPage/Model/inventory_model.dart';

import '../../../global/login_context.dart';

class InventoryAPI{
  static final InventoryAPI _instance = InventoryAPI._constructor();
  static final Dio _dio = Dio();

  factory InventoryAPI(){
    return _instance;
  }

  InventoryAPI._constructor();

  String get _uri => dotenv.env['API_SERVER']!;

  Future<Options> _getOptions() async {
    String? bearerToken = await LoginContext.getToken();
    if (bearerToken == null || bearerToken.isEmpty) {
      throw Exception('Bearer token is null or empty');
    }
    return Options(
      headers: {HttpHeaders.authorizationHeader: 'Bearer $bearerToken'},
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

  List<Inventory> _parseInventory(List<dynamic> data) {
    return data.map((item) => Inventory.fromJson(item)).toList();
  }

  Future<List<Inventory>> readAll() async {
    try{
      final response = await _dio.get(
        '$_uri/api/inventory',
        options: await _getOptions(),
      );
      if (response.statusCode == HttpStatus.ok) {
        final responseData = response.data;
        if (responseData is String) {
          final dataMap = json.decode(responseData) as Map<String, dynamic>;
          return _parseInventory(dataMap['data']);
        } else if (responseData is Map<String, dynamic>) {
          return _parseInventory(responseData['data']);
        } else if (responseData is List) {
          return _parseInventory(responseData);
        } else {
          print(responseData);
          throw Exception('Response data is not in the expected format');
        }
      } else {
        throw Exception('Failed to fetch inventories');
      }
    }catch(e){
      debugPrint(e.toString());
      throw Exception('Failed to fetch inventories');
    }
  }

  Future<Inventory> create(Inventory inventory) async {
    try {
      final response = await _dio.post(
        '$_uri/api/inventory',
        options: await _getOptions(),
        data: inventory.toJson(),
      );

      if (response.statusCode == HttpStatus.created || response.statusCode == HttpStatus.ok) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          return Inventory.fromJson(responseData);
        } else {
          throw Exception('Response data is not in the expected format');
        }
      } else {
        throw Exception('Failed to create inventory. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error adding inventory: $e');
      throw Exception('Failed to create inventory. Error: $e');
    }
  }

  Future<void> update(Inventory inventory) async {
    if (inventory.id == null) {
      throw Exception('ID cannot be null');
    }
    try {
      final response = await _dio.put(
        '$_uri/api/inventory/${inventory.id}',
        options: await _getOptions(),
        data: inventory.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update inventory: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await _dio.delete(
        '$_uri/api/inventory/$id',
        options: await _getOptions(),
      );
      if (response.statusCode != HttpStatus.ok) {
        throw Exception('Failed to delete inventory. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete inventory: $e');
    }
  }



}