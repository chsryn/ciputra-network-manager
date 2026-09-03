import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/member.dart';

class ApiService {
  static String get _scriptUrl => dotenv.env['SCRIPT_URL'] ?? '';

  /// Fetches all members from the Google Apps Script endpoint.
  Future<List<Member>> fetchMembers() async {
    final response = await http.get(Uri.parse(_scriptUrl));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];
      return data
          .map((item) => Member.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to fetch members: ${response.statusCode}');
  }

  /// Submits member data (insert, update, or delete) to the Google Apps Script.
  /// Returns `true` on success (HTTP 200 or 302).
  Future<bool> submitMemberData({
    required String action,
    required Member member,
  }) async {
    final body = member.toJson();
    body['action'] = action;

    final response = await http.post(
      Uri.parse(_scriptUrl),
      body: json.encode(body),
    );

    return response.statusCode == 200 || response.statusCode == 302;
  }
}
