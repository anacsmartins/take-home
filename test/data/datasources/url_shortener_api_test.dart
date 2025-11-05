import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import 'package:url_shortener/data/datasources/url_shortener_api.dart';
import 'package:url_shortener/shared/constants.dart';
import 'package:url_shortener/shared/exceptions.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient client;
  late UrlShortenerApi api;

  const urlInput = 'https://flutter.dev';

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    client = MockHttpClient();
    api = UrlShortenerApi(client);
  });

  test('success → returns AliasResponse correctly', () async {
    // Arrange
    when(
      () => client.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async {
      return http.Response(
        jsonEncode({
          "alias": "flutter.dev",
          "_links": {
            "self": "https://flutter.dev",
            "short": "https://short/flutter.dev",
          },
        }),
        200,
      );
    });

    // Act
    final result = await api.shorten(urlInput);

    // Assert
    expect(result.alias, 'flutter.dev');
    expect(result.originalUrl, 'https://flutter.dev');
    expect(result.shortUrl, 'https://short/flutter.dev');
  });

  test('error → throws ShortenerException on non 200', () async {
    // Arrage
    when(
      () => client.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((_) async => http.Response('err', 500));

    // Act
    final call = api.shorten;

    // Assert
    expect(() => call(urlInput), throwsA(isA<ShortenerException>()));
  });
}
