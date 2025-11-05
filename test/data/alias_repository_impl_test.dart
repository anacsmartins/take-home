import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:url_shortener/data/datasources/url_shortener_api.dart';
import 'package:url_shortener/data/repositories/alias_repository_impl.dart';
import 'package:url_shortener/data/models/alias_response.dart';

class MockUrlShortenerApi extends Mock implements UrlShortenerApi {}

void main() {
  late MockUrlShortenerApi api;
  late AliasRepositoryImpl repository;

  const urlInput = 'https://flutter.dev';

  const dto = AliasResponse(
    alias: 'flutter.dev',
    originalUrl: urlInput,
    shortUrl: 'https://short/flutter.dev',
  );

  setUp(() {
    api = MockUrlShortenerApi();
    repository = AliasRepositoryImpl(api);
    registerFallbackValue(urlInput);
  });

  test(
    'data/repository → must call API & correctly map DTO -> Entity',
    () async {
      // arrange
      when(() => api.shorten(urlInput)).thenAnswer((_) async => dto);

      // act
      final result = await repository.shortenUrl(urlInput);

      // assert
      expect(result.alias, dto.alias);
      expect(result.originalUrl, dto.originalUrl);
      expect(result.shortUrl, dto.shortUrl);

      verify(() => api.shorten(urlInput)).called(1);
    },
  );
}
