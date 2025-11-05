import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'package:url_shortener/shared/constants.dart';
import 'package:url_shortener/shared/exceptions.dart';
import 'package:url_shortener/data/models/alias_response.dart';

@lazySingleton
class UrlShortenerApi {
  final http.Client _client;
  UrlShortenerApi(this._client);

  Future<AliasResponse> shorten(String url) async {
    final uri = Uri.parse(baseUrl);
    final resp = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return AliasResponse.fromJson(json);
    }

    final body = resp.body;
    throw ShortenerException(
      'POST $uri failed (${resp.statusCode}). ${body.isNotEmpty ? body : 'No body'}',
    );
  }
}
