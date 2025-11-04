import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/domain/entities/alias_entity.dart';
import '../../lib/domain/usecases/shorten_url_usecase.dart';
import '../../lib/presentation/cubit/shortener_cubit.dart';
import '../../lib/presentation/pages/home_page.dart';

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

  Future<void> pumpHomePage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const HomePage(),
        ),
      ),
    );
  }

  testWidgets('full flow: type + tap + success render', (tester) async {
    when(() => mockUsecase.call(inputUrl)).thenAnswer((_) async {
      return const AliasEntity(
        alias: 'flutter.dev',
        originalUrl: inputUrl,
        shortUrl: 'https://short/flutter.dev',
      );
    });

    await pumpHomePage(tester);

    await tester.enterText(find.byKey(const Key('kInputUrl')), inputUrl);
    await tester.tap(find.byKey(const Key('kButtonShorten')));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('kListShortened')), findsOneWidget);
    expect(find.text('https://short/flutter.dev'), findsOneWidget);
    expect(find.text(inputUrl), findsOneWidget);

    verify(() => mockUsecase.call(inputUrl)).called(1);
  });
}
