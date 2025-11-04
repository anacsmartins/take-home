
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../shared/constants.dart';
import '../../shared/exceptions.dart';
import '../models/alias_response.dart';

class UrlShortenerApi {
  final http.Client _client;
  UrlShortenerApi({http.Client? client}) : _client = client ?? http.Client();

  Future<AliasResponse> shorten(String url) async {
    final uri = Uri.parse(baseUrl);
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );

    if (resp.statusCode == 201) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return AliasResponse.fromJson(json);
    }

    final body = resp.body;
    throw ShortenerException(
      'POST $uri failed (${resp.statusCode}). ${body.isNotEmpty ? body : 'No body'}',
    );
  }
}
