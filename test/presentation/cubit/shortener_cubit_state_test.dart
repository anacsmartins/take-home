import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:url_shortener/domain/entities/alias_entity.dart';
import 'package:url_shortener/domain/usecases/shorten_url_usecase.dart';
import 'package:url_shortener/presentation/cubit/shortener_cubit.dart';
import 'package:url_shortener/presentation/cubit/shortener_state.dart';

class MockShortenUrlUseCase extends Mock implements ShortenUrlUseCase {}

void main() {
  late MockShortenUrlUseCase mockUsecase;
  late ShortenerCubit cubit;

  const urlInput = 'https://flutter.dev';

  setUp(() {
    mockUsecase = MockShortenUrlUseCase();
    cubit = ShortenerCubit(mockUsecase);
    registerFallbackValue(urlInput);
  });

  test(
    'success → should append item and emit ShortenerSuccess with growing list',
    () async {
      // Arrange
      when(() => mockUsecase(urlInput)).thenAnswer(
        (_) async => const AliasEntity(
          alias: 'flutter.dev',
          originalUrl: urlInput,
          shortUrl: 'https://short/flutter.dev',
        ),
      );

      // Assert
      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([
            isA<ShortenerLoading>(),
            isA<ShortenerSuccess>().having((s) => s.list.length, 'len', 1),
          ]),
        ),
      );

      // Act
      await cubit.shorten(urlInput);
    },
  );

  test(
    'error → should emit ShortenerError preserving previous items',
    () async {
      // Arrange
      when(() => mockUsecase(urlInput)).thenThrow(Exception('boom'));

      // Assert
      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder([
            isA<ShortenerLoading>(),
            isA<ShortenerError>().having((s) => s.list.length, 'len', 0),
          ]),
        ),
      );
      // Act
      await cubit.shorten(urlInput);
    },
  );
}
