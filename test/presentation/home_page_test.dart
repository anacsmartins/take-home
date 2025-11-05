import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:url_shortener/domain/entities/alias_entity.dart';
import 'package:url_shortener/domain/usecases/shorten_url_usecase.dart';
import 'package:url_shortener/presentation/cubit/shortener_cubit.dart';
import 'package:url_shortener/presentation/pages/home_page.dart';

class MockShortenUrlUseCase extends Mock implements ShortenUrlUseCase {}

void main() {
  late MockShortenUrlUseCase mockUsecase;
  late ShortenerCubit cubit;

  const inputUrl = 'https://flutter.dev';

  setUp(() {
    mockUsecase = MockShortenUrlUseCase();
    cubit = ShortenerCubit(mockUsecase);
    registerFallbackValue(inputUrl);
  });

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const HomePage()),
      ),
    );
  }

  testWidgets(
    'presentation/home_page → success flow should render new shortened item in list',
    (tester) async {
      // arrange
      when(() => mockUsecase.call(inputUrl)).thenAnswer(
        (_) async => const AliasEntity(
          alias: 'flutter.dev',
          originalUrl: inputUrl,
          shortUrl: 'https://short/flutter.dev',
        ),
      );

      await pumpHome(tester);

      // act
      await tester.enterText(find.byKey(const Key('kInputUrl')), inputUrl);
      await tester.tap(find.byKey(const Key('kButtonShorten')));

      await tester.pump(); // resolve loading -> success
      await tester.pumpAndSettle();

      // assert
      final listFinder = find.byKey(const Key('kListShortened'));
      expect(listFinder, findsOneWidget);

      final item0 = find.byKey(const Key('kShortItem-0'));
      expect(item0, findsOneWidget);

      expect(
        find.descendant(
          of: item0,
          matching: find.text('https://short/flutter.dev'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: item0, matching: find.text(inputUrl)),
        findsOneWidget,
      );

      verify(() => mockUsecase.call(inputUrl)).called(1);
    },
  );
}
