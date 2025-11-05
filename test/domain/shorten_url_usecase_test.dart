import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:url_shortener/domain/entities/alias_entity.dart';
import 'package:url_shortener/domain/repositories/alias_repository.dart';
import 'package:url_shortener/domain/usecases/shorten_url_usecase.dart';

class MockAliasRepository extends Mock implements AliasRepository {}

void main() {
  late MockAliasRepository mockRepo;
  late ShortenUrlUseCase usecase;

  const urlInput = 'https://flutter.dev';
  const entity = AliasEntity(
    alias: 'flutter.dev',
    originalUrl: urlInput,
    shortUrl: 'https://short/flutter.dev',
  );

  setUp(() {
    mockRepo = MockAliasRepository();
    usecase = ShortenUrlUseCase(mockRepo);
    registerFallbackValue(urlInput);
  });

  test(
    'usecase → must call repository and return correct mapped entity',
    () async {
      // arrange
      when(() => mockRepo.shortenUrl(urlInput)).thenAnswer((_) async => entity);

      // act
      final result = await usecase(urlInput);

      // assert
      expect(result.alias, entity.alias);
      expect(result.originalUrl, entity.originalUrl);
      expect(result.shortUrl, entity.shortUrl);
      verify(() => mockRepo.shortenUrl(urlInput)).called(1);
    },
  );
}
