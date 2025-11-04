import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/domain/entities/alias_entity.dart';
import '../../lib/data/datasources/url_shortener_api.dart';
import '../../lib/data/repositories/alias_repository_impl.dart';
import '../../lib/data/models/alias_response.dart';

class MockApi extends Mock implements UrlShortenerApi {}

void main() {
  late MockApi api;
  late AliasRepositoryImpl repository;

  const urlInput = 'https://flutter.dev';

  setUp(() {
    api = MockApi();
    repository = AliasRepositoryImpl(api);
    registerFallbackValue(urlInput);
  });

  test('repository converts API DTO -> Entity correctly', () async {
    when(() => api.shorten(urlInput)).thenAnswer((_) async {
      return AliasResponse(
        alias: 'flutter.dev',
        originalUrl: urlInput,
        shortUrl: 'https://short/flutter.dev',
      );
    });

    final result = await repository.shortenUrl(urlInput);

    expect(result.alias, 'flutter.dev');
    expect(result.originalUrl, urlInput);
    expect(result.shortUrl, 'https://short/flutter.dev');
  });
}
