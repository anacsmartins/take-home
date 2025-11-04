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

  setUp(() {
    mockRepo = MockAliasRepository();
    usecase = ShortenUrlUseCase(mockRepo);
    registerFallbackValue(urlInput);
  });

  test('should call repository and return entity correctly', () async {
    when(() => mockRepo.shortenUrl(urlInput)).thenAnswer((_) async {
      return const AliasEntity(
        alias: 'flutter.dev',
        originalUrl: urlInput,
        shortUrl: 'https://short/flutter.dev',
      );
    });

    final result = await usecase(urlInput);

    expect(result.alias, 'flutter.dev');
    expect(result.shortUrl, 'https://short/flutter.dev');
    verify(() => mockRepo.shortenUrl(urlInput)).called(1);
  });
}
