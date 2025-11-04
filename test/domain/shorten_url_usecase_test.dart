import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:your_app_name/domain/entities/alias_entity.dart';
import 'package:your_app_name/domain/repositories/alias_repository.dart';
import 'package:your_app_name/domain/usecases/shorten_url_usecase.dart';

class MockAliasRepository extends Mock implements AliasRepository {}

void main() {
  late MockAliasRepository mockRepo;
  late ShortenUrlUseCase usecase;

  const urlInput = 'https://flutter.dev';

  setUp(() {
    mockRepo = MockAliasRepository();
    usecase = ShortenUrlUseCase(mockRepo);

    registerFallbackValue(urlInput);
  });

  test('should call repository and return an AliasEntity using the provided url', () async {
    when(() => mockRepo.shortenUrl(urlInput)).thenAnswer((_) async {
      return AliasEntity(
        alias: 'flutter.dev',
        originalUrl: urlInput,
        shortUrl: 'https://short/flutter.dev',
      );
    });

    final result = await usecase(urlInput);

    expect(result.alias, 'flutter.dev');
    expect(result.originalUrl, urlInput);
    expect(result.shortUrl, 'https://short/flutter.dev');

    verify(() => mockRepo.shortenUrl(urlInput)).called(1);
  });
}
