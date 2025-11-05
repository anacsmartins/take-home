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
  const entity = AliasEntity(
    alias: 'flutterdev',
    originalUrl: urlInput,
    shortUrl: 'https://short/flutterdev',
  );

  setUp(() {
    mockUsecase = MockShortenUrlUseCase();
    cubit = ShortenerCubit(mockUsecase);

    registerFallbackValue(urlInput);
  });

  test('success → add item to list and emit ShortenerSuccess', () async {
    // arrangel.fir
    when(() => mockUsecase(any())).thenAnswer((_) async => entity);

    // act
    await cubit.shorten(urlInput);

    // assert
    expect(cubit.state, isA<ShortenerSuccess>());
    final current = cubit.state as ShortenerSuccess;
    expect(current.list.length, 1);
    expect(current.list.first.shortUrl, entity.shortUrl);
    verify(() => mockUsecase(urlInput)).called(1);
  });

  test('error → emit ShortenerError but keep previous items', () async {
    // arrange
    when(() => mockUsecase(any())).thenThrow(Exception('boom'));

    // act
    await cubit.shorten(urlInput);

    // assert
    expect(cubit.state, isA<ShortenerError>());
    final current = cubit.state as ShortenerError;
    expect(current.list.isEmpty, true);
    verify(() => mockUsecase(urlInput)).called(1);
  });
}
