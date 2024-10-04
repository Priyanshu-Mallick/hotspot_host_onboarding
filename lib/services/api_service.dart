// lib/services/api_service.dart

import 'package:dio/dio.dart';

import '../models/experience.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Experience>> fetchExperiences() async {
    const String url = 'https://staging.cos.8club.co/experiences';
    try {
      final response = await _dio.get(url);
      final data = response.data['data']['experiences'] as List;
      return data.map((e) => Experience.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load experiences');
    }
  }
}
