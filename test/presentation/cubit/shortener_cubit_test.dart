import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/domain/entities/alias_entity.dart';
import 'package:url_shortener/domain/usecases/shorten_url_usecase.dart';
import 'package:url_shortener/presentation/cubit/shortener_cubit.dart';
import 'package:url_shortener/presentation/cubit/shortener_state.dart';

class MockShortenUsecase extends Mock implements ShortenUrlUseCase {}

void main() {
  late MockShortenUsecase mockUsecase;
  late ShortenerCubit cubit;

  const inputA = 'https://flutter.dev';
  const inputB = 'https://google.com';

  const entityA = AliasEntity(
    alias: 'flutter',
    originalUrl: inputA,
    shortUrl: 'https://s.dev/flutter',
  );

  const entityB = AliasEntity(
    alias: 'google',
    originalUrl: inputB,
    shortUrl: 'https://s.dev/google',
  );

  setUp(() {
    mockUsecase = MockShortenUsecase();
    cubit = ShortenerCubit(mockUsecase);
    registerFallbackValue(inputA);
    registerFallbackValue(inputB);
  });

  test('emit Success with 1 element', () async {
    when(() => mockUsecase(inputA)).thenAnswer((_) async => entityA);

    await cubit.shorten(inputA);

    expect(cubit.state, isA<ShortenerSuccess>());
    final s = cubit.state as ShortenerSuccess;
    expect(s.list.length, 1);
    expect(s.list.first.shortUrl, 'https://s.dev/flutter');
  });

  test('Keep previous items and add new ones to the top', () async {
    when(() => mockUsecase(inputA)).thenAnswer((_) async => entityA);
    when(() => mockUsecase(inputB)).thenAnswer((_) async => entityB);

    await cubit.shorten(inputA);
    await cubit.shorten(inputB);

    final s = cubit.state as ShortenerSuccess;
    expect(s.list.length, 2);
    expect(s.list.first.shortUrl, 'https://s.dev/google'); // topo
    expect(s.list.last.shortUrl, 'https://s.dev/flutter');
  });

  test('It should throw a ShortenerError and keep the existing list', () async {
    when(() => mockUsecase(inputA)).thenThrow(Exception('404'));

    await cubit.shorten(inputA);

    expect(cubit.state, isA<ShortenerError>());
    final s = cubit.state as ShortenerError;
    expect(s.list.length, 0);
  });
}
