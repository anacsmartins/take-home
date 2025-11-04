import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:your_app_name/domain/entities/alias_entity.dart';
import 'package:your_app_name/data/datasources/url_shortener_api.dart';
import 'package:your_app_name/data/repositories/alias_repository_impl.dart';

class MockApi extends Mock implements UrlShortenerApi {}

void main() {
  late MockApi api;
  late AliasRepositoryImpl repository;

  const urlInput = 'https://flutter.dev';

  setUp(() {
    api = MockApi();
    repository = AliasRepositoryImpl(api);
  });

  test('repository should call datasource and convert dto to entity correctly', () async {
    when(() => api.shorten(urlInput)).thenAnswer((_) async {
      return AliasResponseMock(
        alias: 'flutter.dev',
        originalUrl: urlInput,
        shortUrl: 'https://short/flutter.dev',
      );
    });

    final result = await repository.shortenUrl(urlInput);

    expect(result.alias, 'flutter.dev');
    expect(result.originalUrl, urlInput);
    expect(result.shortUrl, 'https://short/flutter.dev');

    verify(() => api.shorten(urlInput)).called(1);
  });
}

class AliasResponseMock {
  final String alias;
  final String originalUrl;
  final String shortUrl;

  AliasResponseMock({
    required this.alias,
    required this.originalUrl,
    required this.shortUrl,
  });

  AliasEntity toEntity() => AliasEntity(
        alias: alias,
        originalUrl: originalUrl,
        shortUrl: shortUrl,
      );
}
